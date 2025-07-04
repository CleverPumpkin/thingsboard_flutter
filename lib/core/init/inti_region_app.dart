import 'package:flutter/material.dart';
import 'package:thingsboard_app/core/auth/login/select_region_screen.dart';
import 'package:thingsboard_app/core/context/tb_context_widget.dart';
import 'package:thingsboard_app/locator.dart';
import 'package:thingsboard_app/utils/services/local_database/i_local_database_service.dart';
import 'package:thingsboard_app/widgets/tb_progress_indicator.dart';

class ThingsboardInitRegionApp extends TbPageWidget {
  ThingsboardInitRegionApp(super.tbContext, {super.key});

  @override
  State<StatefulWidget> createState() => _ThingsboardInitAppState();
}

class _ThingsboardInitAppState extends TbPageState<ThingsboardInitRegionApp> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt<ILocalDatabaseService>().getSelectedRegion(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: TbProgressIndicator(tbContext, size: 50.0),
            ),
          );
        }

        // Disable region selection
        /*if (snapshot.hasError || snapshot.data == null) {
          return SelectRegionScreen(tbContext);
        }*/

        initTbContext();

        return Scaffold(
          body: Container(
            alignment: Alignment.center,
            color: Colors.white,
            child: TbProgressIndicator(tbContext, size: 50.0),
          ),
        );
      },
    );
  }
}
