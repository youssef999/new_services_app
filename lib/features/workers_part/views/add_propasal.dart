// ignore_for_file: public_member_api_docs, sort_constructors_first


import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/workers_part/controllers/proposal_controller.dart';

class AddPropasal extends StatefulWidget {

  Task task;
  AddPropasal({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<AddPropasal> createState() => _AddPropasalState();
}

class _AddPropasalState extends State<AddPropasal> {



 ProposalController controller =Get.put(ProposalController());
  @override
  void initState() {
    controller.getWorkerData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    ProposalController controller =Get.put(ProposalController());
    return Scaffold(
      appBar:CustomAppBar('', context),
      body:Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          const SizedBox(height: 11,),
          TaskWidget(task: widget.task),
           const SizedBox(height: 11,),
           Padding(
             padding: const EdgeInsets.only(left: 21.0,right: 20),
             child: CustomTextFormField(hint: 'سعرك لهذا العمل ', 
             type:TextInputType.number,
                       obs: false, controller: controller.priceController),
           ),
            const SizedBox(height: 11,),
          Padding(
            padding: const EdgeInsets.only(left: 20.0,right: 20),
            child: CustomTextFormField(hint: 'تفاصيل عرضك ', 
            max: 10,
            obs: false, controller: controller.proposalController),
          ),
          const SizedBox(height: 20,),
          CustomButton(text: ' اضف الان ', onPressed: (){
            controller.addProposal(task: widget.task);
          })
        ],),
      ),
    );
  }
}




class TaskWidget extends StatelessWidget {
  Task task;
 TaskWidget({super.key,required this.task});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:BoxDecoration(
        borderRadius:BorderRadius.circular(12),
        border: Border.all(color:  Colors.grey[200]!),
        color: AppColors.cardColor
      ),
      child:Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.start,
          children: [
         

         Row(
           children: [
             ClipRRect(
               child: Container(
                width: MediaQuery.of(context).size.width*085/100,
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(10),color: AppColors.secondaryTextColor
                ),
                 child: Padding(
                   padding: const EdgeInsets.all(4.0),
                   child: Image.network(task.image,
                   width: MediaQuery.of(context).size.width
                   ),
                 ),
               ),
             ),
           ],
         ),
           const SizedBox(height: 10,),
          Row(
            children: [

               Text(
                    
                  'عنوان العمل المطلوب' +" : " +
                  task.title,style:TextStyle(color:AppColors.secondaryTextColor,fontWeight:FontWeight.w600
                  ,fontSize: 17),),
            ],
          ),
         const SizedBox(height: 10,),
        
          Row(
            children: [
              Text(task.date.replaceAll('00:00:00.000', ''),style:TextStyle(color:AppColors.primary,fontSize: 14),),
              const SizedBox(width: 11,),
                Text(task.time.replaceAll('TimeOfDay', ''),
                style:TextStyle(color:AppColors.primary,fontSize: 14),),
            ],
          ),
        const SizedBox(height: 10,),
          Row(
            children: [
              Expanded(
                child: Text
  (
    "وصف العمل المطلوب : "+task.description,style:TextStyle(color:AppColors.greyTextColor
                  .withOpacity(0.9)
                  ,fontSize: 14),),
              ),
            ],
          ),
         const SizedBox(height: 10,),
         Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
        
              Column(
                children: [
                 Text("اقل سعر ",
                  style:TextStyle(
                    color:AppColors.secondaryTextColor,
                    fontSize: 18,fontWeight:FontWeight.w600
                  ),
                  ),
        
                  Text(task.minPrice+" "+currency,
                  style:TextStyle(
                    color:AppColors.primary,
                    fontSize: 18,fontWeight:FontWeight.bold
                  ),
                  ),
                ],
              ),
        
            
        
               Column(
                 children: [
                   Text("اعلي سعر ",
                  style:TextStyle(
                    color:AppColors.secondaryTextColor,
                    fontSize: 18,fontWeight:FontWeight.w600
                  ),
                  ),
                   Text(task.maxPrice+" "+currency,
                               style:TextStyle(
                    color:AppColors.primary,
                    fontSize: 18,fontWeight:FontWeight.bold
                               ),
                               ),
                 ],
               ),
            ],),

          const  SizedBox(height: 11,),


        
        
        
        ],),
      ),
    );
  }
}