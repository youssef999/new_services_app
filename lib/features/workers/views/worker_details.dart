import 'package:flutter/material.dart';
import 'package:freelancerApp/core/const/constant.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:rate/rate.dart';

class WorkerDetails extends StatelessWidget {
  final WorkerProvider worker;

  WorkerDetails({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBar('', context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: screenSize.width * 0.12,
                  backgroundImage: NetworkImage(worker.image),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker.name,
                        style: TextStyle(
                          color: AppColors.secondaryTextColor,
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Rate(
                        iconSize: 20,
                        color: Colors.amber,
                        allowHalf: true,
                        allowClear: true,
                        initialValue: double.parse(worker.rate.toString()),
                        readOnly: true,
                        onChange: (value) => print(value),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        worker.cat,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: screenSize.width * 0.045,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              worker.details,
              style: TextStyle(
                color: AppColors.secondaryTextColor.withOpacity(0.7),
                fontSize: screenSize.width * 0.04,
                height: 1.5,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 16),
            Divider(color: AppColors.secondaryTextColor.withOpacity(0.2)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "سعر خدمة يبدا من: ",
                  style: TextStyle(
                    color: AppColors.secondaryTextColor,
                    fontSize: screenSize.width * 0.045,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "${worker.price} ${currency}",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: screenSize.width * 0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: Image.asset(
                AppAssets.whatsApp,
                height: 88,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
