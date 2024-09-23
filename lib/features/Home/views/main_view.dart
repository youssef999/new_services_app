import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/features/Home/views/home_view.dart';
import 'package:freelancerApp/features/workers_part/views/workers_home.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconly/iconly.dart';
import '../../Tasks/views/user_tasks_view.dart';
import '../../Work/views/add_work.dart';
import '../../settings/views/settings_view.dart';
import '../../workers_part/views/worker_taks.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State createState() => _State();
}

List<Widget> fragmentScreens = [
  const HomeView(),
  const AddWork(),
  const UserTasksView(),
  const SettingsView(),
];

List<TabItem<dynamic>> iconsList = [
  const TabItem(
    icon: IconlyBold.home,
    title: '',
  ),
  const TabItem(icon: IconlyBold.plus, title: ''),
  const TabItem(icon: IconlyBold.category, title: ''),
  const TabItem(
    icon: IconlyBold.setting,
    title: '',
  ),
];

int indexNumber = 0;

class _State extends State<MainHome> {
  @override
  void initState() {
    final box = GetStorage();
    String roleId = box.read('roleId') ?? '0';
    print("ROLEID====" + roleId);

    if (roleId == '0') {
      fragmentScreens = [
        const HomeView(),
        const AddWork(),
        const UserTasksView(),
        const SettingsView(),
      ];

      iconsList = [
        const TabItem(
          icon: IconlyBold.home,
          title: '',
        ),
        const TabItem(icon: Icons.add, title: ''),
        const TabItem(icon: IconlyBold.category, title: ''),
        const TabItem(
          icon: IconlyBold.setting,
          title: '',
        ),
      ];
    } else {
      fragmentScreens = [
        const WorkersHome(),
        const WorkerTasks(),
        //const UserTasksView(),
        const SettingsView(),
      ];
      iconsList = [
        const TabItem(
          icon: Icons.home,
          title: '',
        ),
        const TabItem(icon: Icons.list, title: ''),
        //  const TabItem(icon: Icons.list,title: ''),
        const TabItem(
          icon: Icons.settings,
          title: '',
        ),
      ];
    }
    //WorkersHome
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const HelloConvexAppBar();
  }
}

class HelloConvexAppBar extends StatefulWidget {
  const HelloConvexAppBar({super.key});

  @override
  State<HelloConvexAppBar> createState() => _HelloConvexAppBarState();
}

class _HelloConvexAppBarState extends State<HelloConvexAppBar> {
  @override
  Widget build(BuildContext context) {
    //Color backgroundCovex = Colors.white;

    return Scaffold(
      backgroundColor: AppColors.appBarColor,
      body: Container(child: fragmentScreens[indexNumber]),
      bottomNavigationBar: ConvexAppBar(
          backgroundColor: AppColors.primary,
          elevation: 2,
          height: 60,
          top: -8,
          //curveSize: 10,
          activeColor: AppColors.activeIconColor,
          //color: AppColors.inActiveIconColor,
          style: TabStyle.reactCircle,
          items: iconsList,
          initialActiveIndex: 0,
          onTap: (int i) {
            setState(() {
              indexNumber = i;
            });
            print(i);
          }
          //=> print('click index='),
          ),
    );
  }
}

// void showBottomSheet(BuildContext context) {
//   showModalBottomSheet(
//     context: context,
//     builder: (BuildContext builderContext) {
//       return Container(
//         height: 300,
//         decoration: BoxDecoration(
//            color: Colors.black,
//             borderRadius: BorderRadius.circular(1)),
//         child: const Card(
//             child: GridWidget()),
//       );
//     },
//   );
// }

// class GridWidget extends StatelessWidget {
//   const GridWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<String> imageList = [
//       AppAssets.homeIcon,
//       AppAssets.homeIcon,
//       AppAssets.homeIcon,
//       AppAssets.homeIcon,
//     ];

//     List<String> txtList = [

//       //'profile'.tr,
//       'Home',
//       'Home',
//       'Home',
//       'Home',
//     ];

//     return Padding(
//       padding: const EdgeInsets.only(top:18.0,left: 10,right: 10),
//       child: GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: 4, // Number of columns
//               crossAxisSpacing: 1.6, // Spacing between columns
//               mainAxisSpacing: 1.7,
//               childAspectRatio:0.9// Spacing between rows
//           ),
//           physics:const NeverScrollableScrollPhysics(),
//           itemCount: txtList.length,
//           itemBuilder: (context, index) {
//             return Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: InkWell(
//                 child: Container(
//                   decoration:BoxDecoration(
//                       borderRadius:BorderRadius.circular(12),
//                       // border:Border.all(color:Colors.grey)
//                       color:Colors.black

//                   ),
//                   child: Column(
//                     children: [
//                       const SizedBox(
//                         height: 7,
//                       ),
//                       SizedBox(
//                         height: 30,
//                         child: Image.asset(imageList[index]),
//                       ),
//                       const SizedBox(
//                         height: 6,
//                       ),
//                       Center(child: Padding(
//                         padding: const EdgeInsets.all(3.0),
//                         child: Text(txtList[index],
//                           style:const TextStyle(fontSize: 12,
//                               fontWeight: FontWeight.w500,
//                               color:Colors.black
//                           ),
//                         ),
//                       ),
//                       )

//                     ],
//                   ),
//                 ),
//                 onTap: () {
//                   if (index == 0) {
//                     GoRouter.of(context).push(AppRouter.kHomeView);
//                   }

//                   if (index == 1) {
//                     GoRouter.of(context).push(AppRouter.kHomeView);
//                   }

//                   //
//                 },
//               ),
//             );
//           }),
//     );
//   }
//}
