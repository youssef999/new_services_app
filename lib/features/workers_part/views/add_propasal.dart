import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this for date formatting

import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/workers_part/controllers/proposal_controller.dart';

class AddProposal extends StatefulWidget {
  Task task;
  AddProposal({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<AddProposal> createState() => _AddProposalState();
}

class _AddProposalState extends State<AddProposal> {
  ProposalController controller = Get.put(ProposalController());

  @override
  void initState() {
    controller.getWorkerData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(widget.task.title, context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            const SizedBox(height: 15),
            TaskWidget(task: widget.task),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextFormField(
                hint: 'سعرك لهذا العمل ',
                type: TextInputType.number,
                obs: false,
                controller: controller.priceController,
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: CustomTextFormField(
                hint: 'تفاصيل عرضك ',
                max: 10,
                obs: false,
                controller: controller.proposalController,
              ),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'اضف الان',
              onPressed: () {
                controller.addProposal(task: widget.task, context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TaskWidget extends StatelessWidget {
  Task task;
  TaskWidget({super.key, required this.task});
  String formatDate(String date) {
    try {
      DateTime parsedDate = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(parsedDate);
    } catch (e) {
      return date; // Fallback to the original string if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes the position of the shadow
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                task.image,
                width: MediaQuery.of(context).size.width,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),

            // Task Title
            Text(
              'عنوان العمل المطلوب: ${task.title}',
              style: TextStyle(
                color: AppColors.secondaryTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),

            // Date & Time with Icons
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  formatDate(task.date), // Use formatted date
                  style: TextStyle(color: AppColors.primary, fontSize: 14),
                ),
                const SizedBox(width: 15),
                Icon(Icons.access_time, color: AppColors.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  task.time
                      .replaceAll('TimeOfDay', '')
                      .replaceAll('(', '')
                      .replaceAll(')', ''),
                  style: TextStyle(color: AppColors.primary, fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Task Description
            Text(
              'وصف العمل المطلوب: ${task.description}',
              style: TextStyle(
                color: AppColors.greyTextColor.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 15),
            Divider(
              color: AppColors.greyTextColor.withOpacity(0.3),
              thickness: 1,
            ),
            const SizedBox(height: 10),

            // Pricing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(
                      "اقل سعر ",
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${task.minPrice} $currency',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      "اعلى سعر ",
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${task.maxPrice} $currency',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
