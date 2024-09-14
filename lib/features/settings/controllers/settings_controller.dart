
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancerApp/features/settings/models/user.dart';
import 'package:get/state_manager.dart';

class SettingsController extends GetxController{


List<User> userData = [];

 Future<void> getUserData() async {
  userData=[];
    try {
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('users')
      .where('email',isEqualTo: 'test@gmail.com')
      .get();
      userData = querySnapshot.docs.map((DocumentSnapshot doc) {
      
        return User.fromFirestore(doc.data() 
        as Map<String, dynamic>, doc.id);
      }).toList();
      update();
      print("Tasks loaded: ${userData.length} Tasks found.");
    } catch (e) {
      // Handle any errors
      print("Error fetching ads: $e");
    }
  }



}