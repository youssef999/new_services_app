import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:freelancerApp/features/Work/controllers/work_controller.dart';
import 'package:get/get.dart';

class AddWork extends StatefulWidget {
  const AddWork({super.key});

  @override
  State<AddWork> createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  WorkController controller = Get.put(WorkController());

  @override
  void initState() {
    controller.getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('أضف خدمة', context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GetBuilder<WorkController>(builder: (_) {
          return ListView(
            children: [
              const SizedBox(
                height: 3,
              ),
              controller.images.isEmpty
                  ? InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey[200]!),
                            color: Colors.grey[200]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Image.asset(
                                AppAssets.imagePlaceHolder,
                                height: 90,
                              ),
                              Text(
                                'اضف صورة لوصف طلبك ',
                                style: TextStyle(
                                    color: AppColors.secondaryTextColor,
                                    fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        controller.pickMultipleImages();
                      },
                    )
                  : buildGridView(),
              const SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                  hint: 'عنوان طلبك',
                  max: 2,
                  color: Colors.black,
                  icon: Icons.description,
                  obs: false,
                  controller: controller.title),
              const SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                  hint: 'وصف طلبك',
                  max: 5,
                  color: Colors.black,
                  icon: Icons.description,
                  obs: false,
                  controller: controller.description),
              const SizedBox(
                height: 10,
              ),
              (controller.selectedDate == null)
                  ? InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.imageCardColor),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    child: Text(
                                      "تاريخ تنفيذ العمل ",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontSize: 18),
                                    ),
                                    onTap: () {
                                      controller.selectDate(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        controller.selectDate(context);
                      },
                    )
                  : InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.imageCardColor),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    child: Text(
                                      controller.selectedDate
                                          .toString()
                                          .replaceAll('00:00:00.000', ''),
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.9),
                                          fontSize: 18),
                                    ),
                                    onTap: () {
                                      controller.selectDate(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        controller.selectDate(context);
                      },
                    ),
              const SizedBox(
                height: 10,
              ),
              (controller.selectedTime == null &&
                      controller.endSelectedTime == null)
                  ? InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.imageCardColor),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    child: Text(
                                      "مواعيد العمل المحددة  ",
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.4),
                                          fontSize: 18),
                                    ),
                                    onTap: () {
                                      controller.selectTime(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {},
                    )
                  : InkWell(
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: AppColors.imageCardColor),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    child: Text(
                                      controller.selectedTime
                                              .toString()
                                              .replaceAll('TimeOfDay', '') +
                                          " - " +
                                          controller.endSelectedTime
                                              .toString()
                                              .replaceAll('TimeOfDay', ''),
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.9),
                                          fontSize: 18),
                                    ),
                                    onTap: () {
                                      controller.selectTime(context);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 172,
                    child: CustomTextFormField(
                        hint: "اقل سعر لهذا الطلب",
                        max: 2,
                        type: TextInputType.number,
                        color: Colors.black,
                        icon: Icons.description,
                        obs: false,
                        controller: controller.minPrice),
                  ),
                  const SizedBox(
                    width: 9,
                  ),
                  SizedBox(
                    width: 172,
                    child: CustomTextFormField(
                        hint: 'اعلي سعر لهذا الطلب ',
                        type: TextInputType.number,
                        max: 2,
                        color: Colors.black,
                        icon: Icons.description,
                        obs: false,
                        controller: controller.maxPrice),
                  ),
                ],
              ),
              const SizedBox(
                height: 14,
              ),
              CustomButton(
                  text: 'اضافة العمل ',
                  onPressed: () {
                    controller.addWorkToFirestore();
                  })
            ],
          );
        }),
      ),
    );
  }

  Widget buildGridView() {
    return InkWell(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: controller.images.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: Colors.grey[200]),
                child: Image.file(File(controller.images[index].path))),
          );
        },
      ),
      onTap: () {
        controller.pickMultipleImages();
      },
    );
  }
}
