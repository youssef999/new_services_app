import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/features/auth/views/login_view2.dart';
import 'package:freelancerApp/features/first/first_view2.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../first/first_view.dart';

class OnBoardingView extends StatelessWidget {
  final Color kDarkBlueColor = AppColors.primary;

  OnBoardingView({super.key});

  @override
  Widget build(BuildContext context) {
    final box=GetStorage();
    return OnBoardingSlider(
      finishButtonText: 'start'.tr,
      onFinish: () {

        Get.offAll(const FirstView());
        box.write('onBoarding', true);

      },
      finishButtonStyle: FinishButtonStyle(
        backgroundColor: kDarkBlueColor,
      ),
      skipTextButton: Text(
        'skip'.tr,
        style: TextStyle(
          fontSize: 16,
          color: kDarkBlueColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailingFunction: () {},
      controllerColor: kDarkBlueColor,
      totalPage: 3,
      headerBackgroundColor: Colors.white,
      pageBackgroundColor: Colors.white,
      background: [
        Image.asset(
          'assets/images/b1.webp',
          height: 321,
          width: MediaQuery.of(context).size.width,
        ),
        Image.asset(
          'assets/images/b2.webp',
          height: 290,
          width: MediaQuery.of(context).size.width,
        ),
        Image.asset(
          'assets/images/b9.png',
          width: MediaQuery.of(context).size.width,
          height: 290,
        ),
      ],
      speed: 1.8,
      pageBodies: [
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 343,
              ),
              Text(
                'مرحبًا بك في I NEED',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkBlueColor,
                  fontSize: 28.0,  // Larger font size for marketing emphasis
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'تطبيق شامل يتيح لك العثور على العمال وطلب الخدمات بكل سهولة في أي وقت وأي مكان.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20.0,  // Larger font size for a clearer message
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 343,
              ),
              Text(
                'أطلب خدمات متنوعة بجودة عالية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkBlueColor,
                  fontSize: 28.0,  // Larger font for emphasis
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'من العمال المحترفين إلى الفنيين المهرة، نوفر لك أفضل الحلول في جميع المجالات.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20.0,  // Maintain larger font size
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 343,
              ),
              Text(
                'ابدأ الآن!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kDarkBlueColor,
                  fontSize: 28.0,  // Strong CTA with bold and large text
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'انضم إلينا واطلب خدماتك بسهولة من خلال التطبيق في خطوات بسيطة وسريعة.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 20.0,  // Consistent marketing message with larger font
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
