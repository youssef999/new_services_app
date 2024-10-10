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
  final WorkersHomeController controller = Get.put(WorkersHomeController());

  @override
  void initState() {
    super.initState();
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
    if (widget.task.status == 'canceled') {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTapDown: (_) => _controller.reverse(),
      onTapUp: (_) => _controller.forward(),
      onTapCancel: () => _controller.forward(),
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
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(height: 12),
              _buildLocationInfo(),
              const Divider(height: 20, thickness: 1.2),
              _buildDateTimeInfo(),
              const SizedBox(height: 12),
              _buildPricingInfo(),
              const SizedBox(height: 12),
              // Add Proposal Button conditionally displayed
              Center(
                child: FutureBuilder<bool>(
                  future: controller.checkProposalExists(widget.task.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    // Hide button if proposal exists
                    if (snapshot.hasData && snapshot.data!) {
                      return const SizedBox.shrink();
                    }
                    return CustomButton(
                      text: 'اضف عرضك',
                      onPressed: () {
                        Get.to(AddProposal(task: widget.task));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Container(
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
              const Icon(Icons.location_on, color: Colors.black),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'الموقع: ${widget.task.locationName}',
                  style: TextStyle(
                      fontSize: 18, color: AppColors.secondaryTextColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.description, color: Colors.black),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'وصف: ${widget.task.locationDes}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
          if (widget.task.locationLink.isNotEmpty)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                icon: Icon(Icons.link, color: AppColors.primary),
                label: Text('عرض على الخريطة',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: AppColors.primary)),
                onPressed: () {
                  controller.launchUrl(widget.task.locationLink);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDateTimeInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.black),
            const SizedBox(width: 5),
            Text(
              formatDate(widget.task.date),
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
        Row(
          children: [
            const Icon(Icons.access_time, color: Colors.black),
            const SizedBox(width: 5),
            Text(
              widget.task.time.toString().replaceAll('TimeOfDay', ''),
              style: const TextStyle(color: Colors.black, fontSize: 14),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPricingInfo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
