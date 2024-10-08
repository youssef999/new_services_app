import 'package:flutter/material.dart';
import 'package:freelancerApp/core/const/constant.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/features/workers_part/controllers/workers_home_controller.dart';
import 'package:get/get.dart';
import 'package:freelancerApp/Core/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import '../../../Core/resources/app_colors.dart';
import '../../Tasks/models/task.dart';
import '../views/add_propasal.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  const TaskWidget({super.key, required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  WorkersHomeController controller = Get.put(WorkersHomeController());

  @override
  void initState() {
    super.initState();
    // Animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.95,
      upperBound: 1.0,
    );
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Check if the task status is 'canceled'
    if (widget.task.status == 'canceled') {
      return const SizedBox.shrink(); // Return an empty widget if canceled
    }

    return GestureDetector(
      onTapDown: (_) => _controller.reverse(), // Scale down on tap
      onTapUp: (_) => _controller.forward(), // Scale back up on release
      onTapCancel: () => _controller.forward(), // Handle tap cancel
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image and title
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 180,
                  width: double.infinity,
                  color: AppColors.secondaryTextColor,
                  child: Image.network(
                    widget.task.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Custom_Text(
                text: 'عنوان العمل المطلوب: ${widget.task.title}',
                color: AppColors.primary,
                fontSize: 18,
              ),
              const SizedBox(height: 12),

              // Location Info
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'الموقع: ${widget.task.locationName}',
                            style: TextStyle(
                              fontSize: 18,
                              color: AppColors.secondaryTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.description, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'وصف: ${widget.task.locationDes}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.greyTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (widget.task.locationLink.isNotEmpty)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          icon: Icon(Icons.link, color: AppColors.primary),
                          label: Text(
                            'عرض على الخريطة',
                            style: TextStyle(color: AppColors.primary),
                          ),
                          onPressed: () {
                            controller.launchUrl(widget.task.locationLink);
                          },
                        ),
                      ),
                  ],
                ),
              ),

              const Divider(height: 20, thickness: 1.2),

              // Date and Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(width: 5),
                      Text(
                        formatDate(widget.task.date),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time, color: AppColors.primary),
                      const SizedBox(width: 5),
                      Text(
                        widget.task.time.toString().replaceAll('TimeOfDay', ''),
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Pricing
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriceColumn("اقل سعر", widget.task.minPrice),
                    _buildPriceColumn("اعلي سعر", widget.task.maxPrice),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Add Proposal Button
              Center(
                child: CustomButton(
                  text: 'اضف عرضك',
                  onPressed: () {
                    Get.to(AddProposal(task: widget.task));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceColumn(String label, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondaryTextColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$price $currency',
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }
}
