

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freelancerApp/features/workers_part/models/proposal.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class WorkerTasksController extends GetxController{


List<Proposal>proposalList=[];


getWorkerProposal()async{

  print("GET PROPOSALS...............");
  final box=GetStorage();
  String email=box.read('email')??'test3@gmail.com';
  print("EMAIL=="+email);
    try {
      print("GET PROPOSALS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('proposals')
      .where('email',isEqualTo:'test3@gmail.com' )
     // .where('user_email',isEqualTo: 'test@gmail.com')
      .get();
      proposalList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Proposal.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();
      
      print("Tasks loaded: ${proposalList.length} Tasks found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
}


}