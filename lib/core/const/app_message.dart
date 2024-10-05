import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../resources/app_colors.dart';



appMessage({required String text,required bool fail,required BuildContext context}){

 if(fail==true){

    final snackBar = SnackBar(
     /// need to set following properties for best effect of awesome_snackbar_content
     elevation: 0,
     showCloseIcon: true,
     behavior: SnackBarBehavior.floating,
     backgroundColor: Colors.transparent,

     content: AwesomeSnackbarContent(
       title: text,
       message:'',
       contentType: ContentType.failure,
     ),
   );

   ScaffoldMessenger.of(context)
     ..hideCurrentSnackBar()
     ..showSnackBar(snackBar);

 }else{

   final snackBar = SnackBar(
     elevation: 0,
     behavior: SnackBarBehavior.floating,
     showCloseIcon: true,
     backgroundColor: Colors.transparent,
     content: AwesomeSnackbarContent(
       title: text,
       message:'',
       contentType: ContentType.success,
     ),
   );
   ScaffoldMessenger.of(context)
     ..hideCurrentSnackBar()
     ..showSnackBar(snackBar);

 }
}