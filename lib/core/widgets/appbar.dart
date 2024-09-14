import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_styles.dart';

class AppbarWidget extends StatelessWidget {
  String txt;

 AppbarWidget({super.key,required this.txt});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        children: [
          SizedBox(
            width:MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/appbar2.png',
              height: 66,
              fit:BoxFit.cover
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top:28.0),
            child: Row(
              mainAxisAlignment:MainAxisAlignment.center,
              children: [
                Center(child: Text(txt,style:Styles.lightTextStyleBold,)),
               const SizedBox(width: 44,),
            
                Image.asset('assets/images/menn2.png')
            
              ],
            ),
          ),



          //Image.asset('assets/images/appName.png',height: 66,fit:BoxFit.cover),

         

        ],
      ),
      onTap: () {},
    );
  }
}
