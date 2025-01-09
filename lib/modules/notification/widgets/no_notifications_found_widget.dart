import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/messages.dart';

class NoNotificationsFoundWidget extends StatelessWidget {
  const NoNotificationsFoundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            S.of(context).noNotificationsFound,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
