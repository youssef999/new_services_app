


 import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/bottom_navber.dart';
import 'package:freelancerApp/features/dark/dark_controller.dart';
import 'package:freelancerApp/features/splash/splash_view.dart';
import 'package:get/get.dart';


class DarkView extends StatefulWidget {
  const DarkView({super.key});

  @override
  State<DarkView> createState() => _DarkViewState();
}

class _DarkViewState extends State<DarkView> {
  DarkController controller=Get.put(DarkController());
  @override
  void initState() {

 controller.getCurrentThemeStatus();
  super.initState();

  }


  @override
  Widget build(BuildContext context) {


    //RootController rootController=Get.put(RootController());


    return  Scaffold(
      // bottomNavigationBar:buildBottomNavigationMenu(context,rootController
      //     ,  1 ),
      body:Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child:Image.asset(backgroundImage,
              fit:BoxFit.fill,),
          ),

          Padding(
            padding: const EdgeInsets.all(12.0),
            child: GetBuilder<DarkController>(
              builder: (_) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(children: [

                    const SizedBox(height: 71,),
                    Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Text("الوضع الليلي ",
                        style:TextStyle(color:kPrimaryColor,
                        fontSize: 33,fontWeight:FontWeight.w900
                        ),
                        ),
                        // FlutterSwitch(
                        //   activeText: 'نشط ',
                        //   inactiveText: 'غير مفعل',
                        //   width: 125.0,
                        //   height: 55.0,
                        //   valueFontSize: 14.0,
                        //   toggleSize: 35.0,
                        //   value:controller.themeStatus,
                        //   borderRadius: 22.0,
                        //   padding: 8.0,
                        //   showOnOff: true,
                        //   onToggle: (val) {
                        //     controller.changeThemeStatus(val);
                        //    // Get.offAll(SplashView());
                        //   },
                        // ),
                      ],
                    ),
                              //      const SizedBox(height: 61,),
                    // CustomButton(text: 'تاكيد', onPressed: (){
                    //
                    // })

                  ],),
                );
              }
            ),
          ),
        ],
      ),
    );
  }
}
