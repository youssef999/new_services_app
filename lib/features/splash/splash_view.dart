

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:freelancerApp/features/auth/views/login_view2.dart';
import 'package:freelancerApp/features/first/first_view.dart';
import 'package:freelancerApp/features/onBoarding/onBoarding_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../auth/views/login_view.dart';
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {


  @override
  void initState() {
    final box=GetStorage();
    String email=box.read('email')??'x';
    bool onBoarding=box.read('onBoarding')??false;

    if(onBoarding==false){

      Future.delayed(const Duration(seconds: 3), () {

        Get.offAll(OnBoardingView());


      });



    }else{

      Future.delayed(const Duration(seconds: 3), () {

        if(email=='x') {
          Get.offAll(const FirstView());
        }else{
          Get.offAll(const MainHome());
          // Get.offAll( RootView());
          // Get.offAll(const HomeView());
        }

//    }

      });
    }

   
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        toolbarHeight: 11,
        elevation: 0.1,
        backgroundColor:AppColors.appBarColor
      ),
      backgroundColor:Colors.white,
      body:Center(
        child: SizedBox(
          height:200,
          child: Image.asset(AppAssets.logo,fit: BoxFit.cover),
        ),
      ),

    );
  }
}