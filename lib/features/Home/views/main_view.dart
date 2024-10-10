import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/features/Home/views/home_view.dart';
import 'package:freelancerApp/features/settings/views/settings_view.dart';
import 'package:freelancerApp/features/workers_part/views/workers_home.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconly/iconly.dart';
import '../../Tasks/views/user_tasks_view.dart';
import '../../Work/views/add_work.dart';
import '../../settings/views/settings_view2.dart';
import '../../workers_part/views/worker_taks.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State createState() => _State();
}

List<Widget> fragmentScreens =[
  const HomeView(),
  AddWork(cat: '', subCat: '',),
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

    indexNumber = 0;
    final box = GetStorage();
    String roleId = box.read('roleId') ?? '0';
    print("ROLEID====" + roleId);

    if (roleId == '0') {
      fragmentScreens = [
        const HomeView(),
        AddWork(subCat: '', cat: '',

        ),
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
          icon: Icons.home, title: '' ),
        const TabItem(icon: Icons.list, title: ''),
        //  const TabItem(icon: Icons.list,title: ''),
        const TabItem( icon: Icons.settings,title: ''),
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


