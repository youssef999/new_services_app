


import 'package:flutter/material.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/workers_part/controllers/worker_tasks_controller.dart';
import 'package:freelancerApp/features/workers_part/widgets/proposal_widget.dart';
import 'package:get/get.dart';

class WorkerTasks extends StatefulWidget {
  const WorkerTasks({super.key});

  @override
  State<WorkerTasks> createState() => _WorkerTasksState();
}

class _WorkerTasksState extends State<WorkerTasks> {

WorkerTasksController controller =Get.put(WorkerTasksController());
  
  @override
  void initState() {
   
   controller.getWorkerProposal();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar('', context),
      body:ListView(children: [

        GetBuilder<WorkerTasksController>(
          builder: (_) {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.proposalList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProposalWidget(task: 
                  controller.proposalList[index],),
                );
             }
             );
          }
        ),

      ],),
    );
  }
}


