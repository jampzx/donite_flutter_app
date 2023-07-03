import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
    fontSize: size.height * 0.060, fontWeight: FontWeight.bold);

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.030,
    );
TextStyle kForgotStyle(Size size) => GoogleFonts.ubuntu(
    fontSize: size.height * 0.030, fontWeight: FontWeight.bold);

TextStyle kForgotPasswordStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.blueAccent, height: 1.5);

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.grey, height: 1.5);

TextStyle kHaveAnAccountStyle(Size size) => GoogleFonts.ubuntu(
    //fontSize: size.height * 0.022,
    fontSize: 15,
    color: Colors.grey[900] /*Colors.black*/);

TextStyle kLoginOrRegisterTextStyle(
  Size size,
) =>
    GoogleFonts.ubuntu(
      //fontSize: size.height * 0.022,
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: Colors.blueAccent,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);
