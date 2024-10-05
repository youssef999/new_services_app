// ignore_for_file: avoid_print, unnecessary_const

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/DropDown/drop_down_widget.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/core/widgets/custom_loading.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:freelancerApp/features/auth/controllers/auth_controller.dart';
import 'package:freelancerApp/features/auth/views/forgot_pass.dart';
import 'package:freelancerApp/core/widgets/image/image_widget.dart';
import 'package:freelancerApp/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/resources/app_colors.dart';
import '../../../core/resources/app_styles.dart';
import 'register_view2.dart';

class SignupView extends StatefulWidget {

  String roleId;
  String email;

  SignupView({super.key, required this.roleId,required this.email});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  AuthController controller = Get.put(AuthController());
  @override
  void initState() {
    controller.getCats();
    if(widget.email!='x'){
      controller.emailController.text=widget.email;
    }
   // if(widget.roleId=='1'){
      controller.getCities('مصر');
   // }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.roleId == '0') {
      return UserRegisterView(
        controller: controller,
      );
    } else {
      return const WorkerRegisterView();
    }
  }
}

class UserRegisterView extends StatelessWidget {
  AuthController controller;
  UserRegisterView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());
    controller.loginFormKey = GlobalKey<FormState>();

    return Scaffold(
      body: GetBuilder<AuthController>(builder: (_) {
        return Form(
          key: controller.loginFormKey,
          child: Container(
            color: Colors.white,
            //decoration: AppDecoration,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(children: [
                    Image.asset(
                      AppAssets.logo,
                      fit: BoxFit.fill,
                      width: 300,
                    ),
                    Text(
                      'أهلا بك  ',
                      style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 23,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'أطلب خدمتك من اي مكان',
                      style: TextStyle(
                          color: AppColors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
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
                            hint: 'الاسم'.tr,
                            obs: false,
                            color: AppColors.primary,
                            validateMessage: 'wrongEmail'.tr,
                            controller: controller.nameController),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                            hint: 'email'.tr,
                            obs: false,
                            color: AppColors.primary,
                            icon: Icons.email,
                            validateMessage: 'wrongEmail'.tr,
                            controller: controller.emailController),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                            hint: 'password'.tr,
                            obs: true,
                            color: AppColors.primary,
                            validateMessage: 'wrongPass'.tr,
                            obx: true,
                            controller: controller.passController),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFormField(
                            hint: 'الهاتف'.tr,
                            obs: true,
                            color: AppColors.primary,
                            validateMessage: 'رقم الهاتف غير صحيح'.tr,
                            obx: true,
                            controller: controller.phoneController),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomButton(
                            text: 'انشاء حساب',
                            onPressed: () {
                              controller.register(
                                '0',
                                controller.emailController.text,
                                controller.passController.text,
                                controller.phoneController.text,
                                context
                              );
                            }),
                        const SizedBox(
                          height: 6,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 200,
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Center(
                            child: Text(
                          'or'.tr,
                          style:
                              TextStyle(color: AppColors.primary, fontSize: 20),
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "لديك حساب بالفعل؟".tr,
                              style: const TextStyle(
                                  fontSize: 15, color: Colors.black),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: Text(
                                'تسجيل حساب'.tr,
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
            ),
          ),
        );
      }),
    );
  }
}

class WorkerRegisterView extends StatefulWidget {
  const WorkerRegisterView({
    super.key,
  });

  @override
  State<WorkerRegisterView> createState() => _WorkerRegisterViewState();
}

class _WorkerRegisterViewState extends State<WorkerRegisterView> {
  AuthController controller = Get.put(AuthController());

  @override
  void initState() {
    controller.loginFormKey = GlobalKey<FormState>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('', context),
      body: GetBuilder<AuthController>(
        builder: (_) {
          return Form(
            key: controller.loginFormKey,
            child: Container(
              color: Colors.white,
              child: ListView(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 24),
                      ImageWidget(txt: 'اضف صورتك الشخصية'),
                      const SizedBox(height: 20),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Column(
                      children: [
                        CustomTextFormField(
                          hint: 'email'.tr,
                          obs: false,
                          color: AppColors.primary,
                          icon: Icons.email,
                          validateMessage: 'wrongEmail'.tr,
                          controller: controller.emailController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          hint: 'الاسم'.tr,
                          obs: false,
                          color: AppColors.primary,
                          validateMessage: 'wrongName'.tr,
                          controller: controller.nameController,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Text(
                              "اختر القسم ",
                              style: TextStyle(
                                  color: AppColors.secondaryTextColor),
                            ),
                          ],
                        ),

                        // drop down category
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.DropDownColor,
                            ),
                            // child: Obx(() =>

                            child: GetBuilder<AuthController>(builder: (_) {
                              return DropdownButton<String>(
                                underline: const SizedBox.shrink(),
                                value: controller.selectedItem,
                                onChanged: (newValue) {
                                  controller.changeCatValue(newValue!);
                                },
                                items:
                                    controller.catListNames.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                            color: AppColors.greyTextColor),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            })),


                        const SizedBox(height: 20),
                        CustomTextFormField(
                          hint: 'password'.tr,
                          obs: true,
                          color: AppColors.primary,
                          obx: true,
                          controller: controller.passController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          hint: 'تفاصيل عن عملك او خدمتك',
                          obs: false,
                          color: AppColors.primary,
                          max: 4,
                          icon: Icons.description,
                          validateMessage: '',
                          controller: controller.detailsController,
                        ),
                        const SizedBox(height: 20),
                        CustomTextFormField(
                          hint: 'سعر خدمتك يبدا من ',
                          obs: false,
                          color: AppColors.primary,
                          icon: Icons.price_change,
                          validateMessage: 'ادخل السعر ',
                          controller: controller.priceController,
                        ),const SizedBox(height: 20),

                        // drop down country
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.DropDownColor,
                            ),
                            child: GetBuilder<AuthController>(builder: (_) {
                              return DropdownButton<String>(
                                underline: const SizedBox.shrink(),
                                value: controller.selectedCountry,
                                onChanged: (newValue) {
                                  controller.changeCountry(newValue!);
                                },
                                items:
                                controller.countryList.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                            color: AppColors.greyTextColor),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            })),
                        const SizedBox(height: 20),

                        // drop down city
                        Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.DropDownColor,
                            ),
                            child: GetBuilder<AuthController>(builder: (_) {
                              return DropdownButton<String>(
                                underline: const SizedBox.shrink(),
                                value: controller.selectedCity,
                                onChanged: (newValue) {
                                  controller.changeSelectedCity(newValue!);
                                },
                                items: controller.cityNames.map((String item) {
                                  return DropdownMenuItem<String>(
                                    value: item,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                            color: AppColors.greyTextColor),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              );
                            })),

                        // CustomTextFormField(
                        //   hint: 'البلد',
                        //   obs: false,
                        //   color: AppColors.primary,
                        //   icon: Icons.price_change,
                        //   validateMessage: ' ',
                        //   controller: controller.countryController,
                        // ),

                        // CustomTextFormField(
                        //   hint: 'المدينة',
                        //   obs: false,
                        //   color: AppColors.primary,
                        //   icon: Icons.location_city,
                        //   validateMessage: ' ',
                        //   controller: controller.cityController,
                        // ),
                        const SizedBox(height: 20),

                        CustomTextFormField(
                          hint: 'المنطقة',
                          obs: false,
                          color: AppColors.primary,
                          icon: Icons.location_city_sharp,
                          validateMessage: ' ',
                          controller: controller.addressController,
                        ),

                        const SizedBox(height: 20),
                        CustomButton(
                          text: 'انشاء حساب',
                          onPressed: () {
                            controller.register(
                              '1',
                              controller.emailController.text,
                              controller.passController.text,
                              controller.phoneController.text,context
                            );
                          },
                        ),
                        const SizedBox(height: 6),
                        Center(
                          child: Text(
                            'or'.tr,
                            style: TextStyle(
                                color: AppColors.primary, fontSize: 20),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "تمتلك حساب بالفعل".tr,
                              style:
                                  TextStyle(fontSize: 15, color: kPrimaryColor),
                            ),
                            TextButton(
                              onPressed: () {
                                //Get.to(const SignUpView());
                              },
                              child: Text(
                                'تسجيل حساب'.tr,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
