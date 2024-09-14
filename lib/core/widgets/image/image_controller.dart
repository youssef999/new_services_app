
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';




class ImageController extends GetxController{

 final ImagePicker picker = ImagePicker();
  List<XFile> images = [];
  Future<void> pickMultipleImages() async {
    List<XFile>? selectedImages = [];
    images.clear();
    //while (true) {
      final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImages.add(pickedFile);
      } else {
        //break; // Break the loop if no image is selected
      }
   // }
    if (selectedImages.isNotEmpty) {
        images.addAll(selectedImages); // Add selected images to the list
    }
    update();
  }


}