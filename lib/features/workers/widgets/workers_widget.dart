

 import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:freelancerApp/features/workers/views/worker_details.dart';
import 'package:get/get.dart';

class WorkerCard extends StatelessWidget {
  WorkerProvider worker;
  
   WorkerCard({super.key,required this.worker});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration:BoxDecoration(
          borderRadius:BorderRadius.circular(12),
          color:AppColors.cardColor
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child:Column(
            children: [
             const SizedBox(height: 5,),
              Row(children: [
                CircleAvatar(
                  radius: 44,
                  backgroundImage:NetworkImage(worker.image),
                ),
                 const SizedBox(width: 12,),
               
                Column(
                  children: [
                    Text(worker.name,
                    style:TextStyle(
                      color:AppColors.secondaryTextColor,
                      fontSize: 18
                    ),
                    ),
                    const SizedBox(height: 6,),
                     Text(worker.cat,
             style:TextStyle(
               color:AppColors.primary,
               fontSize: 15
             ),
             ),
                  ],
                ),
              ],),
             const SizedBox(height: 10,),
      
            
      
          
            ],
          ),
          
          
          ), 
      ),
      onTap:(){
        Get.to(WorkerDetails(
          worker: worker,
        ));
      },
    );
  }
}