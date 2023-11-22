import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/task_model.dart';
import '../view_model/map_viewModel.dart';

double tempValueOfRoute =100000;
List<List<int>> listPermutation =[];
bool checkIsStop = false;
List<int> tempList =[];
void getPermutation(){
  int j = tempList.length-2;
  int k, r, s, temp;
  while(j>=0 && tempList[j]>tempList[j+1]){
    j--;
  }
  if(j==-1){
    checkIsStop = true;
  }else{
    k = tempList.length-1;
    while(tempList[k] <tempList[j]){
      k--;
    }
    temp = tempList[k];
    tempList[k] = tempList[j];
    tempList[j] = temp;
    r=j+1;
    s = tempList.length-1;
    while(r<s){
      temp = tempList[r];
      tempList[r] = tempList[s];
      tempList[s] = temp;
      r++;
      s--;
    }
  }
  double result =0;
  for(int i=0;i<tempList.length-1;i++){
    if(i==0){
      result = result + globalMatrix[0][tempList[i]+1];
    }else if(i== (tempList.length-2)){
      result = result + globalMatrix[tempList[i+1]+1][0];
    }
    result = result + globalMatrix[tempList[i]+1][tempList[i+1]+1];
  }
  if(result < tempValueOfRoute){
    tempValueOfRoute =result;
      for(int counter =0 ;counter<tempList.length;counter++){
        globalList[counter] = tempList[counter] ;
      }
  }
}
void createList (int totalNum){
  for(int i=0;i<totalNum;i++){
    tempList.add(i);
    globalList.add(i);
  }
}
void printPermutation (){
  checkIsStop = false;
  while(!checkIsStop){
    getPermutation();
  }
}
List<List<double>> valueMatrix (List<Marker>? listMarker , LatLng currentLocation){
  var convertMarker = Marker(
      markerId: const MarkerId('current location'),
      position: currentLocation,
  );
  List<Marker> allMarker = [convertMarker];
  for(var element in listMarker!){
    allMarker.add(element);
  }
  int markerLength = allMarker.length;
  List<List<double>> resultMatrix =List.generate(
      markerLength, (i) => List<double>.filled(markerLength, 0, growable: true),
      growable: false);
  for(int i=0;i<markerLength;i++){
    for(int j=0;j<markerLength;j++){
      if(i==j){
        resultMatrix[i][j]=0;
      }else{
        double minusLat = allMarker[i].position.latitude-allMarker[j].position.latitude;
        double minusLng =allMarker[i].position.longitude-allMarker[j].position.longitude;
        double distance = sqrt(minusLat*minusLat+minusLng*minusLng);
        resultMatrix[i][j]=distance;
      }
    }
  }
  return resultMatrix;
}
late List<List<double>> globalMatrix ;
List<int> globalList = [];

void clearMatrix (List<Marker>? tempList){
  for(int i=0;i<tempList!.length;i++){
    for(int j=0;j<tempList.length;j++){
      globalMatrix[i].clear();
    }
  }
}
void sortPosition (List<TaskObject> tempListTask){
  for(var value in tempListTask){
    int currentIndex = tempListTask.indexOf(value);
    TaskObject tempObject = value.copyTask();
    while(currentIndex >0 && tempObject.expireTime.isBefore(tempListTask[currentIndex-1].expireTime)){
      currentIndex--;
      TaskObject beforeObject = tempListTask[currentIndex].copyTask();
      tempListTask[currentIndex +1] = beforeObject.copyTask();
      tempListTask[currentIndex] = tempObject.copyTask();
    }
  }
}


