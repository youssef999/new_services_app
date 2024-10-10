import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/app_styles.dart';
import 'package:freelancerApp/features/workers_part/controllers/worker_tasks_controller.dart';
import 'package:freelancerApp/features/workers_part/widgets/proposal_widget.dart';
import 'package:get/get.dart';

class WorkerTasks extends StatefulWidget {
  const WorkerTasks({super.key});

  @override
  State<WorkerTasks> createState() => _WorkerTasksState();
}

class _WorkerTasksState extends State<WorkerTasks> {
  WorkerTasksController controller = Get.put(WorkerTasksController());

  @override
  void initState() {
    controller.getWorkerProposal();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        toolbarHeight: 60,
        backgroundColor: AppColors.primary,
        title: Padding(
          padding: const EdgeInsets.all(7),
          child: Text(
            "عملك",
            style: Styles.appBarTextStyle,
          ),
        ),
      ),
      body: GetBuilder<WorkerTasksController>(
        builder: (_) {
          return controller.proposalList.isNotEmpty
              ? Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: controller.proposalList.length,
                        itemBuilder: (context, index) {
                          return ProposalWidget(
                            task: controller.proposalList[index],
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(AppAssets.emptyTasks),
                      const SizedBox(height: 10),
                      Text(
                        'لا مهام قيد التنفيذ الان',
                        style: TextStyle(
                          color: AppColors.secondaryTextColor,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
