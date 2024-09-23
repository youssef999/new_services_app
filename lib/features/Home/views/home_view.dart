import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/Core/widgets/Custom_Text.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/features/Home/models/ad.dart';
import 'package:freelancerApp/features/Home/models/cat.dart';
import 'package:freelancerApp/features/Home/widgets/workers_widget.dart';
import 'package:freelancerApp/features/Work/views/add_work.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:freelancerApp/features/workers/views/workers_view.dart';
import 'package:get/get.dart';
import '../../workers/widgets/workers_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    controller.getUserLocation();
    controller.getAds();
    controller.getCats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('الرئيسية', context),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GetBuilder<HomeController>(builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AdsWidget(adsList: controller.adsList),
              const SizedBox(
                height: 11,
              ),
              Custom_Text(
                  text: 'التصنيفات',
                  fontSize: 20,
                  color: AppColors.secondaryTextColor),
              const SizedBox(
                height: 16,
              ),
              CatListView(controller: controller),

              // const AddNewTaskWidget(),
              const SizedBox(
                height: 16,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Custom_Text(
                      text: "عمال بالقرب منك ",
                      fontSize: 20,
                      color: AppColors.secondaryTextColor),
                  InkWell(
                    child: Text(
                      "الجميع ",
                      style: TextStyle(
                          textBaseline: TextBaseline.ideographic,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary),
                    ),
                    onTap: () {
                      Get.to(WorkersCatView(cat: 'All'));
                    },
                  )
                ],
              ),
              const SizedBox(
                height: 11,
              ),
              const WorkersWidget(cat: 'All'),
              WorkerProvidersList(controller: controller),
            ],
          );
        }),
      ),
    );
  }
}

class CatListView extends StatelessWidget {
  HomeController controller;
  CatListView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // Set layout direction to RTL
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal, // Horizontal scrolling
          itemCount: controller.catList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5.0), // Add right padding
              child: CatWidget(cat: controller.catList[index]),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 15),
        ),
      ),
    );
  }
}

class WorkerProvidersList extends StatelessWidget {
  HomeController controller;
  WorkerProvidersList({super.key, required this.controller});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: controller.workersList.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: WorkerCard(
                worker: controller.workersList[index],
              ));
        });
  }
}

class AddNewTaskWidget extends StatelessWidget {
  const AddNewTaskWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 18.0, right: 18),
      child: InkWell(
        child: Container(
            height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.primary,
            ),
            child: Center(
                child: Text('اضف طلب خدمة جديد ',
                    style: TextStyle(
                        color: AppColors.mainTextColor, fontSize: 19)))),
        onTap: () {
          Get.to(const AddWork());
        },
      ),
    );
  }
}

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
              height: 7,
            ),
            Custom_Text(
                text: cat.name,
                fontSize: 16,
                color: AppColors.secondaryTextColor),
          ],
        ),
      ),
      onTap: () {
        Get.to(WorkersCatView(cat: cat.name));
      },
    );
  }
}

class AdsWidget extends StatelessWidget {
  final List<Ad>? adsList; // Make adsList nullable
  const AdsWidget({super.key, required this.adsList});

  @override
  Widget build(BuildContext context) {
    if (adsList == null || adsList!.isEmpty) {
      return const Center(
        child:
            CircularProgressIndicator(), // Show loading indicator if adsList is null or empty
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity, // Make the container take full width
        height: 180.0, // Set the height
        child: CarouselSlider.builder(
          itemCount: adsList!.length, // Use adsList safely with null-check
          options: CarouselOptions(
            height: 180.0, // Set the desired height
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 8),
            autoPlayAnimationDuration: const Duration(seconds: 1),
            viewportFraction: 1.0, // Ensure the carousel uses the full width
            enlargeCenterPage: false, // Prevent enlarging the center image
          ),
          itemBuilder: (context, index, realIndex) {
            return ClipRRect(
                borderRadius: BorderRadius.circular(16), // Rounded corners
                child: CachedNetworkImage(
                  imageUrl: adsList![index].imageUrl, // Safely access adsList
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  width: double.infinity, // Ensure the image takes full width
                  height: 180.0, // Match the height of the carousel
                  fit: BoxFit.cover,
                ));
          },
        ),
      ),
    );
  }
}
