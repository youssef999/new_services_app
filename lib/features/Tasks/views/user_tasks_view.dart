

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Tasks/controllers/user_tasks_controller.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:get/get.dart';

class UserTasksView extends StatefulWidget {
  const UserTasksView({super.key});

  @override
  State<UserTasksView> createState() => _UserTasksViewState();
}

class _UserTasksViewState extends State<UserTasksView> {


UserTasksController controller =Get.put(UserTasksController());
  @override
  void initState() {
    controller.getUserTaskList();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar('', context),
      body:GetBuilder<UserTasksController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children: [
              const SizedBox(height: 12,),

              (controller.userTaskList.isEmpty)?
              Center(child:Column(children: [

                Image.asset(AppAssets.noTasks,
                height: 300,
                ),
                const SizedBox(height: 12,),
                const Text("لا يوجد مهام",style:const TextStyle(
                  fontSize: 21,fontWeight:FontWeight.w600
                ))                
              ])
              ):
              ListView.builder(
                shrinkWrap: true,
                physics:const NeverScrollableScrollPhysics(),
                itemCount: controller.userTaskList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TaskWidget(
                      controller: controller,
                      task: controller.userTaskList[index],
                    ),
                  );
              })
              
            ],),
          );
        }
      ),
    );
  }
}

// ignore: must_be_immutable
class TaskWidget extends StatelessWidget {
  UserTasksController controller;
  Task task;
 TaskWidget({super.key,required this.task,required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        borderRadius:BorderRadius.circular(12),
        color:AppColors.cardColor
      ),
      child:Padding(padding: const EdgeInsets.all(5),
      child:Column(children: [
     
        const SizedBox(height: 8,),
        Column(children: [

          Row(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundImage:NetworkImage(task.image),
              ),
             const SizedBox(width: 21,),
               Column(
                 children: [
                   Text(task.title,
                             style:TextStyle(
                               color:AppColors.secondaryTextColor,
                               fontSize: 18,fontWeight:FontWeight.w700
                             ),
                             ),
                               Text(task.date.replaceAll('00:00:00.000', ''),
          style:TextStyle(
            color:AppColors.greyTextColor,
            fontSize: 14,fontWeight:FontWeight.w500
          ),
          ),
                 ],
               ),
            ],
          ),
          

         
          // Image.network(task.image,
          // fit:BoxFit.cover,
          // height: 80,width: 100,
          // ),
         
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [

            Column(
              children: [
               Text("اقل سعر ",
                style:TextStyle(
                  color:AppColors.secondaryTextColor,
                  fontSize: 18,fontWeight:FontWeight.w600
                ),
                ),

                Text(task.minPrice+" "+currency,
                style:TextStyle(
                  color:AppColors.primary,
                  fontSize: 18,fontWeight:FontWeight.bold
                ),
                ),
              ],
            ),

          

             Column(
               children: [
                 Text("اعلي سعر ",
                style:TextStyle(
                  color:AppColors.secondaryTextColor,
                  fontSize: 18,fontWeight:FontWeight.w600
                ),
                ),
                 Text(task.maxPrice+" "+currency,
                             style:TextStyle(
                  color:AppColors.primary,
                  fontSize: 18,fontWeight:FontWeight.bold
                             ),
                             ),
               ],
             ),
          ],)

        ],),

        const SizedBox(height: 8,),

        Row(
          mainAxisAlignment:MainAxisAlignment.spaceAround,
          children: [


          CustomButton(text: 'حذف', onPressed: (){

            controller.showDeleteConfirmationDialog(context, task.id);

          
          }),

          CustomButton(text: 'تعديل ', onPressed: (){

          })





        ],),

       const SizedBox(height: 12,),


          CustomButton(text: 'متابعة  العروض ', onPressed: (){

          }),

            const SizedBox(height: 12,),
      

      ],),
      ),
    );
  }
}