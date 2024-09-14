

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:get/get.dart';

class WorkersController extends GetxController{


List<WorkerProvider> workersList = [];


 Future<void> getAllWorkers(String cat) async {

  if(cat=='All'){
 try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('serviceProviders')
      .get();
      workersList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return WorkerProvider.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
       update(); 
      print("Workers loaded: ${workersList.length} ads found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }
  else{
     try {
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('serviceProviders')
      .where('cat',isEqualTo:cat)
      .get();
      // Map each document to an Ad instance and add to adsList
      workersList = querySnapshot.docs.map((DocumentSnapshot doc) {
        // Convert the document data to the Ad model using fromFirestore
        return WorkerProvider.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
       update(); 
      print("Workers loaded: ${workersList.length} ads found.");
    } catch (e) {
      // Handle any errors
      print("Error fetching ads: $e");
    }

  }
   
  }







}