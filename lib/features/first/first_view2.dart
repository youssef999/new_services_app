


// import 'package:flutter/material.dart';
// import 'package:freelancerApp/core/resources/app_assets.dart';
// import 'package:freelancerApp/core/resources/app_colors.dart';
// import 'package:freelancerApp/features/auth/views/login_view2.dart';
// import 'package:get/get.dart';

// class FirstView extends StatelessWidget {
//   const FirstView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('مرحبا بك في تطبيقنا',
//             style: TextStyle(color: AppColors.mainTextColor,
//             fontSize: 24,fontWeight: FontWeight.w600
//             )),
//         centerTitle: true,
//         backgroundColor: AppColors.appBarColor,
//         elevation: 0,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 20),
//             Text(
//               'استمتع بأفضل تجربة تسجيل في تطبيقنا',
//               style: TextStyle(
//                 color: AppColors.primary,
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),
//             Text(
//               'يرجى اختيار نوع التسجيل أدناه',
//               style: TextStyle(
//                 color: AppColors.secondaryTextColor,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 30),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 InkWell(
//                   onTap: () {
//                     Get.to(LoginView(type: '0'));
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.cardColor,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           spreadRadius: 3,
//                           blurRadius: 5,
//                         )
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.asset(
//                               AppAssets.users,
//                               width: 90,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "تسجيل كمستخدم",
//                             style: TextStyle(
//                               color: AppColors.secondaryTextColor,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             "استمتع بخدماتنا المميزة",
//                             style: TextStyle(
//                               color: AppColors.secondaryTextColor,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//                 InkWell(
//                   onTap: () {
//                     Get.to(LoginView(type: '1'));
//                   },
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: AppColors.cardColor,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.1),
//                           spreadRadius: 3,
//                           blurRadius: 5,
//                         )
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(10.0),
//                       child: Column(
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: Image.asset(
//                               AppAssets.workers,
//                               width: 90
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             "تسجيل كعامل",
//                             style: TextStyle(
//                               color: AppColors.secondaryTextColor,
//                               fontSize: 18,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Text(
//                             "انضم إلى فريق عملنا اليوم",
//                             style: TextStyle(
//                               color: AppColors.secondaryTextColor,
//                               fontSize: 13,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Text(
//               'التسجيل سهل وسريع، ابدأ الآن!',
//               style: TextStyle(
//                 color: AppColors.primary,
//                 fontSize: 22,
//                 fontWeight: FontWeight.w500,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
