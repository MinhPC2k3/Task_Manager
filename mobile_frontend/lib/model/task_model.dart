import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../data/api_services.dart';
import '../data/api_urls.dart';


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
  String? imageUrl;
  TaskObject(
      {required this.taskStatus,
        required this.taskCode,
        required this.taskTitle,
        required this.destinationName,
        required this.productValue,
        required this.shipCost,
        required this.taskID,
        required this.expireTime,this.imageUrl,
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
    final TaskDateTime = json['DeathLine'].toString();
    final taskLat = json['LatValue'];
    final taskLng = json['LngValue'];
    // String imagePathUrl = "http://172.20.10.2:8080/${json['ImagePath']}";
    // 10.42.0.178
    String? imagePathUrl;
    if(json['ImagePath'] !=null) {
       // imagePathUrl = "http://10.42.0.178:8080${json['ImagePath']}";
       imagePathUrl = hostAddress+json['ImagePath'];
    }else {
      imagePathUrl = hostAddress;
    }

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
        imageUrl : imagePathUrl,
        destinationPosition : LatLng(taskLat,taskLng),
    );
  }
}


// List<TaskObject> myTask =[];

class TaskRepository{

  List<TaskObject> listTasks =[];
  Future<List<TaskObject>> getListTask() async{
    listTasks = await fetchTask(http.Client());
    return listTasks;
  }

  Future<int> postTaskRequest(List<String> taskProperties) async{
    int postStatus = await postTask(taskProperties);
    return postStatus;
  }
}