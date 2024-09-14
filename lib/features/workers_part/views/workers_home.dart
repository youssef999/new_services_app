


import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/workers_part/controllers/workers_home_controller.dart';
import 'package:freelancerApp/features/workers_part/widgets/task_widget.dart';
import 'package:get/get.dart';

class WorkersHome extends StatefulWidget {
  const WorkersHome({super.key});

  @override
  State<WorkersHome> createState() => _WorkersHomeState();
}

class _WorkersHomeState extends State<WorkersHome> {

 WorkersHomeController controller =Get.put(WorkersHomeController());

 @override
  void initState() {
    controller.getTaskList();
    controller. getCats();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkersHomeController>(
      builder: (_) {
        return Scaffold(
          appBar:AppBar(
            elevation: 0.2,
            backgroundColor: AppColors.primary,
            title:const Text("المهام"),
            centerTitle: true,
            actions: [
              IconButton(onPressed: (){
                controller.openFilterDialog(context);
              //  Get.to(const AddPropasalView());
              }, icon:const Icon(Icons.filter_list))
            ],
          ),
          body:Padding(
            padding:const EdgeInsets.all(8.0),
            child: GetBuilder<WorkersHomeController>(
              builder: (_) {
                return ListView(children: [
                  const SizedBox(height: 12,),
                
                 (controller.tasksList.isEmpty)?
                         Center(child:Column(
                          children: [
                            Image.asset(AppAssets.emptyTasks,
                            height: 300,
                            ),
                           const  SizedBox(height: 20,),
                           Text(" لا يوجد مهام",
                            style:TextStyle(
                              color:AppColors.secondaryTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                            ),
                            ),
                          ],
                        )):
                  ListView.builder(
                    shrinkWrap: true,
                    physics:const NeverScrollableScrollPhysics(),
                    itemCount: controller.tasksList.length,
                    itemBuilder: (context, index) {

                       
                    return  Padding(
                      padding:const EdgeInsets.all(8.0),
                      child: TaskWidget(
                        task:controller.tasksList[index]
                      ),
                    );
                  })
          
                  //   return  Padding(
                  //     padding:const EdgeInsets.all(8.0),
                  //     child: TaskWidget(
                  //       task:controller.tasksList[index]
                  //     ),
                  //   );
                  // })
                
                
                
                ],);
              }
            ),
          ),
        );
      }
    );
  }
}
