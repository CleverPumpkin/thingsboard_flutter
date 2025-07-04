import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:thingsboard_app/constants/enviroment_variables.dart';
import 'package:thingsboard_app/core/auth/oauth2/app_secret_provider.dart';
import 'package:thingsboard_app/core/auth/oauth2/tb_oauth2_client.dart';
import 'package:thingsboard_app/core/context/tb_context_widget.dart';
import 'package:thingsboard_app/core/logger/tb_logger.dart';
import 'package:thingsboard_app/locator.dart';
import 'package:thingsboard_app/modules/dashboard/domain/entites/dashboard_arguments.dart';
import 'package:thingsboard_app/modules/version/route/version_route.dart';
import 'package:thingsboard_app/modules/version/route/version_route_arguments.dart';
import 'package:thingsboard_app/thingsboard_client.dart';
import 'package:thingsboard_app/utils/services/endpoint/i_endpoint_service.dart';
import 'package:thingsboard_app/utils/services/firebase/i_firebase_service.dart';
import 'package:thingsboard_app/utils/services/layouts/i_layout_service.dart';
import 'package:thingsboard_app/utils/services/local_database/i_local_database_service.dart';
import 'package:thingsboard_app/utils/services/notification_service.dart';
import 'package:thingsboard_app/utils/services/widget_action_handler.dart';
import 'package:thingsboard_app/utils/services/wl_service.dart';
import 'package:toastification/toastification.dart';
import 'package:universal_platform/universal_platform.dart';

part 'has_tb_context.dart';

enum NotificationType { info, warn, success, error }

class TbContext implements PopEntry {
  TbContext(this.router) {
    _widgetActionHandler = WidgetActionHandler(this);
    wlService = WlService(this);
  }

  static final deviceInfoPlugin = DeviceInfoPlugin();
  bool isUserLoaded = false;
  final _isAuthenticated = ValueNotifier<bool>(false);
  late PlatformType platformType;
  List<TwoFaProviderInfo>? twoFactorAuthProviders;
  User? userDetails;
  AllowedPermissionsInfo? userPermissions;
  HomeDashboardInfo? homeDashboard;
  VersionInfo? versionInfo;
  StoreInfo? storeInfo;
  final _isLoadingNotifier = ValueNotifier<bool>(false);
  final _log = TbLogger();
  late final WidgetActionHandler _widgetActionHandler;
  AndroidDeviceInfo? androidInfo;
  IosDeviceInfo? iosInfo;
  late String packageName;
  late PlatformVersion version;

  StreamSubscription? _appLinkStreamSubscription;
  final appLinks = AppLinks();

  bool _closeMainFirst = false;
  late bool _handleRootState;

  @override
  final canPopNotifier = ValueNotifier<bool>(false);

  @override
  void onPopInvoked(bool didPop) {
    onPopInvokedImpl(didPop);
  }

  @override
  void onPopInvokedWithResult(bool didPop, result) {
    onPopInvokedImpl(didPop, result);
  }

  late ThingsboardClient tbClient;
  late TbOAuth2Client oauth2Client;
  late final WlService wlService;

  final FluroRouter router;
  final routeObserver = RouteObserver<PageRoute>();

  Listenable get isAuthenticatedListenable => _isAuthenticated;

  bool get isAuthenticated => _isAuthenticated.value;

  TbContextState? currentState;

  TbLogger get log => _log;

  WidgetActionHandler get widgetActionHandler => _widgetActionHandler;

  final bottomNavigationTabChangedStream = StreamController<int>.broadcast();

  Future<void> init() async {
    _handleRootState = true;

    final endpoint = await getIt<IEndpointService>().getEndpoint();
    log.debug('TbContext::init() endpoint: $endpoint');

    tbClient = ThingsboardClient(
      endpoint,
      storage: getIt(),
      onUserLoaded: onUserLoaded,
      onError: onError,
      onLoadStarted: onLoadStarted,
      onLoadFinished: onLoadFinished,
      computeFunc: <Q, R>(callback, message) => compute(callback, message),
      debugMode: EnvironmentVariables.apiCalls || EnvironmentVariables.verbose,
    );

    oauth2Client = TbOAuth2Client(
      tbContext: this,
      appSecretProvider: AppSecretProvider.local(),
    );

    try {
      if (UniversalPlatform.isAndroid) {
        androidInfo = await deviceInfoPlugin.androidInfo;
        platformType = PlatformType.ANDROID;
      } else if (UniversalPlatform.isIOS) {
        iosInfo = await deviceInfoPlugin.iosInfo;
        platformType = PlatformType.IOS;
      } else {
        platformType = PlatformType.WEB;
      }

      if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        final packageInfo = await PackageInfo.fromPlatform();
        packageName = packageInfo.packageName;
        version = PlatformVersion.fromString(packageInfo.version);
      } else {
        packageName = 'web.app';
      }
      try {
        final initialUri = await appLinks.getInitialLink();
        _updateInitialNavigation(initialUri);
      } catch (e) {
        log.error('Failed to get initial uri: $e', e);
      }
      await tbClient.init();
      if (UniversalPlatform.isAndroid || UniversalPlatform.isIOS) {
        appLinks.uriLinkStream.listen(
          (Uri? uri) {
            _updateInitialNavigation(uri);
            handleInitialNavigation();
          },
          onError: (e) {
            log.error('Failed to get new initial uri: $e', e);
          },
        );
      }
    } catch (e, s) {
      log.error('Failed to init tbContext: $e', e, s);
      await onFatalError(e);
    }
  }

  Future<void> _updateInitialNavigation(Uri? initialUri) async {
    String? initialNavigation;

    if (initialUri != null && initialUri.path.isNotEmpty) {
      initialNavigation = initialUri.path;
      if (initialUri.hasQuery) {
        initialNavigation = '$initialNavigation?${initialUri.query}';
      }
      await getIt<ILocalDatabaseService>().setInitialAppLink(initialNavigation);
      log.debug('Initial navigation: $initialNavigation');
    }
  }

  Future<void> reInit({
    required String endpoint,
    required VoidCallback onDone,
    required ErrorCallback onAuthError,
  }) async {
    log.debug('TbContext:reinit()');

    _handleRootState = false;

    tbClient = ThingsboardClient(
      endpoint,
      storage: getIt(),
      onUserLoaded: () => onUserLoaded(onDone: onDone),
      onError: (error) {
        onAuthError(error);
        onError(error);
      },
      onLoadStarted: onLoadStarted,
      onLoadFinished: onLoadFinished,
      computeFunc: <Q, R>(callback, message) => compute(callback, message),
      debugMode: EnvironmentVariables.apiCalls || EnvironmentVariables.verbose,
    );

    oauth2Client = TbOAuth2Client(
      tbContext: this,
      appSecretProvider: AppSecretProvider.local(),
    );

    await tbClient.init();
  }

  Future<void> onFatalError(e) async {
    var message = e is ThingsboardError
        ? (e.message ?? 'Unknown error.')
        : 'Unknown error.';
    message = 'Критическая ошибка:\n$message.';
    await alert(title: 'Ошибка', message: message, ok: 'Закрыть');
    //logout();
  }

  void onError(ThingsboardError tbError) {
    log.error('onError', tbError, tbError.getStackTrace());
    showErrorNotification(tbError.message!);
  }

  void showErrorNotification(
    String message, {
    Duration? duration,
  }) {
    showNotification(
      message,
      NotificationType.error,
      duration: duration,
    );
  }

  void showInfoNotification(
    String message, {
    BuildContext? context,
    Duration? duration,
  }) {
    showNotification(message, NotificationType.info, duration: duration);
  }

  void showWarnNotification(String message, {Duration? duration}) {
    showNotification(message, NotificationType.warn, duration: duration);
  }

  void showSuccessNotification(String message, {Duration? duration}) {
    showNotification(message, NotificationType.success, duration: duration);
  }

  void showNotification(
    String message,
    NotificationType type, {
    Duration? duration,
  }) {
    duration ??= const Duration(days: 1);
    Color backgroundColor;
    ToastificationType toastificationType;
    switch (type) {
      case NotificationType.info:
        backgroundColor = const Color(0xFF323232);
        toastificationType = ToastificationType.info;
        break;
      case NotificationType.warn:
        backgroundColor = const Color(0xFFdc6d1b);
        toastificationType = ToastificationType.warning;
        break;
      case NotificationType.success:
        backgroundColor = const Color(0xFF008000);
        toastificationType = ToastificationType.success;
        break;
      case NotificationType.error:
        backgroundColor = const Color(0xFF800000);
        toastificationType = ToastificationType.error;
        break;
    }

    toastification.show(
      type: toastificationType,
      style: ToastificationStyle.fillColored,
      primaryColor: backgroundColor,
      backgroundColor: Colors.white,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: duration,
      title: Text(message, maxLines: 10, overflow: TextOverflow.ellipsis),
      closeOnClick: false,
      dragToClose: true,
      showProgressBar: false,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        ),
      ],
    );
  }

  void hideNotification() {
    toastification.dismissAll();
  }

  void onLoadStarted() {
    log.debug('TbContext: On load started.');
    _isLoadingNotifier.value = true;
  }

  void onLoadFinished() async {
    log.debug('TbContext: On load finished.');
    _isLoadingNotifier.value = false;
  }

  Future<void> onUserLoaded({VoidCallback? onDone}) async {
    try {
      log.debug(
        'TbContext.onUserLoaded: isAuthenticated=${tbClient.isAuthenticated()}',
      );
      isUserLoaded = true;
      if (tbClient.isAuthenticated() && !tbClient.isPreVerificationToken()) {
        log.debug('authUser: ${tbClient.getAuthUser()}');
        if (tbClient.getAuthUser()!.userId != null) {
          try {
            userPermissions = await tbClient
                .getUserPermissionsService()
                .getAllowedPermissions();

            final mobileInfo =
                await tbClient.getMobileService().getUserMobileInfo(
                      MobileInfoQuery(
                        platformType: platformType,
                        packageName: packageName,
                      ),
                    );

            userDetails = mobileInfo?.user;
            homeDashboard = mobileInfo?.homeDashboardInfo;
            versionInfo = mobileInfo?.versionInfo;
            storeInfo = mobileInfo?.storeInfo;
            getIt<ILayoutService>().cachePageLayouts(
              mobileInfo?.pages,
              authority: tbClient.getAuthUser()!.authority,
            );
          } catch (e) {
            log.error('TbContext::onUserLoaded error $e');
            if (!_isConnectionError(e)) {
              logout();
            } else {
              rethrow;
            }
          }
        }
      } else {
        if (tbClient.isPreVerificationToken()) {
          log.debug('authUser: ${tbClient.getAuthUser()}');
          twoFactorAuthProviders = await tbClient
              .getTwoFactorAuthService()
              .getAvailableLoginTwoFaProviders();
        } else {
          twoFactorAuthProviders = null;
        }

        userDetails = null;
        userPermissions = null;
        homeDashboard = null;
        versionInfo = null;
        storeInfo = null;
      }

      _isAuthenticated.value =
          tbClient.isAuthenticated() && !tbClient.isPreVerificationToken();
      await wlService.updateWhiteLabeling();
      if (versionInfo != null && versionInfo?.minVersion != null) {
        if (version.versionInt() <
            (versionInfo!.minVersion?.versionInt() ?? 0)) {
          navigateTo(
            VersionRoutes.updateRequiredRoutePath,
            clearStack: true,
            replace: true,
            routeSettings: RouteSettings(
              arguments: VersionRouteArguments(
                versionInfo: versionInfo!,
                storeInfo: storeInfo,
              ),
            ),
          );
          return;
        }
      }

      if (isAuthenticated) {
        onDone?.call();
      }

      if (_handleRootState) {
        await updateRouteState();
      }

      if (isAuthenticated) {
        if (getIt<IFirebaseService>().apps.isNotEmpty) {
          await NotificationService(tbClient, log, this).init();
        }
      }
    } catch (e, s) {
      log.error('TbContext.onUserLoaded: $e', e, s);

      if (_isConnectionError(e)) {
        final res = await confirm(
          title: 'Ошибка подключения',
          message: 'Не удалось подключиться к серверу',
          cancel: 'Отмена',
          ok: 'Повторить',
        );
        if (res == true) {
          onUserLoaded();
        } /*else { // Disabled to prevent logout on network error
          navigateTo(
            '/login',
            replace: true,
            clearStack: true,
            transition: TransitionType.fadeIn,
            transitionDuration: const Duration(milliseconds: 750),
          );
        }*/
      } else {
        // Disabled to prevent logout on network error
        /*navigateTo(
          '/login',
          replace: true,
          clearStack: true,
          transition: TransitionType.fadeIn,
          transitionDuration: const Duration(milliseconds: 750),
        );*/
      }
    } finally {
      try {
        final link = await getIt<ILocalDatabaseService>().getInitialAppLink();
        navigateByAppLink(link);
      } catch (e) {
        log.error('TbContext:getInitialUri() exception $e');
      }

      _appLinkStreamSubscription ??= appLinks.uriLinkStream.listen(
        (link) {
          navigateByAppLink(link.toString());
        },
        onError: (err) {
          log.error('linkStream.listen $err');
        },
      );
    }
  }

  Future<void> navigateByAppLink(String? link) async {
    if (link != null && !link.contains('signup/emailVerified')) {
      final uri = Uri.parse(link);
      await getIt<ILocalDatabaseService>().deleteInitialAppLink();

      log.debug('TbContext: navigate by appLink $uri');
      navigateTo(
        uri.path,
        routeSettings: RouteSettings(
          arguments: {...uri.queryParameters, 'uri': uri},
        ),
      );
    }
  }

  Future<void> logout({
    RequestConfig? requestConfig,
    bool notifyUser = true,
  }) async {
    log.debug('TbContext::logout($requestConfig, $notifyUser)');
    _handleRootState = true;

    if (getIt<IFirebaseService>().apps.isNotEmpty) {
      await NotificationService(tbClient, log, this).logout();
    }

    await tbClient.logout(
      requestConfig: requestConfig,
      notifyUser: notifyUser,
    );

    _appLinkStreamSubscription?.cancel();
    _appLinkStreamSubscription = null;
  }

  bool _isConnectionError(e) {
    return e is ThingsboardError &&
        e.errorCode == ThingsBoardErrorCode.general &&
        e.message == 'Unable to connect';
  }

  bool hasGenericPermission(Resource resource, Operation operation) {
    if (userPermissions != null) {
      return userPermissions!.hasGenericPermission(resource, operation);
    } else {
      return false;
    }
  }

  Future<bool> handleInitialNavigation() async {
    final initialNavigation =
        await getIt<ILocalDatabaseService>().getInitialAppLink();

    log.debug('TbContext::handleInitialNavigation() -> $initialNavigation');

    if (initialNavigation != null &&
        initialNavigation.startsWith('/signup/emailVerified')) {
      if (tbClient.isAuthenticated()) {
        tbClient.logout();
      } else {
        navigateTo(
          initialNavigation,
          replace: true,
          clearStack: true,
          transition: TransitionType.fadeIn,
          transitionDuration: const Duration(milliseconds: 750),
        );
        getIt<ILocalDatabaseService>().deleteInitialAppLink();
      }
      return true;
    }

    return false;
  }

  Future<void> updateRouteState() async {
    log.debug(
      'TbContext:updateRouteState() ${currentState != null && currentState!.mounted}',
    );
    if (currentState != null) {
      if (!await handleInitialNavigation()) {
        if (tbClient.isAuthenticated() && !tbClient.isPreVerificationToken()) {
          var defaultDashboardId = _defaultDashboardId();
          if (defaultDashboardId != null) {
            bool fullscreen = _userForceFullscreen();
            if (!fullscreen) {
              await navigateToDashboard(defaultDashboardId, animate: false);
              navigateTo(
                '/main',
                replace: true,
                closeDashboard: false,
                clearStack: true,
                transition: TransitionType.none,
              );
            } else {
              navigateTo(
                '/fullscreenDashboard/$defaultDashboardId',
                replace: true,
                clearStack: true,
                transition: TransitionType.fadeIn,
              );
            }
          } else {
            navigateTo(
              '/main',
              replace: true,
              clearStack: true,
              transition: TransitionType.fadeIn,
              transitionDuration: const Duration(milliseconds: 750),
            );
          }
        } else {
          navigateTo(
            '/login',
            replace: true,
            clearStack: true,
            transition: TransitionType.fadeIn,
            transitionDuration: const Duration(milliseconds: 750),
          );
        }
      }
    }
  }

  String? _defaultDashboardId() {
    if (userDetails != null && userDetails!.additionalInfo != null) {
      return userDetails!.additionalInfo!['defaultDashboardId'];
    }
    return null;
  }

  bool _userForceFullscreen() {
    return tbClient.getAuthUser()!.isPublic! ||
        (userDetails != null &&
            userDetails!.additionalInfo != null &&
            userDetails!.additionalInfo!['defaultDashboardFullscreen'] == true);
  }

  bool isPhysicalDevice() {
    if (UniversalPlatform.isAndroid) {
      return androidInfo!.isPhysicalDevice == true;
    } else if (UniversalPlatform.isIOS) {
      return iosInfo!.isPhysicalDevice;
    } else {
      return false;
    }
  }

  String userAgent() {
    String userAgent = 'Mozilla/5.0';
    if (UniversalPlatform.isAndroid) {
      userAgent +=
          ' (Linux; Android ${androidInfo!.version.release}; ${androidInfo?.model})';
    } else if (UniversalPlatform.isIOS) {
      userAgent += ' (${iosInfo!.model})';
    }
    userAgent +=
        ' AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/83.0.4103.106 Mobile Safari/537.36';
    return userAgent;
  }

  bool isHomePage() {
    if (currentState != null) {
      if (currentState is TbMainState) {
        var mainState = currentState as TbMainState;
        return mainState.isHomePage();
      }
    }
    return false;
  }

  Future<dynamic> navigateTo(
    String path, {
    bool replace = false,
    bool clearStack = false,
    closeDashboard = true,
    TransitionType? transition,
    Duration? transitionDuration,
    bool restoreDashboard = true,
    RouteSettings? routeSettings,
  }) async {
    if (currentState != null) {
      hideNotification();

      if (currentState is TbMainState) {
        var mainState = currentState as TbMainState;
        if (mainState.canNavigate(path) && !replace) {
          mainState.navigateToPath(path);
          return;
        }
      }

      if (transition != TransitionType.nativeModal) {
        transition = TransitionType.none;
      } else if (transition == null) {
        if (replace) {
          transition = TransitionType.fadeIn;
        } else {
          transition = TransitionType.native;
        }
      }

      return await router.navigateTo(
        currentState!.context,
        path,
        transition: transition,
        transitionDuration: transitionDuration,
        replace: replace,
        clearStack: clearStack,
        routeSettings: routeSettings,
      );
    }
  }

  Future<void> navigateToDashboard(
    String dashboardId, {
    String? dashboardTitle,
    String? state,
    bool? hideToolbar,
    bool animate = true,
  }) async {
    return router.navigateTo(
      currentState!.context,
      '/dashboard',
      routeSettings: RouteSettings(
        arguments: DashboardArgumentsEntity(
          dashboardId,
          title: dashboardTitle,
          state: state,
          hideToolbar: hideToolbar,
          animate: animate,
        ),
      ),
    );
  }

  Future<T?> showFullScreenDialog<T>(Widget dialog, {BuildContext? context}) {
    return Navigator.of(context ?? currentState!.context).push<T>(
      MaterialPageRoute<T>(
        builder: (BuildContext context) {
          return dialog;
        },
        fullscreenDialog: true,
      ),
    );
  }

  void pop<T>([T? result, BuildContext? context]) async {
    var targetContext = context ?? currentState?.context;
    if (targetContext != null) {
      router.pop<T>(targetContext, result);
    }
  }

  void onPopInvokedImpl<T>(bool didPop, [T? result]) async {
    if (didPop) {
      return;
    }

    if (await currentState!.willPop()) {
      var navigator = Navigator.of(currentState!.context);
      if (navigator.canPop()) {
        navigator.pop(result);
      } else {
        SystemNavigator.pop();
      }
    }
  }

  Future<void> alert({
    required String title,
    required String message,
    String ok = 'Ok',
  }) {
    return showDialog<bool>(
      context: currentState!.context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => pop(null, context), child: Text(ok)),
        ],
      ),
    );
  }

  Future<bool?> confirm({
    required String title,
    required String message,
    String cancel = 'Cancel',
    String ok = 'Ok',
  }) {
    return showDialog<bool>(
      context: currentState!.context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => pop(false, context),
            child: Text(cancel),
          ),
          TextButton(onPressed: () => pop(true, context), child: Text(ok)),
        ],
      ),
    );
  }
}
