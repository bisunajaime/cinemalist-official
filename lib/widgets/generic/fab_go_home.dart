import 'package:flutter/material.dart';

class FABGoHome extends StatelessWidget {
  const FABGoHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Tap to go home',
      elevation: 0,
      onPressed: () {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      backgroundColor: Colors.red,
      child: Icon(
        Icons.home,
        color: Colors.white,
      ),
    );
  }
}
