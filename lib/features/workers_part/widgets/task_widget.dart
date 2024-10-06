import 'package:flutter/material.dart';
import 'package:freelancerApp/core/const/constant.dart';
import 'package:freelancerApp/features/workers_part/controllers/workers_home_controller.dart';
import 'package:get/get.dart';
import 'package:freelancerApp/Core/widgets/custom_button.dart';
import 'package:intl/intl.dart';
import '../../../Core/resources/app_colors.dart';
import '../../Tasks/models/task.dart';
import '../views/add_propasal.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  TaskWidget({super.key, required this.task});

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> with SingleTickerProviderStateMixin {
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
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.reverse(), // Scale down on tap
      onTapUp: (_) => _controller.forward(),  // Scale back up on release
      onTapCancel: () => _controller.forward(), // Handle tap cancel
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05), // Reduced shadow intensity
                blurRadius: 12, // Softer shadow
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image and title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.78,
                        height: 160, // Slightly increased height for a balanced look
                        color: AppColors.secondaryTextColor,
                        child: Image.network(
                          widget.task.image,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Task title
                Text(
                  'عنوان العمل المطلوب  :  ${widget.task.title}',
                  style: TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 20, // Increased font size for emphasis
                  ),
                ),
                const SizedBox(height: 10),
                // Task location info
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[100], // Lighter background for contrast
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'الموقع',
                            style: TextStyle(
                              color: AppColors.secondaryTextColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 20, // Balanced heading size
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              "عنوان موقع العميل: ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Flexible(
                              child: Text(
                                widget.task.locationName,
                                style: TextStyle(
                                  color: AppColors.greyTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "وصف للعنوان: ",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                            const SizedBox(width: 9),
                            Flexible(
                              child: Text(
                                widget.task.locationDes,
                                maxLines: 4,
                                style: TextStyle(
                                  color: AppColors.greyTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (widget.task.locationLink.isNotEmpty)
                          InkWell(
                            child: Row(
                              children: [
                                Icon(Icons.link_outlined, color: AppColors.primary, size: 20),
                                const SizedBox(width: 9),
                                Text(
                                  'عرض علي الخريطة',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              controller.launchUrl(widget.task.locationLink);
                            },
                          ),
                      ],
                    ),
                  ),
                ),

                const Divider(),

                // Task date and time
                Row(
                  children: [
                    Icon(Icons.calendar_today, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      formatDate(widget.task.date),
                      style: TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.access_time, color: AppColors.primary, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.task.time.toString().replaceAll('TimeOfDay', ''),
                      style: TextStyle(color: AppColors.primary, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Pricing (Min and Max prices)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriceColumn("اقل سعر", widget.task.minPrice),
                    _buildPriceColumn("اعلي سعر", widget.task.maxPrice),
                  ],
                ),
                const SizedBox(height: 16),

                // Button to add a proposal
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
      ),
    );
  }

  // Helper widget for pricing information
  Widget _buildPriceColumn(String label, String price) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.secondaryTextColor,
            fontSize: 18,
            fontWeight: FontWeight.w600,
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

  // Function to format date
  String formatDate(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }
}
