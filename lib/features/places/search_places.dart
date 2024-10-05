
import 'package:freelancerApp/features/Work/controllers/work_controller.dart';
import 'package:freelancerApp/features/places/map_view.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/widgets/Custom_button.dart';
import '../../../Core/resources/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../core/const/app_message.dart';
import 'controllers/map_controller.dart';
import 'predict_places.dart';



class SearchPlacesView extends StatefulWidget
{
  const SearchPlacesView({super.key});
  @override
  // ignore: library_private_types_in_public_api
  _SearchPlacesScreenState createState() => _SearchPlacesScreenState();
}

TextEditingController searchController=TextEditingController();

class _SearchPlacesScreenState extends State<SearchPlacesView>
{

  List<PredictedPlaces> placesPredictedList = [];

  MapController controller=Get.put(MapController());
  WorkController workController=Get.put(WorkController());

  String mapKey='AIzaSyDA-D-AYyDPASQgA2p98xxzZHXMusGcblk';

  //String apiKey = 'AIzaSyDA-D-AYyDPASQgA2p98xxzZHXMusGcblk';
  // 'AIzaSyCZWK37oQYE_tpFWyvry_RAdN5wV7L32uQ';
  // 'AIzaSyCKckCh7RP4ezDtY4F2m5CEV0Y8tfntDFk';
//'AIzaSyCdLsB9Sjir6fW0ZjJ1mksJvxMrRIZR7d4';

  @override
  void dispose() {
    searchController.text='';
    super.dispose();

  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: CustomAppBar('enterPlace'.tr, context),
      bottomNavigationBar:Padding(
        padding: const EdgeInsets.only(left: 28.0,right: 28,top: 10,bottom: 20),
        child: CustomButton(
            text: 'next'.tr,
            onPressed: (){
              if(searchController.text.length>2){
                Get.off(const MapViewSelect());
                final box = GetStorage();
                box.write('locationName',searchController.text);
                workController.changeLocationName(searchController.text);
              }
              else{
                appMessage(text: 'enterPlace'.tr, fail: true,
                context: context
                );
              }
              // Get.toNamed('/AddSeller');
            },
            color1:AppColors.primary,
            color2:   AppColors.secondaryTextColor
        ),
      ),
      body: GetBuilder<MapController>(
          builder: (context) {
            return Column(
              children: [
                const SizedBox(height: 22,),
                //search place ui
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [

                          Row(
                            children: [
                              Icon(
                                  Icons.adjust_sharp,
                                  color: AppColors.primary
                              ),

                              const SizedBox(width: 18.0,),


                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  decoration:BoxDecoration(
                                      borderRadius:BorderRadius.circular(12)
                                  ),
                                  width: 290,
                                  child: TextField(
                                    controller: searchController,

                                    onChanged: (valueTyped)
                                    {

                                      findPlaceAutoCompleteSearch(valueTyped);
                                    },
                                    decoration:   InputDecoration(
                                      hintText: "search".tr,
                                      filled: true,
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.only(
                                        left: 11.0,
                                        top: 8.0,
                                        bottom: 8.0,
                                      ),
                                      fillColor: Colors.white70,
                                    ),
                                  ),
                                ),
                              ),
                              // ),

                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22,),
                //display place predictions result
                (placesPredictedList.isNotEmpty)
                    ? Expanded(
                  child:
                  SizedBox(
                    height: 250,
                    child: ListView.separated(
                      itemCount: placesPredictedList.length,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index)
                      {
                        return Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: PlacePredictionTileDesign(
                            predictedPlaces: placesPredictedList[index],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index)
                      {
                        return const Padding(
                          padding: EdgeInsets.all(6.0),
                          child: Divider(
                              height: 1,
                              color: Colors.cyan,
                              thickness: 0.2
                          ),
                        );
                      },
                    ),
                  ),
                )
                    : Container(
                  color:AppColors.backgroundColor,
                ),


              ],
            );
          }
      ),
    );
  }
  void findPlaceAutoCompleteSearch(String inputText) async
  {

    // String basicUrl='Basic '+base64Encode(utf8
    //     .encode('realStateApp:realStateApp2024'));
    //
    //
    // 'Authorization':basicUrl,
    print("sssXXXXXXssss...................");
    if(inputText.isNotEmpty) //2 or more than 2 input characters
        {
      String urlAutoCompleteSearch =
          "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:EG";
      var responseAutoCompleteSearch =
      await receiveRequest(urlAutoCompleteSearch);
      if(responseAutoCompleteSearch == "Error Occurred, Failed. No Response.")
      {
        print("ERRRORRRR");
        return;
      }
      if(responseAutoCompleteSearch["status"] == "OK")
      {
        print("OK");
        var placePredictions = responseAutoCompleteSearch["predictions"];
        print("PLACE==${placePredictions[0]}");
        var placePredictionsList = (placePredictions as List)
            .map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

        setState(() {
          placesPredictedList = placePredictionsList;
        });

        print("//////////.......................");
        print(placesPredictedList.first.main_text.toString());
        print(placesPredictedList.first.place_id.toString());
        print("//////////.......................");
      }
      else{
      }
      print("ELSE");
      print(responseAutoCompleteSearch["status"]);
      print(responseAutoCompleteSearch);
    }
  }


  static Future<dynamic> receiveRequest(String url) async
  {
    http.Response httpResponse = await http.get(Uri.parse(url));

    try
    {
      if(httpResponse.statusCode == 200) //successful
          {
        String responseData = httpResponse.body; //json

        var decodeResponseData = jsonDecode(responseData);

        return decodeResponseData;
      }
      else
      {
        return "Error Occurred, Failed. No Response.";
      }
    }
    catch(exp)
    {
      return "Error Occurred, Failed. No Response.";
    }
  }
// final controller=Get.put(HomeController());
}



class PlacePredictionTileDesign extends StatelessWidget
{
  final controller=Get.put(MapController());
  final PredictedPlaces? predictedPlaces;

  PlacePredictionTileDesign({super.key, this.predictedPlaces});

  @override
  Widget build(BuildContext context)
  {
    return ElevatedButton(
      onPressed: ()
      {
        searchController.text= predictedPlaces!.main_text!;
        print('sss222');
        controller.getLatLng(predictedPlaces!.main_text!);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            Icon(
              Icons.add_location,
              color: AppColors.primary,
            ),
            const SizedBox(width: 14.0,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8.0,),
                  Text(
                    predictedPlaces!.main_text!,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2.0,),
                  Text(
                    predictedPlaces!.secondary_text!,
                    overflow: TextOverflow.ellipsis,
                    style:  const TextStyle(
                      fontSize: 12.0,
                      // color: AppColors.greyColotHelper
                    ),
                  ),
                  const SizedBox(height: 8.0,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}