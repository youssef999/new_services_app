

// ignore_for_file: must_be_immutable

 //import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/auth/views/login_view.dart';
import 'package:freelancerApp/features/settings/controllers/settings_controller.dart';
import 'package:freelancerApp/features/settings/models/user.dart';
import 'package:get/get.dart';

import '../../first/first_view.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {


 SettingsController controller =Get.put(SettingsController());
  @override
  void initState() {

    controller.getUserData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar('', context),
      body:GetBuilder<SettingsController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: [
              const SizedBox(height: 12,),
              (controller.userData.isNotEmpty)?
              UserCardWidget(
                userData: controller.userData[0]
              ):const Center(child: CircularProgressIndicator()),
            
              const SizedBox(height: 30,),
              SettingsCardWidget(txt: "تغيير الاسم ", 
              icon: Icons.person, 
              function: () {  },),
              
              const SizedBox(height: 20,),
              SettingsCardWidget(
                txt: "تغيير كلمة المرور",
                 icon: Icons.password, function: () {  },),
              

               const SizedBox(height: 20,),
              SettingsCardWidget(
                txt: "سياسة الخصوصية", icon: Icons.privacy_tip,
                 function: () {  },),
              

               const SizedBox(height: 20,),
              SettingsCardWidget(
                txt: "تسجيل خروج", 
                function: (){

                  Get.offAll(const FirstView());
                  
                //  Get.offAll(const LoginView());
                },
                icon: Icons.logout_outlined),
              
              
            ],),
          );
        }
      ),
    );
  }
}



class SettingsCardWidget extends StatelessWidget {

  String txt;
  IconData icon;
  void Function() function;
 SettingsCardWidget({super.key,required this.txt,
 required this.function,
 required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        borderRadius:BorderRadius.circular(9),
        color:AppColors.cardColor
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(children: [
        
        Icon(icon,color:AppColors.primary,
        size: 28,
        ),
          const SizedBox(width: 22,),
          Text(txt,
          style:const TextStyle(
            fontSize: 18
          ),
          ),
           const SizedBox(width: 22,),
           IconButton(onPressed:function
           , icon: Icon(Icons.navigate_next_rounded,
           color:AppColors.primary,))

        ],),
      )
    );
  }
}
 
class UserCardWidget extends StatelessWidget {

  User userData;
   UserCardWidget({super.key,required this.userData});

  @override
  Widget build(BuildContext context) {
    return Container(
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(12),
              //    color:Colors.grey[200],
                ),
                child: Row(children: [
                  CircleAvatar(
                    backgroundColor:AppColors.primary,
                    radius: 44,
                    backgroundImage:
                    NetworkImage(userData.image),
                  ),
                  const  SizedBox(width: 12,),
                  Column(children: [
                Text(userData.name,
                style:TextStyle(
                  color:AppColors.secondaryTextColor,
                  fontSize: 18
                ),
                ),
                const SizedBox(height: 6,),
                Text(userData.email,
                style:TextStyle(
                  color:AppColors.greyTextColor,
                  fontSize: 18
                ),
                ),
                
                  ],)
                
                
                ],),
              );
  }
}