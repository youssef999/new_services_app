import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_assets.dart';

import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/workers_part/controllers/workers_home_controller.dart';
import 'package:freelancerApp/features/workers_part/widgets/task_widget.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/Core/widgets/custom_text.dart';

class WorkersHome extends StatefulWidget {
  const WorkersHome({super.key});

  @override
  State<WorkersHome> createState() => _WorkersHomeState();
}

class _WorkersHomeState extends State<WorkersHome> {
  WorkersHomeController controller = Get.put(WorkersHomeController());
//
  @override
  void initState() {
    controller.getTaskList();
    controller.getCats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WorkersHomeController>(
      builder: (_) {
        return Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            elevation: 0.2,
            backgroundColor: AppColors.primary,
            title: Text(
              "المهام",
              style: TextStyle(
                  color: AppColors.mainTextColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600),
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  controller.openFilterDialog(context);
                },
                icon: Icon(
                  Icons.filter_list,
                  color: AppColors.mainTextColor,
                ),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                const SizedBox(height: 12),
                // Task List Section
                (controller.tasksList.isEmpty)
                    ? _buildEmptyTaskState()
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.tasksList.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                TaskWidget(task: controller.tasksList[index]),
                          );
                        },
                      ),
                const SizedBox(height: 20),
                // New Features Section
                const FeaturesSection(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget for when the task list is empty
  Widget _buildEmptyTaskState() {
    return Center(
      child: Column(
        children: [
          Image.asset(
            AppAssets.emptyTasks,
            height: 300,
          ),
          const SizedBox(height: 20),
          Text(
            "لا يوجد مهام",
            style: TextStyle(
              color: AppColors.secondaryTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Custom_Text(
              text: 'مميزات التعامل من خلال التطبيق',
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.secondaryTextColor,
            ),
          ),
          const SizedBox(height: 12),
          const FeatureItem(
            icon: Icons.star_border,
            text:
                '١- الحصول على تقييم جيد يعطيك إمكانية اختيارك في الكثير من الأعمال',
          ),
          const SizedBox(height: 8),
          const FeatureItem(
            icon: Icons.work_outline,
            text:
                '٢- يتم ظهور عدد مشاريعك للعملاء مما يوفر لك فرص عمل أقوى وأكثر',
          ),
          const SizedBox(height: 8),
          const FeatureItem(
            icon: Icons.security_outlined,
            text: '٣- التطبيق يساعد في ضمان حقوقك',
          ),
          const SizedBox(height: 8),
          const FeatureItem(
            icon: Icons.card_giftcard,
            text:
                '٤- مستقبلاً سيتم إضافة ميزات للفنيين الأكثر عملاً وتحصيل نقاط كهدايا',
          ),
          const SizedBox(height: 8),
          const FeatureItem(
            icon: Icons.warning_amber_outlined,
            text: '٥- التعامل الخارجي يعد مخالفة لسياستنا وقد يعرض حسابك للحظر',
          ),
        ],
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Custom_Text(
            text: text,
            fontSize: 18,
            color: AppColors.secondaryTextColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
