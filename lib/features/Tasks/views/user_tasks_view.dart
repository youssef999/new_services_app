import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/resources/app_styles.dart';
import 'package:freelancerApp/core/resources/colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Tasks/controllers/user_tasks_controller.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/Tasks/views/accepted_proposal_screen.dart';
import 'package:freelancerApp/features/Tasks/views/edit_task_screen.dart';
import 'package:freelancerApp/features/Tasks/views/proposals_screen.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTasksView extends StatefulWidget {
  const UserTasksView({super.key});

  @override
  State<UserTasksView> createState() => _UserTasksViewState();
}

class _UserTasksViewState extends State<UserTasksView> {
  UserTasksController controller = Get.put(UserTasksController());
  bool isDialogShown = false;

  @override
  void initState() {
    controller.getUserTaskList();
    super.initState();
  }

  void listenToProposalStatus(String taskId) {
    Future.delayed(const Duration(seconds: 2), () async {
      while (true) {
        // Fetch the status from the server or database
        String status = await fetchProposalStatus(taskId);

        if (status == 'finished' && !isDialogShown) {
          isDialogShown = true;
          //  showTaskCompletionConfirmationDialog(taskId);
        }
        await Future.delayed(
            const Duration(seconds: 5)); // Poll every 5 seconds
      }
    });
  }

  Future<String> fetchProposalStatus(String taskId) async {
    try {
      // Reference to the 'accepted_proposals' collection
      final acceptedProposalsRef = FirebaseFirestore.instance
          .collection('accepted_proposals')
          .where('task_id', isEqualTo: taskId)
          .where('status', isEqualTo: 'finished')
          .limit(1);

      // Fetch the document from Firestore
      QuerySnapshot querySnapshot = await acceptedProposalsRef.get();

      // Check if there is a document with 'finished' status
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot document = querySnapshot.docs.first;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('workerEmail', document['email']);
        prefs.setString('workerName', document['name']);
        prefs.setString('taskTitle', document['task_title']);
        prefs.setString('taskDescription', document['task_description']);

        return document['status']; // Return the 'finished' status
      } else {
        return 'no finished proposal'; // If no 'finished' proposal exists
      }
    } catch (e) {
      // Handle any errors that occur during fetching
      print('Error fetching proposal status: $e');
      return 'error';
    }
  }

  Future<Map<String, dynamic>> fetchTaskDetails(String taskId) async {
    // Fetch the task details from Firestore using the taskId
    try {
      DocumentSnapshot taskDoc = await FirebaseFirestore.instance
          .collection('tasks')
          .doc(taskId)
          .get();

      if (taskDoc.exists) {
        return taskDoc.data() as Map<String, dynamic>;
      } else {
        return {}; // Return an empty map if the task doesn't exist
      }
    } catch (e) {
      print('Error fetching task details: $e');
      return {};
    }
  }

  void showTaskCompletionConfirmationDialog(String taskId) async {
    Map<String, dynamic> taskDetails = await fetchTaskDetails(taskId);
    SharedPreferences prefs = await SharedPreferences.getInstance();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("هل تم انهاء هذه المهمة؟"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("عنوان المهمة: ${prefs.getString('taskTitle')}"),
              Text("وصف المهمة: ${prefs.getString('taskDescription')}"),
              Text("مقدم الخدمة: ${prefs.getString('workerName')}"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
                showTaskFinishedDialog(); // Show rating dialog if confirmed
              },
              child: const Text("نعم، تم الانتهاء"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the confirmation dialog
                isDialogShown = false; // Reset dialog flag
              },
              child: const Text("لا"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateServiceProviderRating(
      String email, double newRating) async {
    try {
      // Reference to the service provider's document based on their email
      final serviceProviderRef = FirebaseFirestore.instance
          .collection('serviceProviders')
          .where('email', isEqualTo: email)
          .limit(1);

      // Fetch the document snapshot for the service provider
      QuerySnapshot querySnapshot = await serviceProviderRef.get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot serviceProviderDoc = querySnapshot.docs.first;
        DocumentReference docRef = serviceProviderDoc.reference;

        // Get the current rating and rating count from the document
        // Cast or convert the values as necessary
        double currentRating = (serviceProviderDoc['rating'] ?? 0.0).toDouble();
        int ratingCount = (serviceProviderDoc['ratingCount'] ?? 0).toInt();

        // Calculate the new rating
        double totalRating = (currentRating * ratingCount) + newRating;
        int newRatingCount = ratingCount + 1;
        double updatedRating = totalRating / newRatingCount;

        // Ensure the rating stays between 0 and 5
        updatedRating = updatedRating.clamp(0.0, 5.0);

        // Update the service provider's rating and rating count
        await docRef.update({
          'rating': updatedRating,
          'ratingCount': newRatingCount,
        });

        print("Service provider's rating updated successfully.");
      } else {
        print("No service provider found with the given email.");
      }
    } catch (e) {
      print('Error updating service provider rating: $e');
    }
  }

  void showTaskFinishedDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("✅ تمت المهمة بنجاح"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("ما مدي رضاءك عن مقدم هذه الخدمة؟"),
              const SizedBox(height: 16),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  print("Rating: $rating");
                  updateServiceProviderRating(
                      prefs.getString('workerEmail') ?? '', rating);
                  // You can handle the rating submission here
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog after confirming
                // Submit rating if necessary
              },
              child: const Text("تأكيد"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog without rating
              },
              child: const Text("الغاء"),
            ),
          ],
        );
      },
    );
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
            "خدماتك",
            style: Styles.appBarTextStyle,
          ),
        ),
      ),
      body: GetBuilder<UserTasksController>(builder: (_) {
        return RefreshIndicator(
          onRefresh: () async {
            setState(() {
              controller.getUserTaskList();
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                const SizedBox(
                  height: 12,
                ),
                (controller.userTaskList.isEmpty)
                    ? Center(
                        child: Column(children: [
                        Image.asset(
                          AppAssets.noTasks,
                          height: 300,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text("لا يوجد مهام",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w600))
                      ]))
                    : ListView.builder(
                        shrinkWrap: true,
                        reverse: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.userTaskList.length,
                        itemBuilder: (context, index) {
                          listenToProposalStatus(
                              controller.userTaskList[index].id);
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TaskWidget(
                              controller: controller,
                              task: controller.userTaskList[index],
                            ),
                          );
                        })
              ],
            ),
          ),
        );
      }),
    );
  }
}

// ignore: must_be_immutable
class TaskWidget extends StatelessWidget {
  UserTasksController controller;
  Task task;
  TaskWidget({super.key, required this.task, required this.controller});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: AppColors.grey.withOpacity(0.8),
          spreadRadius: 2,
          blurRadius: 2,
          offset: const Offset(0, 0), // changes position of shadow
        ),
      ], borderRadius: BorderRadius.circular(12), color: AppColors.cardColor),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 31,
                              backgroundImage: NetworkImage(task.image),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              children: [
                                Text(
                                  task.title,
                                  style: TextStyle(
                                      color: AppColors.secondaryTextColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  task.date.replaceAll('00:00:00.000', ''),
                                  style: TextStyle(
                                      color: AppColors.greyTextColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Text(
                              "حالة الخدمة : ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              controller.getArabicStatus(task.status),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    PriceTile(
                        minPrice: task.minPrice,
                        maxPrice: task.maxPrice,
                        currency: currency)
                  ],
                ),

                // Image.network(task.image,
                // fit:BoxFit.cover,
                // height: 80,width: 100,
                // ),

                const SizedBox(
                  height: 8,
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            //fake push
            task.status == 'accepted'
                ? Row(
                    children: [
                      CustomButton(
                          btnColor: Colors.green,
                          text: 'متابعة',
                          onPressed: () {
                            Get.to(AcceptedProposalScreen(taskId: task.id));
                          }),
                    ],
                  )
                : task.status == 'done'
                    ? const SizedBox()
                    : task.status == 'canceled'
                        ? const SizedBox()
                        : FittedBox(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                CustomButton(
                                    btnColor: Colors.green,
                                    text: 'العروض',
                                    onPressed: () {
                                      Get.to(ProposalScreen(taskId: task.id));
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomButton(
                                    text: 'تعديل ',
                                    onPressed: () {
                                      Get.to(EditTaskScreen(task: task));
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                CustomButton(
                                    text: 'الغاء ',
                                    btnColor: Colors.red,
                                    onPressed: () {
                                      controller.showCancelConfirmationDialog(
                                          context, task.id);
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                IconButton(
                                    onPressed: () {
                                      controller.showDeleteConfirmationDialog(
                                          context, task.id);
                                    },
                                    icon: const Icon(Icons.delete))
                              ],
                            ),
                          ),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class PriceTile extends StatelessWidget {
  final String minPrice;
  final String maxPrice;
  final String currency;

  const PriceTile({
    Key? key,
    required this.minPrice,
    required this.maxPrice,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        color: AppColors.primary.withOpacity(0.1),
        margin: const EdgeInsets.all(8.0),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "أقل سعر",
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$minPrice $currency",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(width: 1, color: AppColors.secondaryTextColor),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "أعلى سعر",
                      style: TextStyle(
                        color: AppColors.secondaryTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$maxPrice $currency",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
