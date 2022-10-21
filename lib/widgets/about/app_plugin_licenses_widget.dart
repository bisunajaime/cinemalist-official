import 'package:flutter/material.dart';

class AppPluginLicensesWidget extends StatelessWidget {
  const AppPluginLicensesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24),
        Text(
          'Plugin Licenses',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Text(
            'Check out the plugin licenses\nby tapping the button below',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 24),
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Color(0xff3b80ff),
            padding: EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 32,
            ),
          ),
          onPressed: () async {
            showLicensePage(context: context);
          },
          child: Text(
            'Plugin Licenses',
            style: TextStyle(
              color: Color(0xffdbefff),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
