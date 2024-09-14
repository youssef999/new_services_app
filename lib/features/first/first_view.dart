


import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/features/auth/views/login_view.dart';
import 'package:get/get.dart';

class FirstView extends StatelessWidget {
  const FirstView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: AppColors.appBarColor
      ),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children:  [

        const SizedBox(height: 12,),
        Text('مرحبا بك',
        style:TextStyle(color:AppColors.primary,fontSize: 25,
        fontWeight:FontWeight.bold
        ),
        ),
         const SizedBox(height: 12,),

        Row(
          mainAxisAlignment:MainAxisAlignment.spaceAround,
          children: [
            InkWell(
              child: Container(
                decoration:BoxDecoration(
                  color:AppColors.cardColor,
                  borderRadius:BorderRadius.circular(10)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      ClipRRect(
                        child: Image.asset(AppAssets.users,
                        width: 100,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text("تسجيل كمستخدم ",
                      style:TextStyle(color:AppColors.secondaryTextColor,fontSize: 18),
                      )
                    ],
                  ),
                ),
              ),
              onTap:(){
                Get.to( LoginView(
                    type: '0'
                ));
              },
            ),

             InkWell(
               child: Container(
               //  width: 120,height: 220,
                 decoration:BoxDecoration(
                  color:AppColors.cardColor,
                  borderRadius:BorderRadius.circular(10)
                ),
                 child: Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Column(
                    children: [
                      ClipRRect(
                        child: Image.asset(AppAssets.workers,
                        //fit:BoxFit.fill,
                        width: 100,
                        ),
                      ),
                      const SizedBox(height: 10,),
                      Text("تسجيل كعامل ",
                      style:TextStyle(color:AppColors.secondaryTextColor,fontSize: 18),
                      )
                    ],
                               ),
                 ),
               ),
                           onTap:(){
                              Get.to( LoginView(
                                type: '1',
                              ));

                           },
             )





        ],)






          
        ],),
      ),
    );
  }
}