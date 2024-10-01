

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/const/app_message.dart';
import 'package:freelancerApp/features/Home/models/cat.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProposalController extends GetxController{



TextEditingController proposalController=TextEditingController();
TextEditingController priceController=TextEditingController();

List<WorkerProvider>workerData=[];


getWorkerData()async{
  final box=GetStorage();
  String email=box.read('email');
  print("EMAIL==="+email);
    try {
      print("GET TASKS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('serviceProviders')
      .where('email',isEqualTo:email)
     // .where('user_email',isEqualTo: 'test@gmail.com')
      .get();
      workerData = querySnapshot.docs.map((DocumentSnapshot doc) {
        return WorkerProvider.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();
      
      print("Tasks loaded: ${workerData.length} Tasks found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
}

addProposal({required Task task})async{
  print("ADD PROPOSAL...");
 const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)*&1!';
    Random random = Random();
    String result = '';
    final box = GetStorage();
    for (int i = 0; i < 12; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    try {
      await FirebaseFirestore.instance.collection('proposals')
      .doc(result).set({
        'name': workerData[0].name,
        'email': workerData[0].email,
         'task_id':task.id,
         'task_title':task.title,
         'task_cat':task.cat,
         "task_description":task.description,
         "task_image":task.image,
         "task_date":task.date,
         "task_time":task.time,
         "status":"قيد المراجعة",
         'id':result,
        'details':proposalController.text,
        'price':priceController.text,
      }).then((value) {
        update();
        print("DONE");
        appMessage(text: ' تم اضافة طلبك بنجاح ', fail: false);
        Get.offAll(const MainHome());
      });
    } catch (e) {
      update();
      print(e);
      appMessage(text: "error".tr, fail: true);
    }
}





}