// ignore_for_file: file_names

import 'package:flutter/material.dart';

import '../resources/app_colors.dart';


  // ignore: must_be_immutable
  class CustomButton extends StatelessWidget {

  final String  text;
  final Function  onPressed;
  Color color1;
  Color color2;

  CustomButton({super.key, 
    required this.text,
    required this.onPressed,
    this.color1=Colors.grey,
    this.color2=Colors.white,
  });


  @override
  Widget build(BuildContext context) {
    return
      SizedBox(
        width:150,
        height:50,
        child:InkWell(
          child: 
          Container(
            decoration:  BoxDecoration(
              color: AppColors.primary,
                borderRadius: const BorderRadius.all(Radius.circular(22)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child:Padding(
                padding: const EdgeInsets.all(4.0),
                child: 
                Text(
                  text,style:const TextStyle(color:Colors.white,fontSize: 17,
                fontWeight: FontWeight.bold
                ),
                ),
              
              ),
            ),
          ),
          onTap:(){
            onPressed();
          }
        )


        // RaisedButton(
        //
        //   elevation: 10,
        //   onPressed: onPressed(),
        //   color: color1,
        //   // shape: RoundedRectangleBorder(
        //   //     borderRadius: BorderRadius.circular(30)),
        //   child: Padding(
        //     padding: EdgeInsets.all(10),
        //     child: Text(
        //       text,
        //       style: getRegularStyle(color: color2,fontSize:20)
        //     ),
        //   ),
        // ),
      );



    }
}