import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/const/app_message.dart';
import 'package:freelancerApp/core/helpers/notifications_helper.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/proposal.dart';

class UserTasksController extends GetxController {
  List<Task> userTaskList = [];
  List<Proposal> userProposalList = [];

  Future<void> changeStatusProposal(
      Proposal proposal, String status, BuildContext context) async {
    try {
      CollectionReference proposalsCollection =
          FirebaseFirestore.instance.collection('proposals');
      CollectionReference tasksCollection =
          FirebaseFirestore.instance.collection('tasks');

      // Update the status field of the proposal document with the given ID
      await proposalsCollection.doc(proposal.id).update({
        'status': status,
      });
      print("Proposal with ID ${proposal.id} has been updated successfully!");

      // Get the task ID from the proposal
      String taskId =
          proposal.taskId; // Assuming taskId is a property of Proposal

      // Update the status of the corresponding task
      await tasksCollection.doc(taskId).update({
        'status': status,
      });
      print("Task with ID $taskId has been updated to status $status!");

      // Sending notifications and messages based on the status
      final token = await getWorkerFcmTokenByEmail(proposal.email);
      if (status == 'accepted') {
        NotificationService.sendNotification(
          token ?? '',
          'تم قبول طلبك',
          'تم قبول طلبك من قبل العميل',
        );
        appMessage(text: 'تم قبول الطلب', fail: false, context: context);
        Get.offAll(const MainHome());
      } else {
        NotificationService.sendNotification(
          token ?? '',
          'تم رفض طلبك',
          'تم رفض طلبك من قبل العميل',
        );
        appMessage(text: 'تم رفض الطلب', fail: false, context: context);
      }
    } catch (e) {
      print("Error updating document: $e");
      appMessage(text: 'فشل في تحديث الطلب', fail: true, context: context);
    }
  }

  Future<String?> getWorkerFcmTokenByEmail(String email) async {
    try {
      // Query Firestore for a user document where the 'email' field matches the provided email
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('serviceProviders')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        // Document found, retrieve the FCM token
        DocumentSnapshot doc = snapshot.docs.first;
        String fcmToken = doc['fcmToken'] ?? '';
        return fcmToken;
      } else {
        print("No worker found with email: $email");
        return null;
      }
    } catch (e) {
      print("Error fetching FCM token: $e");
      return null;
    }
  }

  Future<void> showDeleteConfirmationDialog(
      BuildContext context, dynamic value) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تاكيد الحذف'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('هل انت متاكد من حذف هذا العمل ؟ '),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('احذف الان '),
              onPressed: () async {
                await deleteTask(value, context);
                Navigator.of(context).pop(); // Dismiss the dialog
                // Call deleteTask if confirmed
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showCancelConfirmationDialog(
      BuildContext context, String taskId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('تأكيد الالغاء'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('هل تريد الغاء هذا العمل؟'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('لا'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('الغاء الان '),
              onPressed: () async {
                await cancelTask(taskId);
                Navigator.of(context).pop(); // Dismiss the dialog
                // Call deleteTask if confirmed
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> cancelTask(String taskId) async {
    try {
      // Reference to the Firestore tasks collection
      final tasksCollection = FirebaseFirestore.instance.collection('tasks');

      // Fetch the task document by ID and update its status
      await tasksCollection.doc(taskId).update({
        'status': 'canceled',
      });

      print('Task status updated to canceled.');
    } catch (e) {
      print('Failed to update task status: $e');
    }
  }

  Future<void> deleteTask(dynamic value, BuildContext context) async {
    print("delete task $value");
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('id', isEqualTo: value)
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
        print('Deleted task with ID: ${doc.id}');
        appMessage(text: 'تم الحذف بنجاح ', fail: false, context: context);
        getUserTaskList();
      }
      print('All matching tasks deleted successfully.');
    } catch (e) {
      print('Error deleting task(s): $e');
    }
  }

  String getArabicStatus(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'جديدة';
      case 'accepted':
        return 'تم القبول';
      case 'done':
        return 'تم الانتهاء';
      case 'canceled':
        return 'تم الالغاء';
      default:
        return 'حالة غير معروفة'; // "Unknown status" if the input doesn't match any case
    }
  }

  Future<void> getUserTaskList() async {
    userTaskList = [];
    try {
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('user_email', isEqualTo: GetStorage().read('email'))
          .get();

      userTaskList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();
      print("Tasks loaded: ${userTaskList.length} Tasks found.");
    } catch (e) {
      // Handle any errors
      print("Error fetching ads: $e");
    }
  }

  Future<List<Proposal>> fetchProposals(String taskId) async {
    print("fetching proposals $taskId");
    userProposalList = [];
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      final CollectionReference proposalsCollection =
          firestore.collection('proposals');
      // Query Firestore for proposals with the given taskId and order by task_date
      final QuerySnapshot querySnapshot = await proposalsCollection
          .where('task_id', isEqualTo: taskId)
          .orderBy('task_date',
              descending: true) // Order by task_date (latest first)
          .get();

      // Convert the query snapshot into a list of Proposal objects
      return querySnapshot.docs
          .map((doc) => Proposal.fromDocument(doc))
          .toList();
    } catch (e) {
      // Handle any errors that occur during the fetch
      print('Error fetching proposals: $e');
      return []; // Return an empty list in case of error
    }
  }
}
