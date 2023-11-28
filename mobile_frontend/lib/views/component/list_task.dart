import 'package:flutter/material.dart';
import '../../model/task_model.dart';

class ListCard extends StatelessWidget {
  final List<String> detailTitle;
  final List<String>? iconName;
  final List<IconData>? myIcon;
  final List<TaskObject> listTask;
  final Color? cardTitleColor;
  final double? cardTextSize;
  final VoidCallback  dialogAction;
  final bool enableDialog;

  const ListCard(
      {super.key,
        required this.enableDialog,
        required this.detailTitle,
        required this.dialogAction,
        required this.listTask,
        this.iconName,
        this.myIcon,
        this.cardTextSize,
        this.cardTitleColor,

      });

  Widget contentText(double? textSize, Color? textColor, int index,BuildContext context) {
    List<String> myValue = [];
    var value = listTask[index];
    Map<String, String> taskValue = value.toJson();
    List<String> temp = [];
    taskValue.forEach((key, value) {
      temp.add(value);
    });
    for (var element in temp) {
      myValue.add(element);
    }
    var myReturn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for(var value in temp)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width*0.3,
                child: Text('${detailTitle[temp.indexOf(value)]}',
                    style: TextStyle(
                        color: textColor ?? Colors.black, fontSize: textSize ?? 15)),
              ),
              Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width*1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(': ${temp[temp.indexOf(value)]}',
                          style: TextStyle(fontSize: textSize ?? 15, color: Colors.black)),
                    ),
                  )
              )
            ],
          ),
          // RichText(
          //   text: TextSpan(
          //     children: [
          //       TextSpan(text: '${detailTitle[temp.indexOf(value)]} : ',
          //           style: TextStyle(
          //               color: textColor ?? Colors.black, fontSize: textSize ?? 15)),
          //       TextSpan(text: temp[temp.indexOf(value)],
          //           style: TextStyle(fontSize: textSize ?? 15, color: Colors.black)),
          //     ],
          //   ),
          // ),
      ],
    );
    return myReturn;
  }

  Widget customIcon(String expectIcon, List<IconData> iconINeed, List<String> listIconName) {
    for (var value in listIconName) {
      if (value == expectIcon) {
        return Icon(iconINeed[listIconName.indexOf(value)]);
      }
    }
    return const Icon(Icons.add_box_outlined);
  }
  @override
  Widget build(BuildContext context) {
    List<String> taskTitle =[];
    for(var value in listTask) {
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
                            content:const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text("Nhấn vào nút mở để biết thêm thông tin về task."),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: dialogAction,
                                child:  const Text("Mở"),
                              ),
                              TextButton(
                                child: const Text('Đóng',style: TextStyle(color: Colors.red),),
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
                  margin:const EdgeInsets.all(10),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            if(myIcon!= null && iconName!=null) customIcon(listTask[index].taskStatus, myIcon!, iconName!),
                            Text(listTask[index].taskStatus,
                                style: TextStyle(color: Colors.deepOrangeAccent,
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
                              width: MediaQuery.of(context).size.width*0.3,
                              child: Text(listTask[index].taskCode,
                                  style: TextStyle(color: cardTitleColor ??
                                      Colors.deepOrangeAccent, fontSize: 15)),
                            ),
                            Expanded(
                                child: SizedBox(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(': ${listTask[index].taskTitle}',
                                        style: TextStyle(fontSize: cardTextSize ?? 15,
                                            color: Colors.black)),
                                  ),
                                )
                            )
                          ],
                        ),
                        contentText(15,Colors.deepOrangeAccent,index,context),
                        // ),
                      ],
                    )
                ),
              ),
            ],
          );
        }
    );
  }
}