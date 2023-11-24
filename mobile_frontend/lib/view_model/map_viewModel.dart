import 'package:example_map/logic/direction_logic.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/map_model.dart';
import '../model/task_model.dart';
import 'package:location/location.dart';
import '../data/api_services.dart';

class MapViewModal extends ChangeNotifier{
  MapDisplay mapView= MapDisplay(null, null, null, null, [], [], 0, 0, {}, [],null);
  List<TaskObject> listTaskObject =[];
  TaskRepository taskRepository = TaskRepository();

  Polyline getPolyline (Set<Polyline>? tempList , int index){
    return tempList!.elementAt(index);
  }

  Marker getMarker (List<Marker>? tempList , int index){
    return tempList!.elementAt(index);
  }

  Future<int> getLocation(MapDisplay tempMap , BuildContext context)  async{
    listTaskObject = await taskRepository.getListTask();
    Location location = Location();
    await location.requestPermission();
    var statusPermission = await location.hasPermission();
      tempMap.locationPermission = statusPermission.toString();
      if(tempMap.locationPermission != "PermissionStatus.granted"){
        Navigator.pop(context);
        // notifyListeners();
        return 0;
      }else{
        tempMap.currentLocation = await location.getLocation();
        isLoading = false;
        List<LatLng> listDestination = [];
        sortPosition(listTaskObject);
        listDestination.add(LatLng(tempMap.currentLocation!.latitude!, tempMap.currentLocation!.longitude!));
        for(var value in listTaskObject){
          listDestination.add(value.destinationPosition!);
        }
        // listDestination.add(LatLng(tempMap.currentLocation!.latitude!, tempMap.currentLocation!.longitude!));
        tempMap.listPolyline?.add(Polyline(
            polylineId:const PolylineId('List polyline'),
            visible: true,
            width: 5,
            points: listDestination,
            color: Colors.blueAccent
        ));
        // notifyListeners();
        return 1;
      }

  }
  // Future<List<Directions?>> getRoute (List<Marker> myListMarker) async{
  //   List<Directions?> result=[];
  //   if(myListMarker.length>=2){
  //     for(int i=0;i<(myListMarker.length-1);i++){
  //       for(int j=i+1;j<myListMarker.length;j++){
  //         var tempVar = await getDirection(myListMarker.elementAt(i).position, myListMarker.elementAt(j).position);
  //         result.add(tempVar);
  //       }
  //     }
  //   }
  //   return result;
  // }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
    notifyListeners();
  }

  void currentLocationView(){
    mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(mapView.currentLocation!.latitude!,mapView.currentLocation!.longitude!),
            zoom: 17.0,
          )
      ),
    );
    notifyListeners();
  }
  void exitFunc(BuildContext context){
    Navigator.pop(context);
    notifyListeners();
  }
}



// location.onLocationChanged.listen((event) {
//   tempMap.currentLocation = event;
//   if(mapController != null){
//     mapController!.animateCamera(
//       CameraUpdate.newCameraPosition(
//           CameraPosition(
//             target: LatLng(mapView.currentLocation!.latitude!,mapView.currentLocation!.longitude!),
//             zoom: 14.0,
//           )
//       ),
//     );
//   }
// });
// notifyListeners();
