import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:freelancerApp/features/settings/models/user.dart' as AppUser;
import 'package:get/get.dart';

class SettingsController extends GetxController {
  List<AppUser.User> userData =
      []; // Use AppUser.User instead of Firebase Auth User

  // Fetch current user data
  Future<void> getUserData() async {
    userData = []; // Clear the list before fetching new data
    try {
      // Get the currently logged-in user
      firebase_auth.User? currentUser =
          firebase_auth.FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Fetch the document for the current user from the 'users' collection using the user ID
        DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid) // Use the user ID directly
            .get();

        if (docSnapshot.exists) {
          // Map the fetched document to a User object
          AppUser.User user = AppUser.User.fromFirestore(
              docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
          userData = [user]; // Update userData with the fetched user
          update(); // Notify the listeners that data has been updated
          print("User data loaded: ${userData.length} user found.");
        } else {
          print("No user data found for the current user.");
        }
      } else {
        print("No user is currently logged in.");
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
