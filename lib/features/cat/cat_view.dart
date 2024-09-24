


 import 'package:flutter/material.dart';
import 'package:freelancerApp/core/widgets/custom_app_bar.dart';
import 'package:freelancerApp/features/Home/models/cat.dart';
import 'package:freelancerApp/features/Home/widgets/cat_widget.dart';

class CatView extends StatefulWidget {

  List<Cat>catList;
  
   CatView({super.key,required this.catList});

  @override
  State<CatView> createState() => _CatViewState();
}

class _CatViewState extends State<CatView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomAppBar('التصنيفات', context),
      body:Padding(
        padding: const EdgeInsets.only(top:28.0,left: 10,right: 10),
        child: GridView.builder(
          itemCount: widget.catList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3)
        , itemBuilder: (context, index) {

          return CatWidget(cat: widget.catList[index]);

          
        })
      ),
    );
  }
}