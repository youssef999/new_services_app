

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/features/Home/models/cat.dart';
import 'package:freelancerApp/features/subCat_views/subcat_view.dart';
import 'package:freelancerApp/features/workers/views/workers_view.dart';
import 'package:get/get.dart';
import '../../../Core/widgets/Custom_Text.dart';

class CatWidget extends StatelessWidget {
  Cat cat;
  CatWidget({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
        child: Column(
          children: [
            CircleAvatar(
                radius: 33,
                backgroundColor: AppColors.greyTextColor.withOpacity(0.2),
                child: CachedNetworkImage(
                  imageUrl: cat.imageUrl,
                  width: 45,
                )),
            const SizedBox(
              height: 5,
            ),
            Center(
              child:Text(
                cat.name,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 12),
              ),
              // child: Custom_Text(
              //     text: cat.name,
              //     fontSize: 14,
              //     color: AppColors.secondaryTextColor),
            ),
          ],
        ),
      ),
      onTap: () {
        Get.to(SubCatView(cat: cat.name));

      },
    );
  }
}