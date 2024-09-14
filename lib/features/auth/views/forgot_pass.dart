

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:freelancerApp/features/auth/controllers/auth_controller.dart';
import 'package:get/get.dart';

class ForgotPass extends StatelessWidget {
  const ForgotPass({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller=Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
     // appBar:CustomAppBar('', context, false),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: ListView(children: [
          const SizedBox(height: 21,),
          Custom_Text(text: 'weWillSendYouAnEmail'.tr,),
          const SizedBox(height: 30,),
          CustomTextFormField(hint: 'email'.tr,
           color:Colors.black,icon:Icons.email,
           obs: false, controller: controller.emailController),
             const SizedBox(height: 21,),
             Padding(
               padding: const EdgeInsets.all(12.0),
               child: CustomButton(text: 'send'.tr, onPressed: (){
                controller.resetPassword();
              
               }),
             )

          
        ],),
      ),
    );
  }
}