

import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/features/workers_part/widgets/task_widget.dart';
import 'package:get/get.dart';
 import 'package:flutter/material.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/workers_part/controllers/filter_tasks_controller.dart';

import '../../../core/resources/app_colors.dart';

class FilterTaskView extends StatefulWidget {

   String cat;
   FilterTaskView({super.key,required this.cat});

  @override
  State<FilterTaskView> createState() => _FilterTaskViewState();
}

class _FilterTaskViewState extends State<FilterTaskView> {

  FilterTasksController controller =Get.put(FilterTasksController());
  @override
  void initState() {
    controller.getTaskList(
      widget.cat
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.backgroundColor,
      appBar:CustomAppBar('', context),
      body:GetBuilder<FilterTasksController>(
        builder: (context) {
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
               print("CONTROLLER==="+controller.tasksList.length.toString());
               
return  Padding(
                      padding:const EdgeInsets.all(8.0),
                      child: TaskWidget(
                        task:controller.tasksList[index]
                      ),
                    );
                      
                    
                  })
          
          ],);
        }
      ),
    );
  }
}