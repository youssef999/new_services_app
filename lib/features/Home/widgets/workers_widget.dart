import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/features/workers/controllers/workers_controller.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:freelancerApp/features/workers/widgets/workers_widget.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class WorkersWidget extends StatefulWidget {
  final String cat;
  const WorkersWidget({super.key, required this.cat});

  @override
  State<WorkersWidget> createState() => _WorkersWidgetState();
}

class _WorkersWidgetState extends State<WorkersWidget> {
  WorkersController controller = Get.put(WorkersController());

  @override
  void initState() {
    super.initState();
    controller.getAllWorkers(widget.cat);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220, // Adjust height as needed
      child: GetBuilder<WorkersController>(
        builder: (_) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.workersList.length,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: controller.workersList[index].image,
                          width: 150,
                        ),
                      ),
                      Custom_Text(
                        text: controller.workersList[index].name,
                        fontSize: 18,
                      ),
                      Custom_Text(
                        text: controller.workersList[index].cat,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
