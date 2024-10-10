import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/widgets/workers_widget.dart';
import 'package:freelancerApp/features/Work/views/add_work.dart';
import 'package:get/get.dart';
import '../Home/controller/home_controller.dart';

class SubCatHomeView extends StatefulWidget {
  String cat;
  String subcat;
  SubCatHomeView({super.key,
    required this.cat, required this.subcat});

  @override
  State<SubCatHomeView> createState() => _SubCatHomeViewState();
}

class _SubCatHomeViewState extends State<SubCatHomeView> {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    //controller.getCats();
    controller.getWorkersWithSubCat(
        widget.subcat, widget.cat);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(widget.cat, context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: GetBuilder<HomeController>(builder: (_) {
          return ListView(
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(21),
                    gradient: LinearGradient(
                      colors: [AppColors.primary,
                        AppColors.cardColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(22),
                            child: Image.asset(
                              AppAssets.addServiceIcon,
                              height: 120,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "اضافة طلب جديد",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Get.to(AddWork(cat: widget.cat
                    , subCat: widget.subcat,));
                },
              ),
              const SizedBox(height: 10),
              Divider(color: AppColors.primary.withOpacity(0.5), thickness: 0.5),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.cat,
                  style:TextStyle(color:AppColors.secondaryTextColor
                  ,fontSize: 19,fontWeight:FontWeight.bold
                  ),
                  ),
                  Text(widget.subcat,
                    style:TextStyle(color:AppColors.grey
                        ,fontSize: 15,fontWeight:FontWeight.bold
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              WorkerProvidersList(controller: controller),
            ],
          );
        }),
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
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.workersSubCatList.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: WorkerCardWidget(
            worker: controller.workersSubCatList[index],
          ),
        );
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.71,
      ),
    );
  }
}
