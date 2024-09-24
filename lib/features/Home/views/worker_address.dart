



import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/widgets/Custom_Text.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/features/Home/widgets/workers_widget.dart';
import 'package:freelancerApp/features/workers/controllers/workers_controller.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:freelancerApp/features/workers/views/worker_details.dart';
import 'package:freelancerApp/features/workers/widgets/workers_widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class WorkersAddressView extends StatefulWidget {

  String address;
  WorkersAddressView({super.key,required this.address});


  @override
  State<WorkersAddressView> createState() => _WorkersCatViewState();
}

class _WorkersCatViewState extends State<WorkersAddressView> {

  HomeController controller =Get.put(HomeController());
  @override
  void initState() {
    controller.getAllWorkersWithAddress(widget.address);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor:AppColors.backgroundColor,
      appBar:CustomAppBar('', context),
      body:GetBuilder<HomeController>(
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(children:  [
                const SizedBox(height: 12,),

                (controller.workersAddressList.isEmpty) ?
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
                  itemCount: controller.workersAddressList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:WorkerCardWidget( worker:
                        controller.workersAddressList[index],)

                    );
                  }, gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9
                ),
                )
              ],),
            );
          }
      ),
    );
  }
}

Widget WorkersWidget(HomeController controller,int index) {
      return InkWell(
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
                imageUrl: controller.workersAddressList[index].image,
                width: 150,
              ),
            ),
            Custom_Text(
              text: controller.workersAddressList[index].name,
              fontSize: 18,
            ),
            Custom_Text(
              text: controller.workersAddressList[index].cat,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    ),
    onTap:(){
      Get.to(WorkerDetails(
          worker:controller.workersAddressList[index]
      ));
    },
  );
}
// ignore: must_be_immutable
