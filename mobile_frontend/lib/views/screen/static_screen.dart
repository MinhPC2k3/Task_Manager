import 'package:example_map/view_model/picture_viewModal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StaticScreen extends StatefulWidget{
  const StaticScreen({super.key});

  @override
  State<StaticScreen> createState() => _StaticScreenState();
}

class _StaticScreenState extends State<StaticScreen> {

  @override
  Widget build(BuildContext context){
    return Consumer<PictureViewModal>(
        builder: (context,pictureViewModal,child){
          return SafeArea(
            child: Column(
              children: [
                const Center(
                  child: Text("Feature comming soon"),
                ),
                // ElevatedButton(
                //   onPressed: (){
                //     pictureViewModal.showPicker(false);
                //   },
                //   child: const Text(
                //       "Chọn ảnh từ máy"
                //   ),
                // ),
                // ElevatedButton(
                //   onPressed: (){
                //     pictureViewModal.showPicker(true);
                //   },
                //   child: const Text(
                //       "Chụp ảnh mới"
                //   ),
                // ),
                // pictureViewModal.imgFromApi == null ? const Text("emty picture") : SizedBox(height: 200,width: 200,child: pictureViewModal.imgFromApi!,),
              ],
            ),
          );
        }
    );
  }
}