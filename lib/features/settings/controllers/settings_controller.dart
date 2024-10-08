import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:freelancerApp/features/settings/models/user.dart' as AppUser;
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class SettingsController extends GetxController {
  List<AppUser.User> userData =
      []; // Use AppUser.User instead of Firebase Auth User

  // Fetch current user data
  Future<void> getUserData() async {
    userData = []; // Clear the list before fetching new data
    try {
      final box = GetStorage();

      // Get the currently logged-in user's email
      String? currentUserEmail = box.read('email');

      if (currentUserEmail != null) {
        log(box.read('roleId'));
        // Query the 'users' collection for the document where 'email' matches the current user's email
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection(
                box.read('roleId') == '0' ? 'users' : 'serviceProviders')
            .where('email', isEqualTo: currentUserEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Map the fetched document(s) to a list of User objects
          userData = querySnapshot.docs.map((doc) {
            return AppUser.User.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          update(); // Notify the listeners that data has been updated
          print("User data loaded: ${userData.length} user(s) found.");
        } else {
          print("No user data found for the current email.");
        }
      } else {
        print("No email found for the current user.");
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching user data: $e");
    }
  }

  Future<void> getWorkerData() async {
    userData = []; // Clear the list before fetching new data
    try {
      final box = GetStorage();

      // Get the currently logged-in user's email
      String? currentUserEmail = box.read('email');

      if (currentUserEmail != null) {
        // Query the 'users' collection for the document where 'email' matches the current user's email
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: currentUserEmail)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          // Map the fetched document(s) to a list of User objects
          userData = querySnapshot.docs.map((doc) {
            return AppUser.User.fromFirestore(
                doc.data() as Map<String, dynamic>, doc.id);
          }).toList();

          update(); // Notify the listeners that data has been updated
          print("User data loaded: ${userData.length} user(s) found.");
        } else {
          print("No user data found for the current email.");
        }
      } else {
        print("No email found for the current user.");
      }
    } catch (e) {
      // Handle any errors
      print("Error fetching user data: $e");
    }
  }

  Future<void> updateUserData({
    required String name,
    required String email,
    required String phone,
    required String image,
  }) async {
    try {
      final userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
      log('userid$userId');
      await FirebaseFirestore.instance.collection('users').doc(userId).update(
          {'name': name, 'email': email, 'phone': phone, 'image': image});
      getUserData();
      // Notify the user of success
      Get.back();
      Get.snackbar('Success', 'User data updated successfully');
    } catch (e) {
      // Handle error and show message
      Get.snackbar('Error', 'Failed to update user data');
      print("Error updating user data: $e");
    }
  }
}
