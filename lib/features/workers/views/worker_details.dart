

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';

class WorkerDetails extends StatelessWidget {

  WorkerProvider worker;
 
  WorkerDetails({super.key,required this.worker});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar('', context),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          const SizedBox(height: 12,),

          Row(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundImage:NetworkImage(worker.image),
              ),
            const  SizedBox(width: 12,),
               Column(children: [
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
                fontSize: 17
               ),
               )
            ],)
            ],
          ),
         const SizedBox(height: 12),

          Text(worker.details,
          style:TextStyle(
            color:AppColors.secondaryTextColor.withOpacity(0.6),
          ),
          ),
            const SizedBox(height: 12),
            Center(
              child: Row(
                children: [
                   Text("سعر خدمة يبدا من : ",
                     style:TextStyle(
                      color:AppColors.secondaryTextColor,
                      fontSize: 17,fontWeight: FontWeight.w500
                     ),
                     ),
                    const SizedBox(width: 12,),
                  Text(worker.price+" "+currency,
                     style:TextStyle(
                      color:AppColors.primary,
                      fontSize: 17,fontWeight: FontWeight.bold
                     ),
                     ),
                ],
              ),
            ),
           const SizedBox(height: 12,),


           Image.asset(AppAssets.whatsApp,
           height: 88,
           )
         
         

          
        ],),
      ),
    );
  }
}