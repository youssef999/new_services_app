



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/const/app_message.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:get/get.dart';

class UserTasksController extends GetxController{

 List<Task>userTaskList = [];


Future<void> showDeleteConfirmationDialog(BuildContext context, dynamic value) async {
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
               await deleteTask(value);
            Navigator.of(context).pop(); // Dismiss the dialog
              // Call deleteTask if confirmed
            },
          ),
        ],
      );
    },
  );
}

Future<void> deleteTask( dynamic value) async {

  print("delete task $value");
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('tasks')
        .where('id', isEqualTo: value)
        .get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      await doc.reference.delete();
      print('Deleted task with ID: ${doc.id}');
      appMessage(text: 'تم الحذف بنجاح ', fail: false);
      getUserTaskList();
    }
    print('All matching tasks deleted successfully.');
  } catch (e) {
    print('Error deleting task(s): $e');
  }
}
 Future<void> getUserTaskList() async {
  userTaskList=[];
    try {
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('tasks')
      .where('user_email',isEqualTo: 'test@gmail.com')
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

}