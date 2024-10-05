import 'package:flutter/material.dart';
import 'package:freelancerApp/Core/resources/app_colors.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/controller/home_controller.dart';
import 'package:freelancerApp/features/Home/models/sub_cat.dart';
import 'package:freelancerApp/features/Work/controllers/work_controller.dart';
import 'package:freelancerApp/features/subCat_views/subcat_home_view.dart';
import 'package:get/get.dart';

class SubCatView extends StatefulWidget {
  final String cat;
  const SubCatView({super.key, required this.cat});

  @override
  State<SubCatView> createState() => _SubCatViewState();
}

class _SubCatViewState extends State<SubCatView> {
  WorkController controller = Get.put(WorkController());

  @override
  void initState() {
    controller.getSubCats(widget.cat);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar('', context),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adjusted padding for better spacing
        child: GetBuilder<WorkController>(builder: (_) {
          return controller.subCatList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 3 items per row
              crossAxisSpacing: 16.0, // Space between items horizontally
              mainAxisSpacing: 16.0, // Space between items vertically
              childAspectRatio: 0.9, // Adjust the height/width ratio of grid items
            ),
            itemCount: controller.subCatList.length,
            itemBuilder: (context, index) {
              return SubCatWidget(
                  cat: widget.cat,
                  subCat: controller.subCatList[index]);
            },
          );
        }),
      ),
    );
  }
}

class SubCatWidget extends StatelessWidget {
  String cat;
  final SubCat subCat;

  SubCatWidget({super.key, required this.subCat,required this.cat});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15), // More rounded corners
          color: AppColors.cardColor, // Custom card color
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Subtle shadow
              blurRadius: 8, // Blurring for softer shadows
              offset: const Offset(0, 4), // Offset for depth
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0), // Added consistent padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Align content to the left
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12), // Rounded image corners
                  child: Image.network(
                    subCat.image,
                    height: 120,
                   // width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover, // Make sure image covers the container
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                              : null,
                        ),
                      );
                    },
                //  ),
                ),
              ),
              const SizedBox(height: 8), // Adjusted spacing
              Text(
                subCat.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16, // Adjusted font size to fit grid better
                  color: Colors.black87, // High contrast text color
                ),
              ),
            ],
          ),
        ),
      ),
      onTap:(){
        Get.to(SubCatHomeView(cat: cat, subcat: subCat.name));
      },
    );
  }
}
