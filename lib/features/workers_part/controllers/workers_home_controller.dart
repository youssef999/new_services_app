

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/features/Home/models/cat.dart';
import 'package:freelancerApp/features/Tasks/models/task.dart';
import 'package:freelancerApp/features/workers_part/views/filter_tasks.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkersHomeController extends GetxController{



  List<Task>tasksList=[];
  List<Cat> catList=[];
List<String>catNamesList=[];
List<bool> checkListValues=[];
String selectedCat='';


  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await launch(url);
     // throw 'Could not launch $url';
    }
  }


 Future<void> getCats() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('cat').get();

      catList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Cat.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();

      for(int i=0;i<catList.length;i++){
        catNamesList.add(catList[i].name);
        checkListValues.add(false);
        update();
      }
      print("Cats loaded: ${catList.length} ads found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }



openFilterDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return GetBuilder<WorkersHomeController>(
        builder: (_) {
          return AlertDialog(
            title: const Text("ابحث عن اعمال عن طريق قسم محدد"
            ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
            //  height: 300, // Adjust the height as needed
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: catList.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(catNamesList[index]),
                    trailing:Checkbox(value: checkListValues[index], onChanged: (value) {
                      changeCatValue(index,value!);
                      print(value);
                    }
                      
                    )
                    
                  );
                },
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("ابحث"),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  Get.to(FilterTaskView(cat: selectedCat));
                },
              ),
            ],
          );
        }
      );
    },
  );
}


changeCatValue(int index,bool val){
  for(int i=0;i<checkListValues.length;i++){
    checkListValues[i]=false;
    update();
  }
  checkListValues[index]=val;
   update();
  if(val){
     selectedCat=catNamesList[index];
  update();
  }else{
    selectedCat='';
  update();
  }
  print("SELECTED CAT: $selectedCat");
 
}


  Future<void> getTaskList() async {

  tasksList=[];
    try {
      print("GET TASKS");
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('tasks')
     // .where('user_email',isEqualTo: 'test@gmail.com')
      .get();
      tasksList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Task.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update();
      print("Tasks loaded: ${tasksList.length} Tasks found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }
 

}