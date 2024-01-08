import 'dart:io';

import 'package:example_map/view_model/task_viewModel.dart';
import 'package:flutter/material.dart';

import '../../data/api_urls.dart';
import '../../model/task_model.dart';
import '../../view_model/picture_viewModal.dart';

// ignore: must_be_immutable
class ListCard extends StatelessWidget {
  final List<String> detailTitle;
  final List<String>? iconName;
  final List<IconData>? cardIcon;
  final List<TaskObject> listTask;
  final Color? cardTitleColor;
  final double? cardTextSize;
  final VoidCallback dialogAction;
  final bool enableDialog;
  final Widget? cardButton;
  final TaskViewModal? taskViewModal;

  // List<File?>? imageFile;
  Map<int, File?>? imageFile;
  PictureViewModal? pictureViewModal;

  ListCard({
    super.key,
    required this.enableDialog,
    required this.detailTitle,
    required this.dialogAction,
    required this.listTask,
    this.iconName,
    this.cardIcon,
    this.cardTextSize,
    this.cardTitleColor,
    this.cardButton,
    this.imageFile,
    this.pictureViewModal,
    this.taskViewModal
  });

  Widget contentText(double? textSize, Color? textColor, int index,
      BuildContext context) {
    List<String> textValue = [];
    var value = listTask[index];
    Map<String, String> taskValue = value.toJson();
    List<String> temp = [];
    taskValue.forEach((key, value) {
      if (key != "imageUrl") {
        temp.add(value);
      }
    });
    for (var element in temp) {
      textValue.add(element);
    }
    var returnValue = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var value in temp)
        //       if(temp.indexOf(value) == temp.length-1){
        // }
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.3,
                child: Text(detailTitle[temp.indexOf(value)],
                    style: TextStyle(
                        color: textColor ?? Colors.black,
                        fontSize: textSize ?? 15)),
              ),
              Expanded(
                  child: SizedBox(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width * 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(': ${temp[temp.indexOf(value)]}',
                          style: TextStyle(
                              fontSize: textSize ?? 15, color: Colors.black)),
                    ),
                  ))
            ],
          )
      ],
    );
    return returnValue;
  }

  Widget customIcon(String expectIcon, List<IconData> iconINeed,
      List<String> listIconName) {
    for (var value in listIconName) {
      if (value == expectIcon) {
        return Icon(iconINeed[listIconName.indexOf(value)]);
      }
    }
    return const Icon(Icons.add_box_outlined);
  }

  @override
  Widget build(BuildContext context) {
    List<String> taskTitle = [];
    for (var value in listTask) {
      taskTitle.add(value.taskTitle);
    }

    return ListView.builder(
        shrinkWrap: true,
        itemCount: listTask.length,
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  // onTapCard!;
                  if (enableDialog) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            title: Text(taskTitle[index]),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text(
                                      "Nhấn vào nút mở để biết thêm thông tin về task."),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: dialogAction,
                                child: const Text("Mở"),
                              ),
                              TextButton(
                                child: const Text(
                                  'Đóng',
                                  style: TextStyle(color: Colors.red),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                    );
                  }
                },
                child: Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if (cardIcon != null && iconName != null)
                              customIcon(listTask[index].taskStatus, cardIcon!,
                                  iconName!),
                            Text(listTask[index].taskStatus,
                                style: TextStyle(
                                    color: Colors.deepOrangeAccent,
                                    fontSize: cardTextSize ?? 15)),
                          ],
                        ),
                        const Divider(
                          color: Colors.grey,
                          height: 1,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.3,
                              child: Text(listTask[index].taskCode,
                                  style: TextStyle(
                                      color: cardTitleColor ??
                                          Colors.deepOrangeAccent,
                                      fontSize: 15)),
                            ),
                            Expanded(
                                child: SizedBox(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        ': ${listTask[index].taskTitle}',
                                        style: TextStyle(
                                            fontSize: cardTextSize ?? 15,
                                            color: Colors.black)),
                                  ),
                                ))
                          ],
                        ),
                        contentText(
                            15, Colors.deepOrangeAccent, index, context),
                        Center(
                          child: Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrangeAccent,
                              ),
                              onPressed: () {
                                // pictureViewModal!.mappingImage(listTask[index].taskCode);
                                pictureViewModal!.openBottomModal(
                                    context, listTask[index].taskCode, index);
                              },
                              child: Text("Thêm ảnh"),
                            ),
                          ),
                        )
                        // ),
                      ],
                    )),
              ),
              // listTask[index].imageUrl != "http://10.42.0.178:8080" ? Container(
              listTask[index].imageUrl == hostAddress && !pictureViewModal!.mapIndexToPath.containsKey(index) ? Container() : Container(
                child: pictureViewModal!.isSelectImage ? Container(
                      width: MediaQuery.of(context).size.width * 1,
                      padding: const EdgeInsets.all(10),
                      height: 200,
                      child: Column(
                        children: [
                          // Image.file(
                          //   // imageFile![index]!,
                          //    pictureViewModal!.mapImgAndCode[listTask[index].taskCode]!,
                          //
                          //   height: 100,
                          //   width: 200,
                          // ),
                          pictureViewModal!.mapImgAndCode[listTask[index].taskCode] == null
                              ? Image.network(listTask[index].imageUrl!, height: 100, width: 200,)
                              : Image.file(pictureViewModal!.mapImgAndCode[listTask[index].taskCode]!, height: 100, width: 200,),
                          // imageFile![index]!,

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.white),
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.grey),
                                ),
                                onPressed: () {

                                  pictureViewModal!.sendImageToApi(index, listTask[index].taskCode, pictureViewModal!.mapIndexToPath[index]!);
                                  taskViewModal!.getListTaskRebuild();
                                  print("This is url1 ${listTask[index].imageUrl}");
                                },
                                child: const Text("Lưu ảnh",
                                    style: TextStyle(color: Colors.blue)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  pictureViewModal!.deleteImageClick();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                  shadowColor: MaterialStateProperty.all<Color>(Colors.grey),
                                ),
                                child: const Text(
                                  "Xóa ảnh",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ) : Container(
                          margin: const EdgeInsets.all(10),
                          height: 200,
                          width: 200,
                          child:listTask[index].imageUrl! != hostAddress ? Image.network(listTask[index].imageUrl!) : const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
              )
            ],
          );
        });
  }
}
