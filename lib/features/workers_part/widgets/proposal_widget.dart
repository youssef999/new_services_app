



import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/workers_part/models/proposal.dart';
import 'package:freelancerApp/features/workers_part/views/add_propasal.dart';
import 'package:get/get.dart';

import '../controllers/filter_tasks_controller.dart';


class ProposalWidget extends StatelessWidget {
  Proposal task;
 ProposalWidget({super.key,required this.task});

  @override
  Widget build(BuildContext context) {

  
FilterTasksController controller =Get.put(FilterTasksController());

    return Container(
      decoration:BoxDecoration(
        borderRadius:BorderRadius.circular(12),
        border: Border.all(color:  Colors.grey[200]!),
        color: AppColors.cardColor
      ),
      child:Padding(
        padding: const EdgeInsets.only(top:3.0,left: 10,right: 10),
        child: Column(
          mainAxisAlignment:MainAxisAlignment.start,
          children: [
        
         Row(
           children: [
             ClipRRect(
               borderRadius:BorderRadius.circular(22),
                 child:
                 Card(
                   color:Colors.grey[200],
                   child: Image.network(task.image,
                   height: 160,
                   fit:BoxFit.fill,
                   width: MediaQuery.of(context).size.width*0.88,
                   ),
                 ),
             ),
           ],
         ),
           const SizedBox(height: 10,),

           Row(
             children: [
               Container(
                decoration:BoxDecoration(
                  borderRadius:BorderRadius.circular(12),
                  color:AppColors.primary
                ),
                child:Padding(
                  padding: const EdgeInsets.only(left: 22.0,right: 22,top:8,bottom: 8),
                  child: Column(children: [
                    const Text("بيانات العميل ",
                    style: TextStyle(color:Colors.white,
                    fontWeight:FontWeight.bold,  fontSize: 18
                    ),
                    ),
                    Text(task.user_name,
                    style:TextStyle(color:AppColors.secondaryTextColor,
                    fontSize: 16
                    ),
                    ),
                    Text(task.user_email,
                    style:TextStyle(color:AppColors.secondaryTextColor,
                      fontSize: 16
                    ),
                    ),
                  ],),
                ),
               ),
             const  SizedBox(width: 22,),

               (task.status=='accepted')?
                InkWell(
                  child: Image.asset(AppAssets.whatsAppIcon,
                            height:82,width: 55,
                            ),
                            onTap:(){
                     controller.openWhatsApp(task.user_phone);
                            },

                ):const SizedBox()
             ],
           ),

          const SizedBox(height: 11,),

          Row(
            children: [
  //'عنوان العمل المطلوب' +

               Text(
                  'عنوان العمل المطلوب' 
                  ,style:TextStyle(
                    color:AppColors.secondaryTextColor,fontWeight:FontWeight.w600
                  ,fontSize: 17),),

               Text(
                    
                  " : " +
                  task.title,style:TextStyle(
                    color:AppColors.primary,fontWeight:FontWeight.w600
                  ,fontSize: 15),),

                 const SizedBox(width: 20,),

                   
            ],
          ),
         const SizedBox(height: 4,),
        
          Row(
            children: [
              Text('موعد العمل : ',
              style: TextStyle(
                color:AppColors.secondaryTextColor,
                fontSize: 17,fontWeight:FontWeight.w600
              ),
              ),
              Text(task.date.replaceAll('00:00:00.000', ''),
              style:TextStyle(color:AppColors.primary,fontSize: 14),),
              const SizedBox(width: 11,),
                Text(task.time.replaceAll('TimeOfDay', ''),
                style:TextStyle(color:AppColors.primary,fontSize: 14),),
            ],
          ),
        const SizedBox(height: 10,),
          Row(
            children: [

               Text(' عرضك : ',
              style: TextStyle(
                color:AppColors.secondaryTextColor,
                fontSize: 17,fontWeight:FontWeight.w600
              ),
              ),
              Expanded(
                child: Text  
                (
                  " "+task.details,
                  style:TextStyle(color:AppColors.primary
                //  .withOpacity(0.9)
                  ,fontSize: 15),),
              ),
            ],
          ),
         const SizedBox(height: 10,),

           Row(
             children: [


              Text("السعر المحدد : ",
              style:TextStyle(
                color:AppColors.secondaryTextColor,
                fontSize: 17,fontWeight:FontWeight.w600
              ),
              ),
               Text(task.price+" "+currency,
                      style:TextStyle(
                        color:AppColors.primary,
                        fontSize: 15,fontWeight:FontWeight.w600
                      ),
                      ),
             ],
           ),

          const  SizedBox(height: 11,),

           Row(
             children: [
               Text('حالة الطلب : ',
                      style:TextStyle(
                        color:AppColors.secondaryTextColor,
                        fontSize: 16,fontWeight:FontWeight.w600
                      ),
                      ),
                   (task.status!='ملغي')?
                       Text(task.status,
                      style:const TextStyle(
                        color:Colors.green,
                        fontSize: 15,fontWeight:FontWeight.w600
                      ),
                      ):      Text(task.status,
                      style:const TextStyle(
                        color:Colors.red,
                        fontSize: 15,fontWeight:FontWeight.w600
                      ),
                      )               
             ],
           ),

            const SizedBox(height: 12,),
          
           (task.status=='قيد المراجعة')?
           Card(
            color:Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(11),
              child:Text('الغاء الطلب',
              style:TextStyle(
                color:AppColors.mainTextColor,
                fontSize: 17,fontWeight:FontWeight.w600
              ),
              ),
            ),
           ):const SizedBox(),
         
          const SizedBox(height: 12,)


        ],),
      ),
    );
  }
}