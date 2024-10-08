// ignore_for_file: unused_local_variable, avoid_print, duplicate_ignore, unused_field, unused_element

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/core/widgets/Custom_Text.dart';
import 'package:freelancerApp/core/widgets/custom_loading.dart';
import 'package:freelancerApp/features/Home/views/main_view.dart';
import 'package:freelancerApp/features/Home/views/select_country.dart';
import 'package:freelancerApp/features/auth/views/register_view2.dart';
import 'package:freelancerApp/routes/app_routes.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import '../../../../Core/const/app_message.dart';
import '../../Home/models/cat.dart';
import '../views/verfied_email.dart';

class AuthController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController checkPassController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController roleId = TextEditingController();
  TextEditingController empCatController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  String workerAddress = 'x';

  final box = GetStorage();

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

  changeWorkerAddress(String newAddress) {
    workerAddress = newAddress;
    update();
  }

  Location location = Location();
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;

  Future<void> getLocationPermission() async {
    _permissionGranted = await location.requestPermission();
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
  final List<String> addressNames = [];

  String selectedItem = 'خدمات الكمبيوتر';

  List<String> countryList = ['مصر', 'الكويت', 'السعودية'];

  List<String> countryImageList = [
    AppAssets.egyptImage,
    AppAssets.kwtImage,
    AppAssets.suadiImage,
  ];

  String selectedCountry = 'مصر';

  String selectedCity = 'القاهرة';

  String selectedAddress = 'مصر الجديدة';

  changeCountry(String country) {
    selectedCountry = country;
    // box.write('country', country);
    update();
    print("COUNTRY====$country");
    getCities(country);
  }

  changeAddress(String address) {
    selectedAddress = address;
    // box.write('country', country);
    update();
    print("ADDRESS====$address");
    getAddress(selectedCity);
  }

  getAddress(String city) async {
    addressNames.clear();
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('locations')
        .where('city', isEqualTo: city)
        .get();
    try {
      List<Map<String, dynamic>> data = querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();
      for (int i = 0; i < data.length; i++) {
        addressNames.add(data[i]['name']);
      }
      selectedAddress = data[0]['name'];
    } catch (e) {
      print("E....cc...");
      print(e);
      print("E...xx....");
    }
    print("address====$addressNames");
    update();
  }

  getCities(String country) async {
    print("cc=xx==$country");

    cityNames.clear();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('city')
        .where('country', isEqualTo: country)
        .get();

    try {
      List<Map<String, dynamic>> data = querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();

      for (int i = 0; i < data.length; i++) {
        cityNames.add(data[i]['city']);
      }
      selectedCity = data[0]['city'];
    } catch (e) {
      print("E....cc...");
      print(e);
      print("E...xx....");
    }
    print("CITY====$cityNames");
    getAddress(selectedCity);
    update();
  }

  changeSelectedCity(String city) {
    selectedCity = city;
    update();
    getAddress(selectedCity);
  }

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
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();
    // Get the device token
    token = (await firebaseMessaging.getToken())!;
  }

  addTokenToFirebase() async {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)*&1!';
    Random random = Random();
    String result = '';

    for (int i = 0; i < 12; i++) {
      result += chars[random.nextInt(chars.length)];
    }

    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission();

    // Get the device token
    String? token = await firebaseMessaging.getToken();
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

  changePassword(BuildContext context) async {
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
          text: 'كلمة المرور غير متطابقة او عددها اقل من 6 ',
          fail: true,
          context: context);
    }
  }

  Future<void> resetPassword(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text)
          .then((value) {
        appMessage(
            text: "تم ارسال رسالة لتغيير كلمة المرور",
            fail: true,
            context: context);

        Get.offNamed(Routes.LOGIN)!.then((value) =>
            appMessage(text: "checkMail".tr, fail: false, context: context));
      });
      // Password reset email sent successfully
    } catch (e) {
      appMessage(text: 'ادخل بريد سليم ', fail: false, context: context);
      // Handle any errors that occur during the password reset process
      // ignore: avoid_print
      print('Error sending password reset email: $e');
    }
  }

  Future<void> loginWithPhone(BuildContext context) async {
    // VerificationCompleted callback, auto-sign in on certain devices
    verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
      Get.snackbar('تمت بنجاح', 'تم تسجيل دخولك بنجاح',
          backgroundColor: Colors.green, colorText: Colors.white);
    }

    // VerificationFailed callback, if the verification failed
    verificationFailed(FirebaseAuthException e) {
      Get.snackbar('Error', e.message ?? 'Phone verification failed',
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    // CodeSent callback, when the code is sent to the phone number
    codeSent(String verificationId, int? resendToken) async {
      String smsCode = ''; // Enter SMS code from user

      // Show dialog to enter OTP
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('رمز OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  smsCode = value; // Update the entered OTP
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // Create a PhoneAuthCredential with the code
                PhoneAuthCredential credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: smsCode,
                );
                // Sign the user in with the credential
                await _auth.signInWithCredential(credential).then((value) {
                  Get.snackbar('Success', 'Logged in successfully!',
                      backgroundColor: Colors.green, colorText: Colors.white);
                  Navigator.of(context).pop(); // Close dialog
                }).catchError((e) {
                  Get.snackbar('Error', 'Failed to login',
                      backgroundColor: Colors.red, colorText: Colors.white);
                });
              },
              child: const Text('Verify'),
            ),
          ],
        ),
      );
    }

    // CodeAutoRetrievalTimeout callback, for timeouts
    codeAutoRetrievalTimeout(String verificationId) {
      Get.snackbar('Timeout', 'OTP auto retrieval timeout',
          backgroundColor: Colors.red, colorText: Colors.white);
    }

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneController.text,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('Code sent');
          // You can store the verificationId for later use
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('Timeout');
        },
        timeout: const Duration(seconds: 60),

        forceResendingToken: 0,

        // Force reCAPTCHA if needed
        // Forces reCAPTCHA flow
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to verify phone number',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  List<Map<String, dynamic>> users = [];
  List<String> usersEmails = [];

  void getAllUsers(String type) async {
    print("TYPE==" + type);
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection(type).get();

      List<Map<String, dynamic>> data = querySnapshot.docs
          .map((DocumentSnapshot doc) => doc.data() as Map<String, dynamic>)
          .toList();

      users = data;

      print('USERS===' + users.toString());
      print('USERS===' + data.toString());
    } catch (error) {
      // ignore: avoid_print
      print("Error fetching data: $error");
    }
    addUsersMails();
  }

  addUsersMails() {
    for (int i = 0; i < users.length; i++) {
      usersEmails.add(users[i]['email']);
    }
  }

  tryToLogin(BuildContext context, String roleId) async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credintional = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken, idToken: gAuth.idToken);
    return await FirebaseAuth.instance
        .signInWithCredential(credintional)
        .then((value) {
      print("Sign in done");
      appMessage(text: 'Done', fail: false, context: context);
      final box = GetStorage();

      print("MAILS==" + usersEmails.toString());
      if (usersEmails.contains(value.user!.email)) {
        box.write('email', value.user!.email.toString());
        print("HERE main home");
        Get.offAll(const MainHome());
      } else {
        box.write('email', value.user!.email.toString());
        print("HERE sign up");
        Get.offAll(SignupView(
          roleId: roleId,
          email: value.user!.email.toString(),
        ));
      }
    }).catchError((e) {
      print("ERROR===" + e);
      Get.snackbar('error'.tr, e.toString(),
          duration: const Duration(seconds: 10));
    });
  }

  userLogin(String roleId, BuildContext context) async {
    print("role ... id .. ===" + roleId);
    isLoading = true;
    update();
    Future.delayed(const Duration(seconds: 1)).then((value) async {
      if (emailController.text.length > 2 && passController.text.length > 5) {
        try {
          final cred = await _auth.signInWithEmailAndPassword(
              email: emailController.text, password: passController.text);
          Future.delayed(const Duration(seconds: 1)).then((value) {
            print("........................DONE.......................");
            box.write('email', emailController.text);
            box.write('roleId', roleId);
            loading = false;
            CustomLoading.cancelLoading();
            update();
            if (roleId == '0') {
              Get.offAll(const SelectCountryView());
            } else {
              Get.offAll(const MainHome());
            }

            appMessage(
                text: 'تم التسجيل بنجاح ', fail: false, context: context);
          }).catchError((error) {
            CustomLoading.cancelLoading();
            appMessage(
                text: 'خطا في تسجيل الدخول', fail: true, context: context);
          });
        } catch (e) {
          CustomLoading.cancelLoading();
          loading = false;
          update();
          String error = '';
          print("E====$e");
          if (e.toString().contains(
              'The supplied auth credential is incorrect, malformed or has expired.')) {
            error = 'wrongData'.tr;
            appMessage(text: error, fail: true, context: context);
          } else if (e.toString().contains(
              'The supplied auth credential is incorrect, malformed or has expired.')) {
            error = 'wrongMail'.tr;
            appMessage(text: error, fail: true, context: context);
          } else {
            error = 'wrongData'.tr;
            appMessage(text: error, fail: true, context: context);
          }
        }
      } else {
        // CustomLoading.cancelLoading();
        if (emailController.text.contains('@') == false) {
          appMessage(text: 'wrongMail'.tr, fail: false, context: context);
        }
        if (passController.text.length < 5) {
          appMessage(text: 'wrongPass'.tr, fail: false, context: context);
        }
      }
      isLoading = false;
      update();
    });
  }

  register(String roleId, String email, String password, String phone,
      BuildContext context, bool isGoogle) async {
    final box = GetStorage();
    box.write('roleId', roleId);
    if (isGoogle == true) {
      if (roleId == '0') {
        addNewUser(phone, context);
      } else {
        addNewWorker(context);
      }
      box.write('email', emailController.text);
      appMessage(text: 'تم التسجيل بنجاح', fail: false, context: context);
    } else {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((user) async {
          if (roleId == '0') {
            addNewUser(phone, context);
          } else {
            addNewWorker(context);
          }
          box.write('email', emailController.text);
          appMessage(text: 'تم التسجيل بنجاح', fail: false, context: context);
        });
      } catch (e) {
        print("EEE==" + e.toString());
        if (e.toString().contains(
            'The email address is already in use by another account.')) {
          appMessage(
              text: 'البريد الالكتروني مستخدم من قبل',
              fail: false,
              context: context);
        }
      }
    }
  }

  sendEmailVerfication() async {
    FirebaseAuth.instance.currentUser!.sendEmailVerification();
    print("SENT....");
  }

  List<Cat> catList = [];
  List<String> catListNames = [];

  Future<void> getCats() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('cat').get();

      catList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Cat.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();

      for (int i = 0; i < catList.length; i++) {
        catListNames.add(catList[i].name);
        update();
      }
      print("Cats loaded: ${catList.length} ads found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

  Future<void> saveUserToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'fcmToken': token,
      });
    }
  }

  addNewUser(String phone, BuildContext context) async {
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
        'phone': phone,
        'id': result,
        'image': ''
      }).then((value) {
        saveUserToken(result);
        update();
        // ignore: avoid_print
        print("DONE");
        appMessage(text: 'welcome'.tr, fail: false, context: context);
        box.write('email', emailController.text);
        box.write('name', nameController.text);
        box.write('roleId', '0');
        Get.offAll(const MainHome());
      });
    } catch (e) {
      update();
      print(e);
      appMessage(text: "error".tr, fail: true, context: context);
    }
  }

  Future<void> saveWorkerToken(String userId) async {
    final token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      await FirebaseFirestore.instance
          .collection('serviceProviders')
          .doc(userId)
          .update({
        'fcmToken': token,
      });
    }
  }

  addNewWorker(BuildContext context) async {
    // add address or cities
    addNewAddress();

    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)*&1!';
    Random random = Random();
    String result = '';
    final box = GetStorage();
    String lat = box.read('lat').toString();
    String lng = box.read('lng').toString();

    for (int i = 0; i < 12; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    try {
      await FirebaseFirestore.instance
          .collection('serviceProviders')
          .doc(result)
          .set({
        'name': nameController.text,
        'email': emailController.text,
        'cat': selectedItem,
        'details': detailsController.text,
        'price': priceController.text,
        'id': result,
        "lat": lat,
        "lng": lng,
        'image': imageLink,
        'rating': 0,
        'country': countryController.text,
        'city': cityController.text,
        'address': addressController.text,
        'ratingCount': 0
      }).then((value) {
        update();
        print("DONE");
        appMessage(text: 'welcome'.tr, fail: false, context: context);
        box.write('email', emailController.text);
        box.write('name', nameController.text);
        Get.offAll(const MainHome());
      });
    } catch (e) {
      update();
      print(e);
      appMessage(text: "error".tr, fail: true, context: context);
    }
  }

  addNewAddress() async {
    const String chars =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789)*&1!';
    Random random = Random();
    String result = '';
    final box = GetStorage();
    for (int i = 0; i < 12; i++) {
      result += chars[random.nextInt(chars.length)];
    }
    await FirebaseFirestore.instance.collection('adresses').doc(result).set(
        {'name': addressController.text, "country": countryController.text});
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
