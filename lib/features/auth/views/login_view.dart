// ignore_for_file: avoid_print, unnecessary_const

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_loading.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:freelancerApp/features/auth/controllers/auth_controller.dart';
import 'package:freelancerApp/features/auth/views/forgot_pass.dart';
import 'package:freelancerApp/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/app_styles.dart';
import 'register_view2.dart';

class LoginView extends StatelessWidget {
  String type;
  LoginView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());

    controller.loginFormKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: null,
      body: Form(
        key: controller.loginFormKey,
        child: GetBuilder<AuthController>(builder: (_) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Column(children: [
                  Image.asset(
                    height: 210,
                    AppAssets.logo,
                    fit: BoxFit.cover,
                  ),
                  Text(
                    'مرحبا بعودتك في دليل اليمن',
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 23,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                ]),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                      //color: AppColors.primaryDarkColor,
                      borderRadius: BorderRadius.all(Radius.circular(25))),
                  child: Column(
                    children: [
                      CustomTextFormField(
                          hint: 'البريد الالكتروني',
                          obs: false,
                          color: AppColors.primary,
                          validateMessage: 'بريد الكتروني غير صحيح',
                          controller: controller.emailController),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomTextFormField(
                          hint: 'كلمة المرور ',
                          obs: true,
                          color: AppColors.primary,
                          validateMessage: 'كلمة المرور غير صحيحة',
                          obx: true,
                          controller: controller.passController),
                      const SizedBox(
                        height: 2,
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const SizedBox(
                            width: 200,
                          ),
                          InkWell(
                            child: Custom_Text(
                              text: 'نسيت كلمة المرور؟',
                              color: Colors.grey[600]!,
                              fontSize: 15,
                            ),
                            onTap: () {
                              Get.to(const ForgotPass());
                            },
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                          text: 'تسجيل دخول',
                          onPressed: () {
                            controller.userLogin('0');
                          }),
                      const SizedBox(
                        height: 6,
                      ),
                      const SizedBox(height: 3),
                      Center(
                          child: Text(
                        'او'.tr,
                        style:
                            TextStyle(color: AppColors.primary, fontSize: 20),
                      )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "لا تمتلك حساب ؟",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(SignupView(
                                roleId: type,
                              ));
                            },
                            child: Text(
                              'انشاء حساب'.tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primary),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
