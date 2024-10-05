import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/core/widgets/custom_dropdown.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:freelancerApp/features/Work/controllers/work_controller.dart';
import 'package:freelancerApp/features/places/search_places.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class AddWork extends StatefulWidget {
  String cat;
  String subCat;
  AddWork({super.key, required this.cat, required this.subCat});

  @override
  State<AddWork> createState() => _AddWorkState();
}

class _AddWorkState extends State<AddWork> {
  WorkController controller = Get.put(WorkController(),
 // permanent: true
  );

  final box=GetStorage();
  @override
  void initState() {

    print("caaaat===" + widget.cat);
    controller.getUserData();
    controller.getCats().then((v) {
      if (widget.cat.length > 1) {
        print("HERE..");
        controller.selectedCat = widget.cat;
      }  if (widget.subCat.length > 1) {
        print("HERE..");
        controller.selectedSubCat = widget.subCat;
      }
    });
    controller.getSubCats(widget.cat).then((v) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     String locationName=box.read('locationName')
     ??'الموقع الخاص بتقديم الخدمة';



    return Scaffold(
      appBar: CustomAppBar('أضف خدمة', context),
      body: Padding(
        padding: const EdgeInsets.only(top: 13.0, left: 13, right: 13),
        child: GetBuilder<WorkController>(builder: (_) {
          return ListView(
            children: [
              const SizedBox(
                height: 14,
              ),
              controller.images.isEmpty
                  ? InkWell(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 44.0, right: 44),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: Colors.grey[200]!),
                              color: Colors.grey[100]),
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
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
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
            
              const SizedBox(
                height: 10,
              ),

              InkWell(
                child: Container(
                  decoration:BoxDecoration(
                    borderRadius:BorderRadius.circular(12),
                    color:AppColors.cardColor
                  ),
                  child:Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                
                      Row(
                        children: [
                          Icon(Icons.location_on,color:AppColors.primary,
                          
                          ),
                          const SizedBox(width: 12,),
                          Text('الموقع',
                          style:TextStyle(color:AppColors.secondaryTextColor,
                          fontSize: 18,fontWeight:FontWeight.bold
                          ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 7,),
                
                       (controller.locationName.length>1)?
                      Text(controller.locationName,
                      style:TextStyle(color:AppColors.greyTextColor,
                      fontSize: 18,fontWeight:FontWeight.bold
                      ),
                      ): Text(locationName,
                      style:TextStyle(color:AppColors.greyTextColor,
                      fontSize: 18,fontWeight:FontWeight.bold
                      ),
                      )
                      
                    ],),
                  ),
                ),
                onTap:(){

                  Get.to(const SearchPlacesView());  
                
                },
              ),

               const SizedBox(
                height: 10,
              ),
              CustomTextFormField(
                  hint: 'وصف الموقع ',
                  max: 3,
                  color: Colors.black,
                  icon: Icons.location_pin,
                  obs: false,
                  controller: controller.locationDescription),


                const SizedBox(
                height: 10,
              ),

              Text(
                'القسم الاساسي ',
                style: TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.83,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.white),
                child: DropdownButton<String>(
                  isExpanded: true,
                  underline: const SizedBox.shrink(),
                  value: controller.selectedCat,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.changeCatValue(newValue);
                    }
                  },
                  items: controller.catListNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style: GoogleFonts.cairo(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              Text(
              ' القسم الفرعي ',
                style: TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),

              Container(
                width: MediaQuery.of(context).size.width * 0.83,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(13),
                    color: Colors.white),
                child: DropdownButton<String>(
                  underline:const SizedBox.shrink(),
                  isExpanded: true,
                  value: controller.selectedSubCat,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      controller.changeCatValue(newValue);
                    }
                  },
                  items: controller.subCatListNames
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          value,
                          style: GoogleFonts.cairo(
                              fontSize: 20, fontWeight: FontWeight.w400),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),


              const SizedBox(
                height: 14,
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
              Padding(
                padding: const EdgeInsets.only(left: 18.0, right: 18),
                child: CustomButton(
                    text: 'اضافة العمل ',
                    onPressed: () {
                      controller.addWorkToFirestore(context);
                    }),
              ),
              const SizedBox(
                height: 24,
              ),
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
