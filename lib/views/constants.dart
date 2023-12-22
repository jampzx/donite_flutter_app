import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

TextStyle kLoginTitleStyle(Size size) => GoogleFonts.ubuntu(
    fontSize: size.height * 0.035, fontWeight: FontWeight.bold);

TextStyle kLoginSubtitleStyle(Size size) => GoogleFonts.ubuntu(
      fontSize: size.height * 0.025,
    );
TextStyle kForgotStyle(Size size) => GoogleFonts.ubuntu(
    fontSize: size.height * 0.030, fontWeight: FontWeight.bold);

TextStyle kWaitingVerificationStyle(Size size) => GoogleFonts.ubuntu(
    fontSize: size.height * 0.025, fontWeight: FontWeight.bold);

TextStyle kForgotPasswordStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 15, color: Colors.green, height: 1.5);

TextStyle kPasswordUpdatedStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 13, color: Colors.green, height: 1.5);

TextStyle kLoginTermsAndPrivacyStyle(Size size) =>
    GoogleFonts.ubuntu(fontSize: 12, color: Colors.grey, height: 1.5);

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
      color: Colors.green,
    );

TextStyle kTextFormFieldStyle() => const TextStyle(color: Colors.black);

TextStyle regularFont() =>
    GoogleFonts.ubuntu(fontSize: 12, color: Colors.black);
TextStyle titleFont() => GoogleFonts.ubuntu(
    fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold);

//Color backgroundColor() => Colors.green;
Color foregroundColor() => Colors.green;
