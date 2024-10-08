import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:intl/intl.dart';

class AcceptedProposalScreen extends StatelessWidget {
  final String taskId;

  const AcceptedProposalScreen({Key? key, required this.taskId})
      : super(key: key);

  Future<Map<String, dynamic>?> fetchAcceptedProposal(String taskId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference proposalsCollection =
          firestore.collection('proposals');

      // Query Firestore for the document with the given taskId
      final QuerySnapshot querySnapshot = await proposalsCollection
          .where('task_id', isEqualTo: taskId)
          .where('status', isEqualTo: 'accepted')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Return the first matching document's data
        return querySnapshot.docs.first.data() as Map<String, dynamic>?;
      } else {
        return null; // No matching proposal found
      }
    } catch (e) {
      print('Error fetching accepted proposal: $e');
      return null; // Return null in case of error
    }
  }

  Future<void> updateTaskStatus(String taskId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final DocumentReference taskDocRef =
          firestore.collection('tasks').doc(taskId);

      // Update the status to "done"
      await taskDocRef.update({'status': 'done'});
      print("Task status updated to 'done'.");
    } catch (e) {
      print('Error updating task status: $e');
    }
  }

  void showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد'),
          content: const Text('هل قام مقدم الخدمة بانهاء هذا العمل؟'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text('لا'),
            ),
            TextButton(
              onPressed: () {
                updateTaskStatus(taskId); // Update task status
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop();
              },
              child: const Text('نعم'),
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
        title: const Text(
          'تفاصيل العرض المقبول',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: fetchAcceptedProposal(taskId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('حدث خطأ في تحميل البيانات'));
          } else if (snapshot.data == null) {
            return const Center(child: Text('لم يتم العثور على عرض مقبول'));
          } else {
            String formatDate(String dateString) {
              try {
                DateTime date = DateTime.parse(dateString);
                return DateFormat('yyyy-MM-dd').format(date);
              } catch (e) {
                print('Error formatting date: $e');
                return dateString;
              }
            }

            String formatTime(String timeString) {
              try {
                return timeString
                    .replaceAll("TimeOfDay(", "")
                    .replaceAll(")", "");
              } catch (e) {
                print('Error formatting time: $e');
                return timeString;
              }
            }

            final proposalData = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  DetailItem(label: 'الاسم', value: proposalData['name']),
                  DetailItem(
                      label: 'التفاصيل',
                      value:
                          proposalData['details'] ?? "الانهاء و التسليم فوري"),
                  DetailItem(
                      label: 'البريد الإلكتروني', value: proposalData['email']),
                  DetailItem(label: 'السعر', value: proposalData['price']),
                  DetailItem(
                      label: 'الفئة', value: proposalData['task_cat'] ?? ""),
                  DetailItem(
                      label: 'تاريخ المهمة',
                      value: formatDate(proposalData['task_date'])),
                  DetailItem(
                      label: 'وصف المهمة',
                      value: proposalData['task_description']),
                  DetailItem(
                      label: 'وقت المهمة',
                      value: formatTime(proposalData['task_time'])),
                  DetailItem(
                      label: 'عنوان المهمة', value: proposalData['task_title']),
                  const SizedBox(height: 20),
                  proposalData['task_image'] != null
                      ? Image.network(proposalData['task_image'])
                      : Container(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                          text: 'انتهاء الخدمة',
                          onPressed: () {
                            showConfirmationDialog(context);
                          }),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

// Widget to display each detail row
class DetailItem extends StatelessWidget {
  final String label;
  final String value;

  const DetailItem({Key? key, required this.label, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 16.0),
          Flexible(
            child: Text(value, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
