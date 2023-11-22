import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TaskObject {
  final String taskStatus;
  final String taskCode;
  final String taskTitle;
  final String destinationName;
  final int productValue;
  final int shipCost;
  final int taskID;
  final DateTime expireTime;
  LatLng? destinationPosition;
  TaskObject(
      {required this.taskStatus,
        required this.taskCode,
        required this.taskTitle,
        required this.destinationName,
        required this.productValue,
        required this.shipCost,
        required this.taskID,
        required this.expireTime,
      this.destinationPosition});
  TaskObject copyTask(){
    TaskObject newTask =  TaskObject(taskStatus : taskStatus, taskCode : taskCode, taskTitle : taskTitle, destinationName : destinationName, productValue : productValue, shipCost : shipCost, taskID : taskID, expireTime : expireTime, destinationPosition : destinationPosition);
    return newTask;

  }
  Map<String,String> toJson (){

    Map<String,String> objectField =  <String,String>{};
    objectField['destinationName']= destinationName;
    objectField['productValue']= productValue.toString();
    objectField['shipCosts']= shipCost.toString();
    // objectField['expireTime'] = expireTime.toString();
    objectField['expireTime'] = DateFormat('kk:mm dd/MM/yyyy').format(expireTime).toString();
    // objectField['expireTime']= '${expireTime.hour}:${expireTime.minute} ${expireTime.day}/${expireTime.month}/${expireTime.year}';
    return objectField;
  }
  factory TaskObject.fromJson(Map<String, dynamic> json) {
    final myDateTime = json['DeathLine'].toString();
    final myLat = json['LatValue'];
    final myLng = json['LngValue'];
    print("hello ${json['DeathLine']} ${json['DeathLine'].runtimeType}");
    return TaskObject(
        taskStatus : json['Status'] as String,
        taskID : json['ID'] as int,
        taskCode: json['Code'] as String,
        taskTitle: json['Target'] as String, 
        destinationName : json['Destination'] as String,
        productValue : json['ProductValue'] as int,
        shipCost : json['ShipCost'] as int,
        expireTime :DateTime.parse(json['DeathLine'].toString()),
        //json['DeathLine'] as DateTime

        destinationPosition : LatLng(myLat,myLng),
    );
  }
}


List<TaskObject> myTask =[];


List<String> myDetailTitle =['Điểm lấy hàng','Tiền hàng','Phí ship','Thời gian'];
List<String> taskIcon =["Đơn mới","Chờ lấy hàng"];
List<IconData> myViewIcon =[Icons.add_box_outlined , Icons.alarm_sharp];