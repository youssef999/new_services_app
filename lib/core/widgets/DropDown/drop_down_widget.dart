

// import 'package:flutter/material.dart';
// import 'package:freelancerApp/core/resources/app_colors.dart';
// import 'package:get/get.dart';

// class DropDownWidget extends StatelessWidget {
//   String value;
//   Function(String?)? onChanged;
//   List<String> items;

//   DropDownWidget({super.key,
//   required this.value,required this.items,this.onChanged
//   });

//   @override
//   Widget build(BuildContext context) {

//     return Container(
//       width:MediaQuery.of(context).size.width,
//       decoration:BoxDecoration(
//         borderRadius:BorderRadius.circular(12),
//         color: AppColors.DropDownColor
//       ),
//       child: DropdownButton<String>(
//          underline: const SizedBox.shrink(),
//               value: value,
//               onChanged: (newValue) {

//                 onChanged!(newValue);
//               //controller.updateSelectedItem(newValue!);
//               },
//               items: items.map((String item) {
//                 return DropdownMenuItem<String>(
//                   value: item,
                  
//                   child: Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Text(item,
//                     style:TextStyle(
//                       color:AppColors.greyTextColor
//                     ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//     ));
//   }
// }