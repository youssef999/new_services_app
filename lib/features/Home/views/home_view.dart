import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/Core/widgets/Custom_Text.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/features/Home/models/ad.dart';
import 'package:freelancerApp/features/Home/models/cat.dart';
import 'package:freelancerApp/features/Home/models/sub_cat.dart';
import 'package:freelancerApp/features/Home/views/address_view.dart';
import 'package:freelancerApp/features/Home/widgets/cat_widget.dart';
import 'package:freelancerApp/features/Home/widgets/wokrer_subcat.dart';
import 'package:freelancerApp/features/Home/widgets/workers_widget.dart';
import 'package:freelancerApp/features/cat/cat_view.dart';
import 'package:freelancerApp/features/subCat_views/subcat_home_view.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../subCat_views/subcat_view.dart';
import 'all_workers.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    String address=box.read('address')?? 'اختر الموقع';
   // controller.getUserLocation();
    controller.getAllAddress();
    controller.getAllWorkers('All',address);
    controller.getAds();
    controller.getCats();
    controller.getSubCats();
    super.initState();
  }
  final box = GetStorage();

  @override
  Widget build(BuildContext context) {
    String address=box.read('address')?? 'اختر الموقع';
    return Scaffold(
      appBar:
      AppBar(
        elevation: 0.7,
        backgroundColor: AppColors.primary,
        title: Column(children: [

          Text(
              "الرئيسية",
              style: TextStyle(
                color: AppColors.mainTextColor,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),

          InkWell(
            child: Row(
              //mainAxisAlignment:MainAxisAlignment.center,
              children: [
                // Icon(Icons.location_on_rounded,
                //   size: 20,color: AppColors.secondaryTextColor,),
               const SizedBox(width: 2,),
                Text(
                address,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 15,),
                Icon(Icons.arrow_drop_down_circle_outlined,
                color:AppColors.mainTextColor,
                )
              ],
            ),
            onTap:(){
              Get.to(AddressView(
                addressName: controller.addressName
              ));
            },
          ),
          const SizedBox(height: 10,),

        ],)
      ),



      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15,

        ),
        child: GetBuilder<HomeController>(builder: (_) {
          return ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              AdsWidget(adsList: controller.adsList),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Custom_Text(
                      text: 'التصنيفات',
                      fontSize: 20,
                      color: AppColors.secondaryTextColor),
                  InkWell(
                    child: Custom_Text(
                      text: 'جميع التصنيفات',
                      fontSize: 16,
                      color: AppColors.greyTextColor,
                    ),
                    onTap: () {

                      Get.to(CatView(
                        catList: controller.catList,
                      ));

                    },
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 10, right: 10),
                  child: GridView.builder(
                      itemCount: controller.catList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                          childAspectRatio: 0.97
                          ),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CatWidget(cat: controller.catList[index]),
                        );
                      })),
              const SizedBox(height: 6),
              // CatListView(controller: controller),
             // const SizedBox(height: 5),

              Divider(thickness: 0.1,
              color:AppColors.primary,
              ),
              const SizedBox(height: 6),

              for (int i = 0; i < controller.catList.length; i++)
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      children: [

                        Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 31,
                                  backgroundImage: NetworkImage(
                                    controller.catList[i].imageUrl,
                                  ),
                                ),
                                const SizedBox(
                                  width: 11,
                                ),
                                Text(
                                  controller.catList[i].name,
                                  style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                                )
                              ],
                            ),

                            InkWell(
                              child: Text("المزيد",
                                style: TextStyle(color: AppColors.primary),),
                              onTap:(){

                               Get.to(SubCatView(cat: controller.catList[i].name,

                               ));

                              },
                            ),



                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        SizedBox(
                          height: 154,
                          //width: double.infinity,
                          child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: controller.subCatList.length,
                              itemBuilder: (context, index) {
                                if (controller.subCatList[index].cat ==
                                    controller.catList[i].name) {
                                  print("index==xx=" + index.toString());
                                  print(
                                      "HERE1 ${controller.subCatList[index].name}");
                                  print("HERE2 ${controller.catList[i].name}");
                                  return InkWell(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 102,
                                        width: 122,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey[500]!.withOpacity(0.2), // Shadow color
                                                spreadRadius: 5, // Spread radius
                                                blurRadius: 7, // Blur radius
                                                offset: const Offset(0, 3), // Changes the position of the shadow
                                              ),
                                            ],
                                            border: Border.all(
                                              color: AppColors.grey
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: AppColors.cardColor),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 1,
                                              ),
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: Image.network(
                                                  controller
                                                      .subCatList[index].image,
                                                  width: MediaQuery.of(context).size.width,
                                                  height: 75,
                                                  fit:BoxFit.fill,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 9,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(left:3.0,right: 3),
                                                child: Text(
                                                  controller
                                                      .subCatList[index].name,
                                                  style: TextStyle(
                                                      color: AppColors
                                                          .secondaryTextColor,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    onTap: () {
                                      //SubCatHomeView
                                      Get.to(SubCatHomeView(
                                        subcat:
                                            controller.subCatList[index].name,
                                        cat: controller.catList[i].name,
                                      ));
                                    },
                                  );
                                } else {
                                  print("ELSEXXX");
                                  return Container();
                                }
                              }),
                        )
                      ],
                    ),
                  ),
                ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Custom_Text(
                      text: "الاعلي تقييما ",
                      fontSize: 20,
                      color: AppColors.secondaryTextColor),
                  InkWell(
                    child: Text(
                      "الجميع ",
                      style: TextStyle(
                        textBaseline: TextBaseline.ideographic,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.greyTextColor,
                      ),
                    ),
                    onTap: () {
                      Get.to(AllWorkers(
                        workersList: controller.workersList,
                      ));
                    },
                  )
                ],
              ),

              const SizedBox(height: 11),

              WorkerProvidersList(controller: controller),
              const SizedBox(height: 11),

              // New Features Section
              FeaturesSection(),

              const SizedBox(height: 16),
            ],
          );
        }),
      ),
    );
  }
}

class WorkerProviderWithCatWidget extends StatelessWidget {
  Cat cat;
  SubCat subCat;
  List<WorkerProvider> workersSubCatList;

  WorkerProviderWithCatWidget(
      {super.key,
      required this.cat,
      required this.subCat,
      required this.workersSubCatList});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: AppColors.cardColor),
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundImage: NetworkImage(
                  cat.imageUrl,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              //Image.network(cat.imageUrl,width: 40,height: 40,),
              Text(
                cat.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
          Text(
            subCat.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(
            height: 10,
          ),

          //WorkerCardWidget(worker: workersSubCatList[0]),
          SizedBox(
            height: 80,
            child: ListView.builder(
                itemCount: workersSubCatList.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  if (workersSubCatList[index].subCat == subCat.name) {
                    return WorkerSubCatCardWidget(
                        worker: workersSubCatList[index]);
                  } else {
                    return const SizedBox();
                  }
                }),
          )
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Custom_Text(
              text: 'مميزات التعامل من خلال التطبيق',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          FeatureItem(
            icon: Icons.star_border,
            text: '١- تقييم الفني أمام الجميع',
          ),
          const SizedBox(height: 8),
          FeatureItem(
            icon: Icons.report_problem_outlined,
            text: '٢- إمكانية تقديم شكاوي',
          ),
          const SizedBox(height: 8),
          FeatureItem(
            icon: Icons.verified_user_outlined,
            text:
                '٣- ظهورك كعميل مميز يعطي الفنيين الرغبة بتنفيذ طلبك بأفضل جودة',
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  FeatureItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Custom_Text(
            text: text,
            fontSize: 18,
            color: AppColors.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
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
        height: 130.0, // Set the height
        child: CarouselSlider.builder(
          itemCount: adsList!.length, // Use adsList safely with null-check
          options: CarouselOptions(
            height: 125.0, // Set the desired height
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
                  height: 130.0, // Match the height of the carousel
                  fit: BoxFit.cover,
                ));
          },
        ),
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
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: controller.catList.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.only(right: 5.0),
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
    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.workersList.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: WorkerCardWidget(
                worker: controller.workersList[index],
              ));
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 4, childAspectRatio: 0.88));
  }
}
