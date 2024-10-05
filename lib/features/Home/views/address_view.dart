


 import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/Core/widgets/custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AddressView extends StatefulWidget {
  List<String> addressName;

 AddressView({super.key,required this.addressName});

  @override
  State<AddressView> createState() => _AddressViewState();
}

class _AddressViewState extends State<AddressView> {

  HomeController controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar('', context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<HomeController>(
          builder: (_) {
            return ListView(children: [
              const SizedBox(height: 12),
              SizedBox(
                //  height: 300, // Adjust the height as needed
                width: double.maxFinite,
                child:
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.addressName.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                        title: Text(widget.addressName[index],
                        style:TextStyle(color:AppColors.secondaryTextColor
                            ,fontSize: 18,fontWeight: FontWeight.bold),
                        ),
                        trailing:
                        Checkbox(value: controller.checkListValues[index],
                            onChanged: (value) {
                              controller.changeAddressValue(index,value!);
                              print(value);
                            }
                        )

                    );
                  },
                ),

              ),

              const SizedBox(height: 32,),

              Padding(
                padding: const EdgeInsets.only(left: 28.0,right: 28),
                child: CustomButton(text: 'موافقة ', onPressed: (){

                  final box=GetStorage();
                  box.write('address', controller.selectedCountry);
                  Get.offAll(const MainHome());

                }),
              )


            ],);
          }
        ),
      ),
    );
  }
}
