import 'package:flutter/material.dart';
import 'package:cinemalist/styles/theme.dart';

class FABGoHome extends StatelessWidget {
  const FABGoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      tooltip: 'Go home',
      heroTag: 'home',
      elevation: 4,
      onPressed: () {
        while (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      backgroundColor: AppColors.card,
      child: const Icon(Icons.home_rounded, color: AppColors.textPrimary),
    );
  }
}
