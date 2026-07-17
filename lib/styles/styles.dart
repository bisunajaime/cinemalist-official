import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cinemalist/styles/theme.dart';

class Styles {
  // Body/UI text — Inter
  static TextStyle mReg = GoogleFonts.inter(
    color: AppColors.textPrimary,
  );
  static TextStyle mMed = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  static TextStyle mBold = GoogleFonts.inter(
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // Headers — Bebas Neue
  static TextStyle heading = GoogleFonts.bebasNeue(
    color: AppColors.textPrimary,
    letterSpacing: 1.2,
  );
}
