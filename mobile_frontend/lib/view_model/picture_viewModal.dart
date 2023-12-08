import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../data/api_services.dart';
import '../data/api_urls.dart';

class PictureViewModal extends ChangeNotifier {

  File? imageFile;
  final picker = ImagePicker();
  Image? imageDisplay;
  List<File> listImgFile =[];
  List<String> imagePath = [];
  Map<String,File> mapImgAndCode ={};
  // Image imgFromApi =Image.network(imagePath);

  Future<void> getImage(ImageSource img, String taskCode) async {
    print("doing");
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      imageFile = File(pickedFile!.path);
      imageDisplay = Image.file(imageFile!);
      listImgFile.add(File(pickedFile.path));
      imagePath.add(pickedFile.path);
      mapImgAndCode.addEntries({MapEntry(taskCode,File(pickedFile.path))});
      print("list image length ${listImgFile.length}");
    }
  }

  void showPicker(bool isTakePicture,String taskCode) async{
    if(isTakePicture){
      await getImage(ImageSource.camera,taskCode);
      print("file path $imageFile");
      notifyListeners();
    }else {
      print("file path $imageFile");
      await getImage(ImageSource.gallery,taskCode);
      notifyListeners();
    }
  }

  void openBottomModal(BuildContext context,String taskCode) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      enableDrag: true,
      builder: (BuildContext context) {
        return Container(
          height: 100,
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: (){
                  showPicker(false,taskCode);
                  Navigator.pop(context);
                  notifyListeners();
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                      Colors.greenAccent[100],
                      child: Icon(Icons.picture_in_picture_alt_outlined,color: Colors.greenAccent[800],),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Text("Gallery", style: TextStyle(fontSize:15,color:Colors.black),),
                    )
                  ],
                ),
              ),
              const Divider(),
              InkWell(
                onTap: (){
                  showPicker(true,taskCode);
                  Navigator.pop(context);
                  notifyListeners();
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor:
                      Colors.blue[100],
                      child: const Icon(
                          Icons.camera_alt_outlined),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: const Text("Camera", style: TextStyle(fontSize:15,color:Colors.black),),
                    )
                  ],
                ),
              )

            ],
          ),
        );
      },
    );
  }

  void sendImageToApi (int index,String productCode , String imagePath) async{
    await uploadImage(listImgFile[index],productCode,imagePath);
    notifyListeners();
  }

  String standardizeImageName (String imageName) {
    String temp = imageName.toLowerCase();
    String result = temp.replaceAll(" ", "_");
    return result;
  }
  // Future<void> getImageFromAPi() async{
  //   imgFromApi = await Image.network(imagePath);
  // }
}