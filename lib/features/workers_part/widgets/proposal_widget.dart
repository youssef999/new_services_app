import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/features/workers_part/models/proposal.dart';
import 'package:get/get.dart';
import '../controllers/filter_tasks_controller.dart';

class ProposalWidget extends StatefulWidget {
  final Proposal task;

  const ProposalWidget({Key? key, required this.task}) : super(key: key);

  @override
  _ProposalWidgetState createState() => _ProposalWidgetState();
}

class _ProposalWidgetState extends State<ProposalWidget> {
  String userEmail = '';
  String userName = '';
  String userPhone = '';

  @override
  void initState() {
    super.initState();
    fetchUserDetails(
        widget.task.task_id); // Assume 'id' is the field for task_id
  }

  Future<void> fetchUserDetails(String taskId) async {
    try {
      final taskDoc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();
      if (taskDoc.exists) {
        final data = taskDoc.data();
        if (data != null) {
          setState(() {
            userEmail = data['user_email'] ?? '';
            userName = data['user_name'] ?? '';
            userPhone = data['user_phone'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  String formatTime(String time) {
    // Extracts the time from "TimeOfDay(hh:mm)"
    final timeRegex = RegExp(r"TimeOfDay\((\d{1,2}):(\d{2})\)");
    final match = timeRegex.firstMatch(time);
    if (match != null) {
      int hour = int.parse(match.group(1)!); // Get the hour as int
      final minute = match.group(2); // Get the minute
      final period = hour >= 12 ? 'PM' : 'AM';

      // Convert hour to 12-hour format
      hour = hour % 12 == 0 ? 12 : hour % 12;

      return '$hour:$minute $period';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    FilterTasksController controller = Get.put(FilterTasksController());

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                widget.task.image,
                height: 160,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: AppColors.grey.withOpacity(0.1),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Custom_Text(
                    text: "بيانات العميل",
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Custom_Text(
                        text: "اسم العميل:",
                        textAlign: TextAlign.right,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Custom_Text(
                          text: userName.isNotEmpty ? userName : 'غير متوفر',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Custom_Text(
                        text: "حساب العميل:",
                        textAlign: TextAlign.right,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Custom_Text(
                          text: userEmail.isNotEmpty
                              ? userEmail
                              : '...جاري التحميل',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Custom_Text(
                        text: "هاتف العميل:",
                        textAlign: TextAlign.right,
                        fontWeight: FontWeight.bold,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Custom_Text(
                          text: userPhone.isNotEmpty
                              ? userPhone
                              : '...جاري التحميل',
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (widget.task.status == 'accepted')
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    controller.openWhatsApp(userPhone);
                  },
                  child: Image.asset(
                    AppAssets.whatsAppIcon,
                    height: 55,
                    width: 55,
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Custom_Text(
                  text: 'عنوان العمل المطلوب: ',
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 8),
                Custom_Text(
                  text: widget.task.title,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Custom_Text(
                  text: 'موعد العمل: ',
                  fontWeight: FontWeight.bold,
                ),
                Custom_Text(
                  text: widget.task.date.replaceAll('00:00:00.000', ''),
                ),
                const SizedBox(
                  width: 12,
                ),
                const Custom_Text(
                  text: 'الساعة: ',
                ),
                const SizedBox(
                  width: 5,
                ),
                Custom_Text(
                  text: formatTime(widget.task.time),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Custom_Text(
                  text: 'عرضك: ',
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(width: 8),
                Custom_Text(
                  text: widget.task.details,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Custom_Text(
                  text: 'السعر المحدد:',
                  fontWeight: FontWeight.bold,
                ),
                Custom_Text(
                  text: '${widget.task.price} KWD',
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Custom_Text(
                  text: 'حالة الطلب:',
                  fontWeight: FontWeight.bold,
                ),
                Custom_Text(
                  text: widget.task.status,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (widget.task.status == 'قيد المراجعة')
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Custom_Text(
                    text: 'الغاء الطلب',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
