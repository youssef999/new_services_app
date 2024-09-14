// ignore_for_file: unused_local_variable, avoid_print, duplicate_ignore, unused_field, unused_element

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/core/widgets/custom_loading.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:freelancerApp/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../../../../Core/const/app_message.dart';
import '../../Home/models/cat.dart';
import '../views/verfied_email.dart';

class AuthController extends GetxController {
  
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController checkPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController roleId = TextEditingController();
  TextEditingController empCatController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  TextEditingController detailsController=TextEditingController();



  bool loading = false;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Rx<int> isSelected = 1.obs;
  int regRoleId = 1;
  GlobalKey<FormState>? loginFormKey;
  changeRoleId(int val) {
    regRoleId = val;
    update();
  }

  Location location = Location();
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;



  Future<void> getLocationPermission() async {
    _permissionGranted =
    await location.requestPermission();
    print("PER====" + _permissionGranted.toString());
    if (_permissionGranted == PermissionStatus.granted) {
      await location.requestPermission();
      print("Done");
    }
  }

 
  User? user = FirebaseAuth.instance.currentUser;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Map<String, dynamic>> categoryList = [];
  final List<String> catNames = [];
  final List<String> countryNames = [];
  final List<String> cityNames = [];


  

  String selectedItem = 'تنظيف';

 

  XFile? pickedImageXFile;

  final ImagePicker _picker = ImagePicker();

  var imageLink = '';

  String downloadUrl = '';

  String profileUrl = '';

  String idUrl = '';

  String downloadUrl2 = '';

  List<String> downloadUrls = [];

  List<String> profileDownloadUrl = [];

  List<XFile>? idUrlList;

  List<XFile>? pickedImageXFiles;

  List<XFile>? profilePickedFiles;

  bool isImage = false;

  bool isLoading = false;

  final box = GetStorage();

  changeCatValue(String val) {
    selectedItem = val;
    update();
  }

  captureImage() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);
    Get.back();
    //pickedImageXFile;
    update();
  }

  pickImage() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);
    Get.back();
    update();
    //   uploadImageToFirebaseStorage(pickedImageXFile!);
  }

  pickMultiImage() async {
    pickedImageXFiles = await _picker.pickMultiImage(
      imageQuality: 100,
    );
    isImage = true;
    update();
  }

  pickProfileImage() async {
    profilePickedFiles = await _picker.pickMultiImage(
      imageQuality: 100,
    );
    isImage = true;
    update();
  }

  pickIdImage() async {
    idUrlList = await _picker.pickMultiImage(
      imageQuality: 100,
    );
    isImage = true;
    update();
  }




 



  String token = '';

  getDeviceToken() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission();
    // Get the device token
    token = (await _firebaseMessaging.getToken())!;
  }

  addTokenToFirebase() async {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)*&1!';
    Random random = Random();
    String result = '';

    for (int i = 0; i < 12; i++) {
      result += chars[random.nextInt(chars.length)];
    }

    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    await _firebaseMessaging.requestPermission();

    // Get the device token
    String? token = await _firebaseMessaging.getToken();
    await FirebaseFirestore.instance.collection('tokens').doc(result).set({
      'token': token!,
    }).then((value) {
      print("DONE ADD TOKEN");
    });
  }

  String enCat = '';

  getCatInEnglish(String cat) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cat')
        .where('nameAr', isEqualTo: cat)
        .get();
    try {
      List<Map<String, dynamic>> data = querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();

      enCat = data[0]['name'];
    } catch (e) {
      // ignore: avoid_print
      print("E.......");
      // ignore: avoid_print
      print(e);
      // orderState='error';
      // ignore: avoid_print
      print("E.......");
    }
    update();
  }

  changePassword() async {
    if (passController.text == checkPassController.text &&
        passController.text.length > 5) {
      try {
        await user!.updatePassword(passController.text.toString());
      } catch (e) {
        // ignore: avoid_print
        print(e);
      }
    } else {
      appMessage(
          text: 'كلمة المرور غير متطابقة او عددها اقل من 6 ', fail: true);
    }
  }

  Future<void> resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text)
          .then((value) {
        appMessage(text: "تم ارسال رسالة لتغيير كلمة المرور", fail: true);

        Get.offNamed(Routes.LOGIN)!
            .then((value) => appMessage(text: "checkMail".tr, fail: false));
      });
      // Password reset email sent successfully
    } catch (e) {
      appMessage(text: 'ادخل بريد سليم ', fail: false);
      // Handle any errors that occur during the password reset process
      // ignore: avoid_print
      print('Error sending password reset email: $e');
    }
  }


  


  userLogin(String roleId) async {
    isLoading=true;
    update();
    if (emailController.text.length > 2
        && passController.text.length > 5) {
      try {
        final cred = await _auth.signInWithEmailAndPassword(
            email:
            emailController.text,
            password: passController.text);
        Future.delayed(const Duration(seconds: 1)).then((value) {
            print("DONE");
            box.write('email', emailController.text);
            box.write('roleId',roleId);
            loading = false;
            CustomLoading.cancelLoading();
            update();
            Get.offAll(const MainHome());
         // print('Received data: $value');
        }).catchError((error) {
  CustomLoading.cancelLoading();
           appMessage(text: 'خطا في تسجيل الدخول', fail: true);
        });
      } catch (e) {
        CustomLoading.cancelLoading();
        loading = false;
        update();
        String error = '';
        print("E====$e");
        if (e.toString()
            .contains('The supplied auth credential is incorrect, malformed or has expired.')) {
         error = 'wrongData'.tr;
          appMessage(text: error, fail: true);
          
        } else if (e.toString().contains('The supplied auth credential is incorrect, malformed or has expired.')) {
          error = 'wrongMail'.tr;
           appMessage(text: error, fail: true);
        } else {
          error = 'wrongData'.tr;
           appMessage(text: error, fail: true);
        }
      }
    } else {
     // CustomLoading.cancelLoading();
      if (emailController.text.contains('@') == false) {
        appMessage(text: 'wrongMail'.tr, fail: false);
      }
      if (passController.text.length < 5) {
        appMessage(text: 'wrongPass'.tr, fail: false);
      }
    }
    isLoading=false;
    update();
  }


 register(String roleId)async{
 final box=GetStorage();
    try{
 await _auth
          .createUserWithEmailAndPassword(
        email: 'test3@gmail.com',
        //emailController.text,
        password: '123456'
        //passController.text,
      ).then((user) async {

        if(roleId=='0'){
 
           addNewUser();
        
        }
        
        else{

          addNewWorker();

        }
        
    box.write('email', emailController.text);
    appMessage(text: 'تم التسجيل بنجاح', fail: false);
    Get.offAll( const MainHome());
      });
    }catch(e){
        print("EEE=="+e.toString());
    }
  }

  sendEmailVerfication() async {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    print("SENT....");
  }

 List<Cat>catList=[];
 List<String>catListNames=[];


  Future<void> getCats() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('cat').get();

      catList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Cat.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();

      for(int i=0;i<catList.length;i++){
        catListNames.add(catList[i].name);
         update();
      }
      print("Cats loaded: ${catList.length} ads found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  
}

  addNewUser() async {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)*&1!';
    Random random = Random();
    String result = '';
    final box = GetStorage();
    for (int i = 0; i < 12; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    try {
      await FirebaseFirestore.instance.collection('users').doc(result).set({
        'name': nameController.text,
        'email': emailController.text,
        'id': result,
        'image':''
      }).then((value) {
        update();
        // ignore: avoid_print
        print("DONE");
        appMessage(text: 'welcome'.tr, fail: false);
        box.write('email', emailController.text);
        box.write('name', nameController.text);
         box.write('roleId','0');
      });
    } catch (e) {
      update();
      print(e);
      appMessage(text: "error".tr, fail: true);
    }
  }

   addNewWorker() async {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)*&1!';
    Random random = Random();
    String result = '';
    final box = GetStorage();
    for (int i = 0; i < 12; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    try {
      await FirebaseFirestore.instance.collection('serviceProviders').doc(result).set({
        'name': nameController.text,
        'email': emailController.text,
        'cat':'',
        'details':"",
        'price':"",
        'id': result,
        "lat":"",
        "lng":"",
        'image':''
      }).then((value) {
        update();
        print("DONE");
        appMessage(text: 'welcome'.tr, fail: false);
        box.write('email', emailController.text);
        box.write('name', nameController.text);
        box.write('roleId','1');
      });
    } catch (e) {
      update();
      print(e);
      appMessage(text: "error".tr, fail: true);
    }
  }


  Future uploadProfileImageToFirebaseStorage(List<XFile> images) async {
    for (int i = 0; i < images.length; i++) {
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference reference =
            FirebaseStorage.instance.ref().child('profile/$fileName');
        UploadTask uploadTask = reference.putFile(File(images[i].path));
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
        profileUrl = await taskSnapshot.ref.getDownloadURL();
        profileDownloadUrl.add(profileUrl);
      } catch (e) {
        // Handle any errors that occur during the upload process
        // ignore: avoid_print
        print('Error uploading image to Firebase Storage: $e');
      }
    }
    return profileDownloadUrl;
  }

  Future uploadMultiImageToFirebaseStorage(List<XFile> images) async {
    for (int i = 0; i < images.length; i++) {
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
    }
    return downloadUrls;
  }
}
