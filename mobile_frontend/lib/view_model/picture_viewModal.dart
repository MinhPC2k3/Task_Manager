import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

class PictureViewModal extends ChangeNotifier {

  File? imageFile;
  final picker = ImagePicker();
  Image? imageDisplay;
  List<File> listImgFile =[];

  Future<void> getImage(ImageSource img) async {
    print("doing");
    final pickedFile = await picker.pickImage(source: img);
    XFile? xfilePick = pickedFile;
    if (xfilePick != null) {
      imageFile = File(pickedFile!.path);
      imageDisplay = Image.file(imageFile!);
      listImgFile.add(File(pickedFile.path));
      print("lít image length ${listImgFile.length}");
    }
  }

  void showPicker(bool isTakePicture) async{
    if(isTakePicture){
      await getImage(ImageSource.camera);
      print("file path $imageFile");
      notifyListeners();
    }else {
      print("file path $imageFile");
      await getImage(ImageSource.gallery);
      notifyListeners();
    }
  }

  void openBottomModal(BuildContext context) {
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
                  showPicker(false);
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
                  showPicker(true);
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
}