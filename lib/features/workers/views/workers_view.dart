

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/workers/controllers/workers_controller.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:freelancerApp/features/workers/widgets/workers_widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class WorkersCatView extends StatefulWidget {
  String cat;
  WorkersCatView({super.key,required this.cat});

  @override
  State<WorkersCatView> createState() => _WorkersCatViewState();
}

class _WorkersCatViewState extends State<WorkersCatView> {


WorkersController controller =Get.put(WorkersController());
@override
  void initState() {
    controller.getAllWorkers(widget.cat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar('', context),
      body:GetBuilder<WorkersController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children:  [
             const SizedBox(height: 12,),
             ListView.builder(
            shrinkWrap: true,
              itemCount: controller.workersList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: WorkerCard(worker: 
                  controller.workersList[index]
                  ,),
                );
             }
             )
            ],),
          );
        }
      ),
    );
  }
}
// ignore: must_be_immutable
