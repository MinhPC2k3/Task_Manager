import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../model/map_model.dart';
import '../../model/task_model.dart';

class MyMap extends StatefulWidget{
  const MyMap({super.key});

  @override
  State<MyMap> createState() => _MyMapState();
}
class _MyMapState extends State<MyMap> {

  @override
  void initState() {
    super.initState();
    myMap.getLocation(myMap.mapView, context);
  }

  @override

  Widget build(BuildContext context){

    return ListenableBuilder(
        listenable: myMap,
        builder: (BuildContext context,Widget? child){
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.green,
              title: const Text('Map'),
              leading: null,
              actions: [
                TextButton(
                  onPressed: () {
                    myMap.exitFunc(context);
                  },
                  child:const Text('Đóng',style: TextStyle(color: Colors.red , fontSize: 15),),

                ),
                TextButton(
                    onPressed: ()=>{
                      myMap.currentLocationView(),
                    },
                    child: const Text('Vị trí' , style: TextStyle(color: Colors.blue , fontSize: 15),)
                ),
                // TextButton(
                //     onPressed: (){
                //       myMap.routeButton();
                //       for(var value in myMap.mapView!.listMarker!){
                //         print('This is position ${value.position}');
                //       }
                //       sortPosition(myTask);
                //       for(var value in myTask){
                //         print("Sorted object ${value.destinationName}");
                //       }
                //     },
                //     child: const Text('Route' , style: TextStyle(color: Colors.blue , fontSize: 15),)
                // ),
                // TextButton(
                //     onPressed: (){
                //       setState(() {
                //         myMap.setIsAddMarker();
                //       });
                //     },
                //     child: myMap.mapView.isAddMultiMarker == 0 ? const Text('Add Marker' , style: TextStyle(color: Colors.blue , fontSize: 15),) : const Text('Done' , style: TextStyle(color: Colors.red , fontSize: 15),)
                // ),
                // TextButton(
                //     onPressed: (){
                //       myMap.deleteButton();
                //     },
                //     child:const Text('Delete' , style: TextStyle(color: Colors.red , fontSize: 15),)
                // )
              ],
            ),
            body: myMap.mapView.currentLocation == null ? const Center(child:CircularProgressIndicator()) :  Stack(
              alignment: Alignment.center,
              children: [
                GoogleMap(
                  onMapCreated: myMap.onMapCreated,
                  myLocationEnabled: true,

                  initialCameraPosition: CameraPosition(
                    target: LatLng(myMap.mapView.currentLocation!.latitude!,myMap.mapView.currentLocation!.longitude!),
                    zoom: 14.0,
                  ),
                  markers: {
                    if(myMap.mapView.originPoint!=null) myMap.mapView.originPoint!,
                    if(myMap.mapView.destinationPoint!=null) myMap.mapView.destinationPoint!,
                    if(myMap.mapView.listMarker!=null) for(int i=0;i<myMap.mapView.listMarker!.length;i++) myMap.getMarker(myMap.mapView.listMarker, i),
                    for(var value in myTask) Marker(
                      markerId:  MarkerId('Destination ${myTask.indexOf(value)}'),
                      infoWindow: InfoWindow(
                      title: myTask[myTask.indexOf(value)].taskTitle,
                      snippet: myTask[myTask.indexOf(value)].destinationName
                      ),
                      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                      position: value.destinationPosition!,
                      ),
                  },
                  polylines: {
                    if (myMap.mapView.info != null)
                      Polyline(
                        polylineId: const PolylineId('overview_polyline'),
                        color: Colors.red,
                        width: 5,
                        points: myMap.mapView.info!.polylinePoints
                            .map((e) => LatLng(e.latitude, e.longitude))
                            .toList(),
                      ),

                    if(myMap.mapView.finalInfo!=null) for(int i=0;i<myMap.mapView.finalInfo!.length;i++) Polyline(
                      polylineId:  const PolylineId('overview_polyline'),
                      color: Colors.red,
                      width: 5,
                      points: myMap.mapView.finalInfo![i]!.polylinePoints
                          .map((e) => LatLng(e.latitude, e.longitude))
                          .toList(),
                    ),
                    for(int i=0;i<myMap.mapView.listPolyline!.length;i++) myMap.getPolyline(myMap.mapView.listPolyline, i),


                  },
                  // onLongPress:(latlang){
                  //   myMap.mapView.isAddMultiMarker == 0 ? myMap.addMarker(myMap.mapView,latlang) : myMap.addMultiMarker(myMap.mapView,latlang);
                  //   for(int i=0;i<myMap.mapView.listMarker!.length;i++){
                  //     mapController!.showMarkerInfoWindow(myMap.mapView.listMarker![i].markerId);
                  //   }
                  // },
                ),
                if (myMap.mapView.info != null)
                  Positioned(
                    top: 20.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6.0,
                        horizontal: 12.0,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.yellowAccent,
                        borderRadius: BorderRadius.circular(20.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            offset: Offset(0, 2),
                            blurRadius: 6.0,
                          )
                        ],
                      ),
                      child: Text(
                        '${myMap.mapView.info!.totalDistance}, ${myMap.mapView.info!.totalDuration}',
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
    );
  }
}