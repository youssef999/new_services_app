

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/core/widgets/image/image_controller.dart';
import 'package:get/get.dart';

class ImageWidget extends StatelessWidget {

  String txt;
  ImageWidget({super.key,required this.txt});

  @override
  Widget build(BuildContext context) {
     
     ImageController controller =Get.put(ImageController());         
           return   GetBuilder<ImageController>(
             builder: (_) {
               return Column(
                    children: [
                      (controller.images.isEmpty)?
                      InkWell(
                        child: Container(
                          decoration:BoxDecoration(
                            borderRadius:BorderRadius.circular(12),
                            border: Border.all(color:  Colors.grey[200]!),
                            color: Colors.grey[200]
                          ),
                          child:Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.asset(AppAssets.imagePlaceHolder,height: 90,),
                                Text(txt,
                                style:TextStyle(
                                  color:AppColors.secondaryTextColor,
                                  fontSize: 18
                                ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap:(){
                          controller.pickMultipleImages();
                        },
                      ): buildGridView(controller)
                    ],
                  );
             }
           );
           
  }
}



  Widget buildGridView(ImageController controller) {
  
    return InkWell(
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: controller.images.length,
        gridDelegate: const
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.all(14.0),
            child: Container(
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(7),
                  color:Colors.grey[200]
                ),
                child: Image.file(File(controller.images[index].path))),
          );
        },
      ),
      onTap:(){
        controller.pickMultipleImages();
      },
    );
  }
