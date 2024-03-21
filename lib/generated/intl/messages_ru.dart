// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(appTitle) =>
      "Поздравляем! ${appTitle} аккаунт был активирован. Теперь вы можете войти в аккаунт";

  static String m1(contact) =>
      "Защитный код был отправлен на ваш email по адресу ${contact}.";

  static String m2(time) => "Повторно отправить код через ${time} сек.";

  static String m3(contact) =>
      "Код безопасности был отправлен на ваш телефон ${contact}.";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "accept": MessageLookupByLibrary.simpleMessage("Принять"),
        "acceptPrivacyPolicyMessage": MessageLookupByLibrary.simpleMessage(
            "Вы должны принять нашу Политику конфиденциальности"),
        "acceptTermsOfUseMessage": MessageLookupByLibrary.simpleMessage(
            "Вы должны принять наши Пользовательское Соглашение"),
        "accountActivated": MessageLookupByLibrary.simpleMessage(
            "Аккаунт успешно активирован!"),
        "accountActivatedText": m0,
        "actionData": MessageLookupByLibrary.simpleMessage("Данные действия"),
        "activatingAccount":
            MessageLookupByLibrary.simpleMessage("Активация учетной записи..."),
        "activatingAccountText": MessageLookupByLibrary.simpleMessage(
            "В настоящее время ваша учетная запись активируется. Подождите"),
        "active": MessageLookupByLibrary.simpleMessage("Подключено"),
        "address": MessageLookupByLibrary.simpleMessage("Адрес 1"),
        "address2": MessageLookupByLibrary.simpleMessage("Адрес 2"),
        "alarmAcknowledgeText": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите подтвердить тревогу?"),
        "alarmAcknowledgeTitle":
            MessageLookupByLibrary.simpleMessage("Подтвердить тревогу"),
        "alarmClearText": MessageLookupByLibrary.simpleMessage(
            "Вы уверены, что хотите очистить сигналы тревоги?"),
        "alarmClearTitle":
            MessageLookupByLibrary.simpleMessage("Очистить сигнал тревоги"),
        "alarms": MessageLookupByLibrary.simpleMessage("События"),
        "allDevices": MessageLookupByLibrary.simpleMessage("Все устройства"),
        "alreadyHaveAnAccount":
            MessageLookupByLibrary.simpleMessage("У вас уже есть аккаунт?"),
        "appTitle": MessageLookupByLibrary.simpleMessage("Korvet Live"),
        "assetName": MessageLookupByLibrary.simpleMessage("Имя объекта"),
        "assets": MessageLookupByLibrary.simpleMessage("Объекты"),
        "assignedToCustomer":
            MessageLookupByLibrary.simpleMessage("Назначено клиенту"),
        "auditLogDetails": MessageLookupByLibrary.simpleMessage(
            "Подробности журнала изменений"),
        "auditLogs": MessageLookupByLibrary.simpleMessage("Журнал изменений"),
        "backupCodeAuthDescription": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите один из ваших резервных кодов."),
        "backupCodeAuthPlaceholder":
            MessageLookupByLibrary.simpleMessage("Резервный код"),
        "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
        "changePassword":
            MessageLookupByLibrary.simpleMessage("Изменить пароль"),
        "city": MessageLookupByLibrary.simpleMessage("Город"),
        "confirmNotRobotMessage": MessageLookupByLibrary.simpleMessage(
            "Вы должны подтвердить, что вы не робот"),
        "continueText": MessageLookupByLibrary.simpleMessage("Продолжить"),
        "country": MessageLookupByLibrary.simpleMessage("Страна"),
        "createAccount":
            MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "createPasswordStar":
            MessageLookupByLibrary.simpleMessage("Создать пароль *"),
        "currentPassword":
            MessageLookupByLibrary.simpleMessage("Текущий пароль"),
        "currentPasswordRequireText":
            MessageLookupByLibrary.simpleMessage("Требуется текущий пароль"),
        "currentPasswordStar":
            MessageLookupByLibrary.simpleMessage("Текущий пароль *"),
        "customer": MessageLookupByLibrary.simpleMessage("Клиент"),
        "customers": MessageLookupByLibrary.simpleMessage("Клиенты"),
        "devices": MessageLookupByLibrary.simpleMessage("Устройства"),
        "email": MessageLookupByLibrary.simpleMessage("Email"),
        "emailAuthDescription": m1,
        "emailAuthPlaceholder":
            MessageLookupByLibrary.simpleMessage("Email код"),
        "emailInvalidText":
            MessageLookupByLibrary.simpleMessage("Неверный формат Email"),
        "emailRequireText":
            MessageLookupByLibrary.simpleMessage("Требуется Email"),
        "emailStar": MessageLookupByLibrary.simpleMessage("Email *"),
        "emailVerification":
            MessageLookupByLibrary.simpleMessage("Подтверждение адреса Email"),
        "emailVerificationInstructionsText": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, следуйте инструкциям, приведенным в Email, чтобы завершить процедуру регистрации.. Note: Если вы какое-то время не видели письмо, проверьте папку «Спам» или попробуйте отправить письмо повторно, нажав кнопку «Отправить повторно»."),
        "emailVerificationSentText": MessageLookupByLibrary.simpleMessage(
            "На указанный Email было отправлено письмо с данными для проверки"),
        "emailVerified":
            MessageLookupByLibrary.simpleMessage("Email подтвержден"),
        "entityType": MessageLookupByLibrary.simpleMessage("Тип объекта"),
        "failureDetails":
            MessageLookupByLibrary.simpleMessage("Сведения об отказе"),
        "firstName": MessageLookupByLibrary.simpleMessage("Имя"),
        "firstNameRequireText":
            MessageLookupByLibrary.simpleMessage("Требуется имя"),
        "firstNameStar": MessageLookupByLibrary.simpleMessage("Имя *"),
        "firstNameUpper": MessageLookupByLibrary.simpleMessage("Имя"),
        "home": MessageLookupByLibrary.simpleMessage("Главная"),
        "imNotARobot": MessageLookupByLibrary.simpleMessage("я не робот"),
        "inactive": MessageLookupByLibrary.simpleMessage("Отключено"),
        "inactiveUserAlreadyExists": MessageLookupByLibrary.simpleMessage(
            "Неактивный пользователь уже существует"),
        "inactiveUserAlreadyExistsMessage": MessageLookupByLibrary.simpleMessage(
            "Уже есть зарегистрированный пользователь с неподтвержденным адресом Email. Нажмите кнопку «Повторно отправить», если вы хотите повторно отправить Email с подтверждением"),
        "invalidPasswordLengthMessage": MessageLookupByLibrary.simpleMessage(
            "Ваш пароль должен быть не менее 6 символов"),
        "label": MessageLookupByLibrary.simpleMessage("Название"),
        "lastName": MessageLookupByLibrary.simpleMessage("Фамилия"),
        "lastNameRequireText":
            MessageLookupByLibrary.simpleMessage("Требуется фамилия"),
        "lastNameStar": MessageLookupByLibrary.simpleMessage("Фамилия *"),
        "lastNameUpper": MessageLookupByLibrary.simpleMessage("Фамилия"),
        "listIsEmptyText": MessageLookupByLibrary.simpleMessage(
            "В настоящее время список пуст"),
        "login": MessageLookupByLibrary.simpleMessage("Войти"),
        "loginNotification":
            MessageLookupByLibrary.simpleMessage("Войдите в свой аккаунт"),
        "logoDefaultValue": MessageLookupByLibrary.simpleMessage("Korvet Live"),
        "logout": MessageLookupByLibrary.simpleMessage("Выйти"),
        "mfaProviderBackupCode":
            MessageLookupByLibrary.simpleMessage("Резервный код"),
        "mfaProviderEmail": MessageLookupByLibrary.simpleMessage("Email"),
        "mfaProviderSms": MessageLookupByLibrary.simpleMessage("SMS"),
        "mfaProviderTopt": MessageLookupByLibrary.simpleMessage(
            "Приложение для аутентификации"),
        "more": MessageLookupByLibrary.simpleMessage("Профиль"),
        "newPassword": MessageLookupByLibrary.simpleMessage("Новый пароль"),
        "newPassword2": MessageLookupByLibrary.simpleMessage("новый пароль 2"),
        "newPassword2RequireText": MessageLookupByLibrary.simpleMessage(
            "Снова требуется новый пароль"),
        "newPassword2Star":
            MessageLookupByLibrary.simpleMessage("Новый пароль еще раз *"),
        "newPasswordRequireText":
            MessageLookupByLibrary.simpleMessage("Требуется новый пароль"),
        "newPasswordStar":
            MessageLookupByLibrary.simpleMessage("Новый пароль *"),
        "newUserText":
            MessageLookupByLibrary.simpleMessage("Новый пользователь?"),
        "notifications":
            MessageLookupByLibrary.simpleMessage("Уведомления"),
        "notificationsNotEnabled":
            MessageLookupByLibrary.simpleMessage("Уведомления не настроены. Пожалуйста, свяжитесь со службой поддержки"),
        "notImplemented":
            MessageLookupByLibrary.simpleMessage("Не реализована!"),
        "password": MessageLookupByLibrary.simpleMessage("Пароль"),
        "passwordErrorNotification": MessageLookupByLibrary.simpleMessage(
            "Вводимые пароли должны совпадать!"),
        "passwordForgotText":
            MessageLookupByLibrary.simpleMessage("Забыли пароль?"),
        "passwordRequireText":
            MessageLookupByLibrary.simpleMessage("Необходим пароль."),
        "passwordReset": MessageLookupByLibrary.simpleMessage("Сброс пароля"),
        "passwordResetLinkSuccessfullySentNotification":
            MessageLookupByLibrary.simpleMessage(
                "Ссылка для сброса пароля успешно отправлена!"),
        "passwordResetText": MessageLookupByLibrary.simpleMessage(
            "Введите адрес Email, связанный с вашей учетной записью, и мы отправим письмо со ссылкой для сброса пароля"),
        "passwordSuccessNotification":
            MessageLookupByLibrary.simpleMessage("Пароль успешно изменен"),
        "phone": MessageLookupByLibrary.simpleMessage("Телефон"),
        "postalCode": MessageLookupByLibrary.simpleMessage("Индекс"),
        "privacyPolicy":
            MessageLookupByLibrary.simpleMessage("политика конфиденциальности"),
        "profileSuccessNotification":
            MessageLookupByLibrary.simpleMessage("Профиль успешно обновлен"),
        "repeatPasswordStar":
            MessageLookupByLibrary.simpleMessage("Повторите пароль *"),
        "requestPasswordReset":
            MessageLookupByLibrary.simpleMessage("Запросить сброс пароля"),
        "resend": MessageLookupByLibrary.simpleMessage("Отправить повторно"),
        "resendCode":
            MessageLookupByLibrary.simpleMessage("Отправить код еще раз"),
        "resendCodeWait": m2,
        "selectWayToVerify":
            MessageLookupByLibrary.simpleMessage("Выберите способ проверки"),
        "signIn": MessageLookupByLibrary.simpleMessage("Войти"),
        "signUp": MessageLookupByLibrary.simpleMessage("Зарегистрироваться"),
        "smsAuthDescription": m3,
        "smsAuthPlaceholder": MessageLookupByLibrary.simpleMessage("SMS код"),
        "stateOrProvince": MessageLookupByLibrary.simpleMessage("Область"),
        "systemAdministrator":
            MessageLookupByLibrary.simpleMessage("Системный администратор"),
        "tenantAdministrator": MessageLookupByLibrary.simpleMessage("Владелец"),
        "termsOfUse":
            MessageLookupByLibrary.simpleMessage("Условия использования"),
        "title": MessageLookupByLibrary.simpleMessage("Название"),
        "toptAuthPlaceholder": MessageLookupByLibrary.simpleMessage("Код"),
        "totpAuthDescription": MessageLookupByLibrary.simpleMessage(
            "Пожалуйста, введите защитный код из вашего приложения для проверки подлинности."),
        "tryAgain": MessageLookupByLibrary.simpleMessage("Попробуйте еще раз"),
        "tryAnotherWay":
            MessageLookupByLibrary.simpleMessage("Попробуйте другой способ"),
        "type": MessageLookupByLibrary.simpleMessage("Тип"),
        "username": MessageLookupByLibrary.simpleMessage("Имя пользователя"),
        "verificationCodeIncorrect":
            MessageLookupByLibrary.simpleMessage("Неверный код подтверждения"),
        "verificationCodeInvalid": MessageLookupByLibrary.simpleMessage(
            "Неверный формат кода подтверждения"),
        "verificationCodeManyRequest": MessageLookupByLibrary.simpleMessage(
            "Слишком много запросов проверить код подтверждения"),
        "verifyYourIdentity":
            MessageLookupByLibrary.simpleMessage("Подтвердите вашу личность")
      };
}
