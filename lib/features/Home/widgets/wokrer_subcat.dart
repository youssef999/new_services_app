

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:freelancerApp/features/workers/views/worker_details.dart';
import 'package:get/get.dart';
import 'package:rate/rate.dart';

class WorkerSubCatCardWidget extends StatelessWidget {

  WorkerProvider worker;
 WorkerSubCatCardWidget({super.key,required this.worker});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            border:Border.all(color:Colors.grey[400]!,width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.4),
                spreadRadius: 2.2,
                blurRadius: 3.3,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: worker.image,
                  height: 80,
                // width: MediaQuery.of(context).size.width * 0.88,
                ),
              ),
             const SizedBox(height: 12,),
              Custom_Text(
                text: worker.name,
                fontSize: 21,
                fontWeight:FontWeight.w600,
              ),
              Custom_Text(
                text: worker.cat,
                color: AppColors.primary,
              ),
              Rate(
                iconSize: 14,
                color: Colors.amber,
                allowHalf: true,
                allowClear: true,
                initialValue:double.parse(worker.rate.toString()),
                readOnly: true,
                onChange: (value) => print(value),
              ),
            ],
          ),
        ),
      ),
      onTap:(){

        Get.to(WorkerDetails(
            worker:worker
        ));



      },
    );
  }
}