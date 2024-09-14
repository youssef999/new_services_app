

 import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_styles.dart';
import 'package:freelancerApp/core/resources/colors.dart';

class NewAppbar extends StatelessWidget {
  String txt;

   NewAppbar({super.key,required this.txt});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width:MediaQuery.of(context).size.width,
      decoration:BoxDecoration(
        borderRadius:BorderRadius.circular(0),
        gradient: LinearGradient(
          colors: [ kBallColor, kBallColor
            ,  kBallColor,kBallColor2,kBallColor,kBallColor,kBallColor
          ],
        ),
      ),
      child:Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisAlignment:MainAxisAlignment.spaceBetween,
          children: [
          Padding(
            padding: const EdgeInsets.only(top:6.0,right: 4,left: 4),
            child: Image.asset(
            logo2,
            fit: BoxFit.fill,
            width: 60,
            height: 40,
                    ),
          ),
        Padding(
          padding: const EdgeInsets.only(top:6.0),
          child: Text(txt,style:const TextStyle(
            color: Colors.white,fontSize: 30,
              fontWeight: FontWeight.bold
          )),
        ),
        Padding(
          padding: const EdgeInsets.only(top:6.0,right: 4,left: 4),
          child: InkWell(
            child: SizedBox(
              height: 16,
              child: Image.asset(
                menuIcon2,
                fit: BoxFit.cover,
              ),
            )),
        ),

        ],),
      ),
    );
  }
}
