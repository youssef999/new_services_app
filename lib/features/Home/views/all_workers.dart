



 import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/widgets/workers_widget.dart';

import '../../../core/resources/app_assets.dart';
import '../../workers/models/workers.dart';

class AllWorkers extends StatelessWidget {

  List<WorkerProvider> workersList ;

 AllWorkers({super.key,required this.workersList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar('', context),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
         const SizedBox(height: 12,),

         (workersList.isEmpty) ?
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
         ):
         GridView.builder(
          shrinkWrap: true,
          itemCount: workersList.length,
           itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: WorkerCardWidget(worker: workersList[index]),
              );
           },gridDelegate:
         const SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           childAspectRatio: 0.84,
           mainAxisSpacing: 10,
           crossAxisSpacing: 10,
           ),
         ),

        ],),
      ),
    );
  }
}
