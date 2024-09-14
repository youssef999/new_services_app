


 import 'package:flutter/material.dart';

import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/features/Home/models/ad.dart';
import 'package:freelancerApp/features/Home/models/cat.dart';
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

  HomeController controller=Get.put(HomeController());
  
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
      appBar: CustomAppBar('Home', context),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<HomeController>(
          builder: (_) {
            return ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AdsWidget(adsList: controller.adsList),
                ),
               const SizedBox(height: 11,),
               CatGridView(controller: controller),
           
               // const AddNewTaskWidget(),
                const SizedBox(height: 11,),
             
            
                Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                  children: [
                  Text("عمال بالقرب منك ",
                  style:TextStyle(fontSize:20,color:AppColors.secondaryTextColor),
                  ),
                  
                   InkWell(
                     child: Text("الجميع ",
                                       
                                       style:TextStyle(
                      textBaseline: TextBaseline.ideographic,
                      decoration: TextDecoration.underline,
                      fontSize:16,color:AppColors.greyTextColor),
                                       ),
                                       onTap:(){
                                        Get.to(WorkersCatView(cat: 'All'));
                                       },
                   )
                ],),
                const SizedBox(height: 11,),

                WorkerProvidersList(controller: controller),
              ],
            );
          }
        ),
      ),
    );
  }
}

class CatGridView extends StatelessWidget {

  HomeController controller;
  CatGridView({super.key,required this.controller});

  @override
  Widget build(BuildContext context) {
    return    GridView.builder(
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1.5,
                      // crossAxisSpacing: 4,
                      // mainAxisSpacing: 4
                  ),
                  shrinkWrap: true,
                  physics: const ScrollPhysics(),
                  itemCount: controller.catList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CatWidget(cat: controller.catList[index]),
                    );
                  },
                );
  }
}

class WorkerProvidersList extends StatelessWidget {
   HomeController controller;
  WorkerProvidersList({super.key,required this.controller});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: controller.workersList.length ,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 8.0,right:8),
          child:  WorkerCard(worker: controller.workersList[index],)
        );
      
    });
  }
}






class AddNewTaskWidget extends StatelessWidget {
  const AddNewTaskWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:18.0,right: 18),
      child: InkWell(
        child: Container(
          height: 90,
          decoration:BoxDecoration(
            borderRadius:BorderRadius.circular(18),
            color:AppColors.primary,
          ),
          child: Center(
            child: Text('اضف طلب خدمة جديد ',
            style:TextStyle(
              color:AppColors.mainTextColor,
              fontSize: 19
            )
        ))
        ),
        onTap:(){

          Get.to(const AddWork());

        },
      ),
    );
  }
}


class CatWidget extends StatelessWidget {
  Cat cat;
  CatWidget({super.key,required this.cat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: SizedBox(
      
        child: Column(
          children: [
            CircleAvatar(
              radius: 33,
              backgroundImage:NetworkImage(cat.imageUrl),
            ),
      
           const SizedBox(height: 7,),
      
            Text(cat.name,
            style:TextStyle(
              color:AppColors.secondaryTextColor,
              fontSize: 16,
              fontWeight:FontWeight.w500
              ),
            ),
      
          ],
        ),
      ),
      onTap:(){
        Get.to(WorkersCatView(
          cat: cat.name
        ));
      },
    );
  }
}


class AdsWidget extends StatelessWidget {

  List<Ad>adsList;
AdsWidget({super.key,required this.adsList});

  @override
  Widget build(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width*0.81,
    decoration:BoxDecoration(
     borderRadius:BorderRadius.circular(14),
       color: AppColors.primary

    ),
    child: FlutterCarousel(
    options: FlutterCarouselOptions(
      height: 171.0,
      showIndicator: true,
      autoPlay: true,
    slideIndicator: CircularSlideIndicator(),
    ),
    items: adsList.map((i) {
      return Builder(
        builder: (BuildContext context) {
          return  Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration:BoxDecoration(
          borderRadius:BorderRadius.circular(14),
           color: AppColors.primary
        ),
        child:
        ClipRRect(
          borderRadius:BorderRadius.circular(14),
          child:Image.network(i.imageUrl,
             // width:MediaQuery.of(context).size.width*0.88,
              fit:BoxFit.cover
          ),
        ),
      ),
    );
        },
      );
    }).toList(),
    ),
  );
  }}