import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/const/app_message.dart';
import 'package:freelancerApp/features/Home/models/cat.dart';
import 'package:freelancerApp/features/Home/models/sub_cat.dart';
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
  TextEditingController address = TextEditingController();
  TextEditingController minPrice = TextEditingController();
  TextEditingController maxPrice = TextEditingController();
  TextEditingController locationDescription = TextEditingController();
  TextEditingController locationLink = TextEditingController();
  TextEditingController locationName = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TimeOfDay? endSelectedTime;
  bool validation = false;
  // String locationName='';
  //
  //
  //
  // changeLocationName(String name){
  //   locationName=name;
  //   update();
  // }
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
      helpText: "selectTime".tr,
      cancelText: 'cancel'.tr,
      confirmText: 'ok'.tr,
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
      helpText: "selectTime".tr,
      cancelText: 'cancel'.tr,
      confirmText: 'ok'.tr,
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
        helpText: "selectDate".tr,
        cancelText: 'cancel'.tr,
        confirmText: 'ok'.tr,
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

  Future<void> addWorkToFirestore(BuildContext context) async {
    uploadMultiImageToFirebaseStorage(images).then((v) {
      Future.delayed(const Duration(seconds: 1), () async {
        final box=GetStorage();
        String city=box.read('address')??'';
        checkValidation(context);
        if (validation == true) {
          // Generate a new document ID
          String docId =
              FirebaseFirestore.instance.collection('tasks').doc().id;
          Map<String, dynamic> data = {
            "id": docId,
            "status": "pending",
            "image": downloadUrls[0],
            "cat": selectedCat,
            'city': city,
            "sub_cat": selectedSubCat,
            "title": title.text,
            "user_name": userDataList[0].name,
            "user_phone": userDataList[0].phone,
            "description": description.text,
            "address": locationName.text,
            "locationLink": locationLink.text,
            "locationDescription": locationDescription.text,
            "minPrice": minPrice.text,
            "maxPrice": maxPrice.text,
            "date": selectedDate.toString(),
            "time": selectedTime.toString(),
            "user_email": userDataList[0].email,
            "end_time": endSelectedTime.toString(),
            "hasAcceptedProposal": false,
            //"image": images,
          };

          try {
            // Create a reference with the generated document ID
            CollectionReference collection =
                FirebaseFirestore.instance.collection('tasks');
            await collection.doc(docId).set(data).then((value) {
              appMessage(
                  text: 'تم اضافة مشروعك بنجاح', fail: false, context: context);
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
    });
  }

  List<String> downloadUrls = [];
  String downloadUrl = '';
  List<Cat> catList = [];
  List<SubCat> subCatList = [];
  List<String> catListNames = [];
  List<String> subCatListNames = [];
  String selectedCat = 'خدمات الصيانة';
  String selectedSubCat = 'فني طابعات و احبار';

  Future uploadMultiImageToFirebaseStorage(List<XFile> images) async {
    print("UPLOAD IMAGES....");
    print("UPLOAD IMAGES======" + images.length.toString());
    for (int i = 0; i < images.length; i++) {
      print("HERE==" + i.toString());
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference =
            FirebaseStorage.instance.ref().child('images2024/$fileName');
        UploadTask uploadTask = reference.putFile(File(images[i].path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        downloadUrl = await taskSnapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      } catch (e) {
        // Handle any errors that occur during the upload process
        // ignore: avoid_print
        print('Error uploading image to Firebase Storage: $e');
      }
      print("DOWNLOAD URLS====" + downloadUrls.length.toString());
      print("DOWNLOAD URLS====" + downloadUrls.toString());
    }
    return downloadUrls;
  }

  Future<void> getCats() async {
    catList = [];
    catListNames = [];
    print("HERE CATS......");
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('cat').get();
      catList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Cat.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      for (int i = 0; i < catList.length; i++) {
        catListNames.add(catList[i].name);
      }
      selectedCat = catList[0].name;
      update();
      print("Cats loaded: ${catList.length}.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

  Future<void> getSubCats(String cat) async {
    subCatList = [];
    subCatListNames = [];
    print("HERE CATS......");
    try {
      if (cat.length > 1) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('sub_cat')
            .where('cat', isEqualTo: cat)
            .get();
        subCatList = querySnapshot.docs.map((DocumentSnapshot doc) {
          return SubCat.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      } else {
        QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('sub_cat').get();
        subCatList = querySnapshot.docs.map((DocumentSnapshot doc) {
          return SubCat.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
      }

      print("Subcat==XXX=" + subCatList.length.toString());
      for (int i = 0; i < subCatList.length; i++) {
        subCatListNames.add(subCatList[i].name);
      }
      selectedSubCat = subCatListNames[0];
      update();
      print("sub Cat loaded: ${catList.length}.");
      print("sub Cat loaded: ${subCatListNames}.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

  changeCatValue(String cat) {
    selectedCat = cat;
    update();
    getSubCats(cat);
  }

  checkValidation(BuildContext context) {
    if (title.text.isEmpty) {
      appMessage(text: 'ادخل عنوان المشروع', fail: true, context: context);
    } else if (description.text.isEmpty) {
      appMessage(text: 'ادخل وصف المشروع', fail: true, context: context);
    } else if (minPrice.text.isEmpty) {
      appMessage(text: 'ادخل اقل كمية المشروع', fail: true, context: context);
    } else if (maxPrice.text.isEmpty) {
      appMessage(text: 'ادخل اكبر كمية المشروع', fail: true, context: context);
    } else if (selectedTime == null) {
      appMessage(text: 'ادخل وقت تنفيذ المشروع', fail: true, context: context);
    } else if (endSelectedTime == null) {
      appMessage(
          text: 'ادخل وقت  نهائي لتنفيذ المشروع',
          fail: true,
          context: context);
    } else if (selectedDate == null) {
      appMessage(
          text: 'ادخل تاريخ تنفيذ المشروع', fail: true, context: context);
    } else if (locationName.text.isEmpty) {
      appMessage(text: 'ادخل عنوان الموقع', fail: true, context: context);
    } else if (locationDescription.text.isEmpty) {
      appMessage(text: 'ادخل وصف الموقع', fail: true, context: context);
    } else {
      validation = true;
      update();
    }
  }
}
