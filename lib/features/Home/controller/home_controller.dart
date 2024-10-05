

 import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/resources/app_assets.dart';
import 'package:freelancerApp/features/Home/models/ad.dart';
import 'package:freelancerApp/features/Home/models/address.dart';
import 'package:freelancerApp/features/Home/models/sub_cat.dart';
import 'package:freelancerApp/features/Home/views/worker_address.dart';
import 'package:freelancerApp/features/workers/models/workers.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/cat.dart';

class HomeController extends GetxController {

  List<Ad>adsList = [];
  List<Cat>catList = [];
  List<SubCat>subCatList = [];
  List<String>countryList = [
    'مصر','الكويت','السعودية'
  ];
  List<String>countryImageList = [

    AppAssets.egyptImage,
    AppAssets.kwtImage,
    AppAssets.suadiImage,
  ];

  String selectedCountry='مصر';

  final box=GetStorage();
  changeCountry(String country){
    selectedCountry=country;
    box.write('country', country);
    update();
  }

List<WorkerProvider> workersList = [];
List<WorkerProvider> workersAddressList = [];
  double userCurrentLat=0.0;
  double userCurrentLng=0.0;


  Future<void> getAllWorkersWithAddress(String address) async {

    print("ADDDDDD");
    print("ADDDDD=="+address);
    try {
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.
      collection('serviceProviders')
          .where('address',isEqualTo:address)
          .get();
      // Map each document to an Ad instance and add to adsList
      workersAddressList =
          querySnapshot.docs.map((DocumentSnapshot doc) {
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




Future<Position?> getCurrentLocation() async {
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      print('Location permissions are denied');
      return null;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    print('Location permissions are permanently denied');
    return null;
  }

  // Check if location services are enabled
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!isLocationServiceEnabled) {
    print('Location services are disabled');
    return null;
  }

  try {
    // Get current position
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    print('Current position: ${position.latitude}, ${position.longitude}');
      userCurrentLat=position.latitude;
     userCurrentLng=position.longitude;
     update();
    // getAllWorkers(userCurrentLat, userCurrentLng);
    return position;
  } catch (e) {
    print('Error getting location: $e');
    return null;
  }
}

void getUserLocation() async {
  print("GET USER LOCATION");
  requestLocationPermission();  
  Position? position = await getCurrentLocation();
  if (position != null) {
    print('Latitude: ${position.latitude}, Longitude: ${position.longitude}');
  } else {
    print('Failed to get location');
  }
}

List<Address>addressList=[];
List<String>addressName=[];
List<bool> checkListValues=[];


  changeAddressValue(int index,bool val){
    for(int i=0;i<checkListValues.length;i++){
      checkListValues[i]=false;
      update();
    }
    checkListValues[index]=val;
    update();
    if(val){
      selectedCountry=addressName[index];
      update();
    }else{
      selectedCountry='';
      update();
    }
    print("SELECTED CAT: $selectedCountry");

  }



  openFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return GetBuilder<HomeController>(
            builder: (_) {
              return AlertDialog(
                title: const Text("ابحث عن اعمال عن طريق المناطق"
                  ,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  //  height: 300, // Adjust the height as needed
                  width: double.maxFinite,
                  child:
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: addressName.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                          title: Text(addressName[index]),
                          trailing:
                          Checkbox(value: checkListValues[index],
                              onChanged: (value) {
                                changeAddressValue(index,value!);
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
                      Get.to(WorkersAddressView(
                        address: selectedCountry
                      ));
                      // Close the dialog
                   //   Get.to(FilterTaskView(cat: selectedCat));
                    },
                  ),
                ],
              );
            }
        );
      },
    );
  }



getAllAddress() async {
  // final box=GetStorage();
  // String country=box.read('country')??'';
addressName.clear();
  try {
    // Reference to the Firestore collection
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('adresses')
        //.where('country',isEqualTo: country) // Replace with your collection name
        .get();
    for (var doc in querySnapshot.docs) {
      if (doc['name'] != null) {
        addressName.add(doc['name']);
        checkListValues.add(false);
        update();
      }
    }
  } catch (e) {
    print("Error fetching addresses: $e");
    return [];
  }
  update();

}


Future<void> requestLocationPermission() async {
  var status = await Permission.locationWhenInUse.status;
  if (!status.isGranted) {
    await Permission.locationWhenInUse.request();
  }
}


double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371; // Radius of the Earth in km
  double dLat = _deg2rad(lat2 - lat1);
  double dLon = _deg2rad(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
          sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = R * c; // Distance in km
  return distance;
}

/// Function to convert degrees to radians
double _deg2rad(double deg) {
  return deg * (pi / 180);
}


  Future<void> getAds() async {
    try {
      // Fetch all documents from the 'ads' collection
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('ads').get();

      // Map each document to an Ad instance and add to adsList
      adsList = querySnapshot.docs.map((DocumentSnapshot doc) {
        // Convert the document data to the Ad model using fromFirestore
        return Ad.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      update(); // Call update() if using a state management solution like GetX
      // Optional: Print the list for debugging
      print("Ads loaded: ${adsList.length} ads found.");
    } catch (e) {
      // Handle any errors
      print("Error fetching ads: $e");
    }
  }


List<WorkerProvider> workersSubCatList=[];

 Future<void> getWorkersWithCats({required String cat
 ,required String subCat}) async {
    print("HERE CATS......");
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance
      .collection('serviceProviders').get();
      workersSubCatList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return WorkerProvider
        .fromFirestore(doc.data()
         as Map<String, dynamic>, doc.id);

      }).toList();
      update();
      print("workers loaded: ${workersSubCatList.length}.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }
  Future<void> getCats() async {
    print("HERE CATS......");
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('cat').get();
      catList = querySnapshot.docs.map((DocumentSnapshot doc) {
        return Cat.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);

      }).toList();
      update();
      print("Cats loaded: ${catList.length}.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }

    Future<void> getSubCats() async {
    List<SubCat>data=[];
    subCatList=[];
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('sub_cat')
     // .where('cat',isEqualTo:cat)
      .get();
      data = querySnapshot.docs.map((DocumentSnapshot doc) {
        return SubCat.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
      subCatList.addAll(data);
      update();
      print("SUB Cats loaded: ${subCatList.length} ads found.");
    } catch (e) {
      print("Error fetching ads: $e");
    }
  }
 // List<WorkerProvider> workersList = [];

  List<WorkerProvider> workersCatList=[];



    Future<void> getWorkersWithSubCat
        (String subCat,String cat) async {

      workersSubCatList=[];
     print("subCAT==="+subCat);
     print("cat=="+cat);
   
      List<WorkerProvider>data=[];
      try {
        // Fetch all documents from the 'ads' collection
        QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
        .collection('serviceProviders')
        .where('cat',isEqualTo: cat)
          .where('sub_cat',isEqualTo:subCat)
            .get();
        // Map each document to an Ad instance and add to adsList
       data= querySnapshot.docs.map((DocumentSnapshot doc) {
          // Convert the document data to the Ad model using fromFirestore
          return WorkerProvider.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();

        workersSubCatList.addAll(data);

        update();
        
        print("Worker Sub Cat ${workersSubCatList.length} .");
      }
       catch (e) {
        print("Error fetching ads: $e");
    }
  }



  Future<void> getAllWorkers(String cat) async {

     print("CAT==="+cat);
   // workersList=[];
    if(cat=='All'){
      try {
        QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance
            .collection('serviceProviders')
            .get();
        workersList = querySnapshot.docs.map((DocumentSnapshot doc) {
          return WorkerProvider
              .fromFirestore(doc.data() as
          Map<String, dynamic>, doc.id);
        }).toList();
        update();
        print("Workers loaded: ${workersList.length} ads found.");
      } catch (e) {
        print("Error fetching ads: $e");
      }
      update();
    }
    else{
      try {
        // Fetch all documents from the 'ads' collection
        QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('serviceProviders')
            .where('cat',isEqualTo:cat)
            .get();
        // Map each document to an Ad instance and add to adsList
       workersCatList= querySnapshot.docs.map((DocumentSnapshot doc) {
          // Convert the document data to the Ad model using fromFirestore
          return WorkerProvider.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
        }).toList();
        update();
        print("Workers loaded: ${workersList.length} ads found.");
      } catch (e) {
        // Handle any errors
        print("Error fetching ads: $e");
      }
      update();

    }

  }



}



