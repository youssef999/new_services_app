
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:google_fonts/google_fonts.dart';


abstract class Styles {

  static dynamic primaryTextStyle =

      GoogleFonts.cairo(
  textStyle: TextStyle(  fontSize: 16,
    color:kTextPrimaryColor,
    fontWeight: FontWeight.w600,),
  );



  //
  // TextStyle(
  //    fontSize: 16,
  //    color:kTextPrimaryColor,
  //   fontWeight: FontWeight.w600,
  // );

  static dynamic primaryTextStyleBold =

  GoogleFonts.cairo(
    textStyle: TextStyle(
          fontSize: 16,
          color:kTextPrimaryColor,
        fontWeight: FontWeight.w700,

    ),
  );

  // TextStyle(
  //    fontSize: 16,
  //    color:kTextPrimaryColor,
  //   fontWeight: FontWeight.w700,
  // );

   static dynamic primaryTextStyleLarge =
   GoogleFonts.cairo(
     textStyle: TextStyle(
          fontSize: 32,
          color:kTextPrimaryColor,
         fontWeight: FontWeight.bold
     ),
   );


  //  TextStyle(
  //    fontSize: 32,
  //    color:kTextPrimaryColor,
  //   fontWeight: FontWeight.bold
  //
  // );

   static dynamic primaryTextStyleSmall =

   GoogleFonts.cairo(
     textStyle: TextStyle(
          fontSize: 12,
          color:kTextPrimaryColor,
         fontWeight: FontWeight.w600,
     ),
   );


  static dynamic lightTextStyle =
  GoogleFonts.cairo(
    textStyle: TextStyle(
      fontSize: 16,
      color:kTextHelperLightColor,
      fontWeight: FontWeight.w600,
    ),
  );


   static dynamic lightTextStyleBold =

   GoogleFonts.cairo(
     textStyle: TextStyle(
       fontSize: 16,
       color:kTextHelperLightColor,
       fontWeight: FontWeight.w700,
     ),
   );


   static dynamic appBarTextStyle =
   GoogleFonts.cairo(
     textStyle: TextStyle(
       fontSize: 24,
       color:kTextHelperLightColor,
       fontWeight: FontWeight.w700,
     ),
   );



  static dynamic darkTextStyle =



  GoogleFonts.cairo(
    textStyle: TextStyle(
      fontSize: 14,
      color:kTextHelperDarkColor,
      fontWeight: FontWeight.w600,
    ),
  );




  static dynamic darkTextStyleBold =
  GoogleFonts.cairo(
    textStyle: TextStyle(
      fontSize: 16,
      color:kTextHelperDarkColor,
      fontWeight: FontWeight.w700,
    ),
  );
}

const TextStyle textStyle = TextStyle();
