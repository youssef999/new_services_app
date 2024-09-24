import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/const/app_message.dart';
import 'package:freelancerApp/features/Home/views/home_view.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../settings/models/user.dart';

class WorkController extends GetxController {
  final ImagePicker picker = ImagePicker();
  List<XFile> images = [];

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TimeOfDay? endSelectedTime;
  bool validation = false;

  List<User> userDataList = [];

  getUserData() async {
    final box = GetStorage();
    String email = box.read('email');
    try {
      print("GET TASKS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          // .where('user_email',isEqualTo: 'test@gmail.com')
          .get();
      userDataList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return User.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();
      print("Tasks loaded: ${userDataList.length} Tasks found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Initial time in the time picker
    );

    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      // ignore: use_build_context_synchronously
      selectEndTime(context);
    }

    update();
  }

  Future<void> selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(), // Initial time in the time picker
    );
    if (picked != null && picked != endSelectedTime) {
      endSelectedTime = picked;
    }
    update();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2027));
    if (picked != null && picked != selectedDate) {
      selectedDate = picked; // Set the selected date
    }
    print("S==" + selectedDate.toString());
    update();
  }

  Future<void> pickMultipleImages() async {
    List<XFile>? selectedImages = [];
    images.clear();
    //while (true) {
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImages.add(pickedFile);
    } else {
      //break; // Break the loop if no image is selected
    }
    // }
    if (selectedImages.isNotEmpty) {
      images.addAll(selectedImages); // Add selected images to the list
    }
    update();
  }

  Future<void> addWorkToFirestore() async {
    checkValidation();
    Future.delayed(const Duration(seconds: 2), () async {
      if (validation == true) {
        // Generate a new document ID
        String docId = FirebaseFirestore
            .instance.collection('tasks').doc().id;

        Map<String, dynamic> data = {
          "id": docId, // Add the document ID as a field
          "title": title.text,
          "user_name": userDataList[0].name,
          "user_phone": userDataList[0].phone,
          "description": description.text,
          "minPrice": minPrice.text,
          "maxPrice": maxPrice.text,
          "date": selectedDate.toString(),
          "time": selectedTime.toString(),
          "user_email": "test@gmail.com",
          "end_time": endSelectedTime.toString(),
          "hasAcceptedProposal": false,
          //"image": images,
        };

        try {
          // Create a reference with the generated document ID
          CollectionReference collection = FirebaseFirestore.instance.collection('tasks');
          await collection.doc(docId).set(data).then((value) {
            appMessage(text: 'تم اضافة مشروعك بنجاح', fail: false);
            Get.offAll(const MainHome());
            title.clear();
            description.clear();
            minPrice.clear();
            maxPrice.clear();
            selectedDate = null;
            selectedTime = null;
            endSelectedTime = null;
            images.clear();
            update();
          });
          print("Data added successfully!");
        } catch (e) {
          print("Error adding data: $e");
        }
      }
    });
  }


  checkValidation() {
    if (title.text.isEmpty) {
      appMessage(text: 'ادخل عنوان المشروع', fail: true);
    } else if (description.text.isEmpty) {
      appMessage(text: 'ادخل وصف المشروع', fail: true);
    } else if (minPrice.text.isEmpty) {
      appMessage(text: 'ادخل اقل كمية المشروع', fail: true);
    } else if (maxPrice.text.isEmpty) {
      appMessage(text: 'ادخل اكبر كمية المشروع', fail: true);
    } else if (selectedTime == null) {
      appMessage(text: 'ادخل وقت تنفيذ المشروع', fail: true);
    } else if (endSelectedTime == null) {
      appMessage(text: 'ادخل وقت  نهائي لتنفيذ المشروع', fail: true);
    } else if (selectedDate == null) {
      appMessage(text: 'ادخل تاريخ تنفيذ المشروع', fail: true);
    } else {
      validation = true;
      update();
    }
  }
}
