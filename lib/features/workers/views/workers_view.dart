

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/features/Home/widgets/workers_widget.dart';
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

HomeController controller =Get.put(HomeController());

@override
  void initState() {
    controller.getAllWorkers(widget.cat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:AppColors.backgroundColor,
      appBar:CustomAppBar(widget.cat, context),
      body:GetBuilder<HomeController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(children:  [
             const SizedBox(height: 12,),
             (controller.workersCatList.isEmpty) ?
                Column(
                 children: [
                   ClipRRect(
                     borderRadius: BorderRadius.circular(12),
                     child: Image.asset(AppAssets.workers,
                     height: 200,
                     ),
                   ),
                  const SizedBox(height: 14,),
                   Center(child: Text('لا يوجد نتائج',style:TextStyle(
                     color:AppColors.secondaryTextColor,fontWeight:FontWeight.w600,
                     fontSize: 30
                   ),)),
                 ],
               ):WorkerProvidersList(controller: controller),

              // GridView.builder(
            // shrinkWrap: true,
            //   itemCount: controller.workersList.length,
            //   itemBuilder: (context, index) {
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child:
            //       WorkersWidget(cat: widget.cat,
            //       )
            //     );
            //  }, gridDelegate:
            // const SliverGridDelegateWithFixedCrossAxisCount(
            //     crossAxisCount: 2,
            //  childAspectRatio: 0.9
            // ),
            //  )
            ],),
          );
        }
      ),
    );
  }
}

class WorkerProvidersList extends StatelessWidget {
  HomeController controller;
  WorkerProvidersList({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        itemCount: controller.workersCatList.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: WorkerCardWidget(
                worker: controller.workersCatList[index],
              ));
        }, gridDelegate:
    const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 4,
        childAspectRatio: 0.88

    ));
  }
}
// ignore: must_be_immutable
