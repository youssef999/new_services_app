

// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:freelancerApp/core/const/app_message.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/workers_part/models/proposal.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class FilterTasksController extends GetxController{

  List<Task>tasksList=[];


  void openWhatsApp(String phone) async {
  String whatsappUrl = "https://wa.me/$phone"; // Replace with "whatsapp://send?phone=$phone" for a different approach
  // ignore: deprecated_member_use
  if (await canLaunch(whatsappUrl)) {
    await launch(whatsappUrl);
  } else {
   // ignore: deprecated_member_use
   await launch(whatsappUrl);
  }
}

  Future<void> getTaskList(String cat) async {
  tasksList=[];
    try {
      print("GET TASKS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('tasks')
      .where('cat',isEqualTo: cat)
     // .where('user_email',isEqualTo: 'test@gmail.com')
      .get();
      tasksList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();
      print("Tasks loaded: ${tasksList.length} Tasks found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }


  void cancelTask(Proposal task,BuildContext context) async {
  // Reference to Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    // Update the status field to 'canceled' for the specific task
    await firestore.collection('proposals').doc(task.id).update({
      'status': 'ملغي',
    });
    print('Task canceled successfully');
    appMessage(text: 'تم الغاء الطلب بنجاح', fail: false,context: context);
    Get.offAll(const MainHome());
  
  } catch (e) {
    print('Error updating task: $e');
  }
}




}