import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/features/workers/controllers/workers_controller.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:freelancerApp/features/workers/widgets/workers_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rate/rate.dart';

import '../../workers/views/worker_details.dart';

// ignore: must_be_immutable
class WorkersWidget extends StatefulWidget {
  final String cat;
  const WorkersWidget({super.key, required this.cat});

  @override
  State<WorkersWidget> createState() => _WorkersWidgetState();
}

class _WorkersWidgetState extends State<WorkersWidget> {
  HomeController controller = Get.put(HomeController());
  final box = GetStorage();

  @override
  void initState() {
    String address=box.read('address')?? 'اختر الموقع';
    super.initState();
   controller.getAllWorkers(widget.cat, address);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: GetBuilder<HomeController>(
        builder: (_) {
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: controller.workersList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: WorkerCardWidget(worker:
                controller.workersList[index]),
              );

            }, gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            crossAxisSpacing: 4,
            childAspectRatio: 0.88
            )
          );
        },
      ),
    );
  }
}

class WorkerCardWidget extends StatelessWidget {

  WorkerProvider worker;
 WorkerCardWidget({super.key,required this.worker});

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      child: Container(
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
                  width: MediaQuery.of(context).size.width * 0.88,
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

