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

class LoginView extends StatefulWidget {
  final String type;
  LoginView({super.key, required this.type});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  AuthController controller = Get.put(AuthController());
  @override
  void initState() {
    if(widget.type=='0'){
      controller.getAllUsers('users');
    }else{
      controller.getAllUsers('serviceProviders');
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());
    controller.loginFormKey = GlobalKey<FormState>();

    print("TYPEEEE===" + widget.type);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor, // Improved background color for better contrast
      appBar: AppBar(
        toolbarHeight: 42,
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: controller.loginFormKey,
          child: GetBuilder<AuthController>(
            builder: (_) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(9.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 10),
                      // Logo and Welcome Text
                      Center(
                        child: Column(
                          children: [
                            Image.asset(
                              AppAssets.logo2,
                              height: 123,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'أهلاً بك في التطبيق',
                              style: TextStyle(
                                color: AppColors.secondaryTextColor,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'قم بتسجيل الدخول للمتابعة',
                              style: TextStyle(
                                color: AppColors.greyTextColor,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Email Input
                      Padding(
                        padding: const EdgeInsets.only
                          (left: 8.0,
                        right: 8
                        ),
                        child: CustomTextFormField(
                          hint: 'البريد الالكتروني',
                          obs: false,
                          color: AppColors.primary,
                          validateMessage: 'بريد الكتروني غير صحيح',
                          controller: controller.emailController,
                          icon: Icons.email, // Icon for email
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Password Input
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0,
                        right: 8
                        ),
                        child: CustomTextFormField(
                          hint: 'كلمة المرور ',
                          obs: true,
                          color: AppColors.primary,
                          validateMessage: 'كلمة المرور غير صحيحة',
                          controller: controller.passController,
                          icon: Icons.lock, // Icon for password
                        ),
                      ),
                      const SizedBox(height: 5),
                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {
                            Get.to(const ForgotPass());
                          },
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              color: AppColors.secondaryTextColor,
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Login Button

                      (controller.isLoading==false)?
                      Padding(
                        padding: const EdgeInsets.only(left:28.0
                        ,right: 28
                        ),
                        child: CustomButton(
                          text: 'تسجيل دخول',
                          onPressed: () {
                          //  controller.loginWithPhone( context);
                            controller.userLogin(widget.type,context);
                          },
                          color1: AppColors.primary,
                          color2: AppColors.secondaryTextColor,
                          //fontSize: 18,
                        ),
                      ):Center(child: CircularProgressIndicator(
                        color:AppColors.primary,
                      )),
                      
                      
                      
                      const SizedBox(height: 15),
                      // Divider
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                'أو'.tr,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      InkWell(
                        child: Container(
                          decoration:BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            color: AppColors.primary,
                          ),
                          padding:const  EdgeInsets.all(10),
                          child: Row(children: [

                            Image.asset(AppAssets.googleIcon,
                            width:50 ,
                            height: 31,
                            ),

                          const  SizedBox(width: 12,),

                            Text('تسجيل دخول بواسطة جوجل',
                              style:TextStyle(color: AppColors.mainTextColor,
                                  fontSize: 18,fontWeight: FontWeight.bold),)

                          ],),
                        ),
                        onTap:(){
                          print("TRY TO LOGIN======"+widget.type.toString());
                          controller.tryToLogin(context, widget.type);
                        },
                      ),
                      
                      
                      
                      // Register Option
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "لا تمتلك حساب ؟",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(SignupView(roleId: widget.type,
                              email: 'x',
                              ));
                            },
                            child: Text(
                              'انشاء حساب'.tr,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

