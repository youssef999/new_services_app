import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancerApp/core/resources/app_colors.dart';
import 'package:intl/intl.dart';

class AcceptedProposalScreen extends StatelessWidget {
  final String taskId;

  const AcceptedProposalScreen({Key? key, required this.taskId})
      : super(key: key);

  Future<Map<String, dynamic>?> fetchAcceptedProposal(String taskId) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference acceptedProposalsCollection =
          firestore.collection('accepted_proposals');

      // Query Firestore for the document with the given taskId
      final QuerySnapshot querySnapshot = await acceptedProposalsCollection
          .where('task_id', isEqualTo: taskId)
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
                // Format the date to "yyyy-M-dd" (e.g., "2024-4-09")
                return DateFormat('yyyy-M-dd').format(date);
              } catch (e) {
                print('Error formatting date: $e');
                return dateString; // Return original if formatting fails
              }
            }

            String formatTime(String timeString) {
              try {
                // Extract time inside "TimeOfDay(07:31)" by removing "TimeOfDay(" and ")"
                String time =
                    timeString.replaceAll("TimeOfDay(", "").replaceAll(")", "");
                return time; // Returns the time in "07:31" format
              } catch (e) {
                print('Error formatting time: $e');
                return timeString; // Return original if formatting fails
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
                  DetailItem(label: 'الهاتف', value: proposalData['phone']),
                  DetailItem(label: 'السعر', value: proposalData['price']),
                  DetailItem(label: 'الفئة', value: proposalData['task_cat']),
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
                  // Display task image if available
                  proposalData['task_image'] != null
                      ? Image.network(proposalData['task_image'])
                      : Container(),
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
