import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/map_model.dart';
import '../../model/task_model.dart';
import '../../view_model/map_viewModel.dart';

class MyMap extends StatefulWidget{
  List<TaskObject> listTasks;
  MyMap({super.key,required this.listTasks});

  @override
  State<MyMap> createState() => _MyMapState();
}
class _MyMapState extends State<MyMap> {

  // @override
  // void initState() {
  //   super.initState();
  //   myMap.getLocation(myMap.mapView, context);
  // }
  @override

  Widget build(BuildContext context){
    List<TaskObject> listTasks = widget.listTasks;
    return Consumer<MapViewModal>(
        builder: (context,mapViewModal,Widget? child){
          print("from map");
          // Provider.of<MapViewModal>(context,listen: false).getLocation(mapViewModal.mapView, context);
          return FutureBuilder(
              future: mapViewModal.getLocation(mapViewModal.mapView, context),
              builder: ( context,snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else{
                  return Scaffold(
                    appBar: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.green,
                      title: const Text('Map'),
                      leading: null,
                      actions: [
                        TextButton(
                          onPressed: () {
                            mapViewModal.exitFunc(context);
                          },
                          child:const Text('Đóng',style: TextStyle(color: Colors.red , fontSize: 15),),

                        ),
                        TextButton(
                            onPressed: ()=>{
                              mapViewModal.currentLocationView(),
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
                    body: mapViewModal.mapView.currentLocation == null ? const Center(child:CircularProgressIndicator()) :  Stack(
                      alignment: Alignment.center,
                      children: [
                        GoogleMap(
                          onMapCreated: mapViewModal.onMapCreated,
                          myLocationEnabled: true,

                          initialCameraPosition: CameraPosition(
                            target: LatLng(mapViewModal.mapView.currentLocation!.latitude!,mapViewModal.mapView.currentLocation!.longitude!),
                            zoom: 14.0,
                          ),
                          markers: {
                            if(mapViewModal.mapView.originPoint!=null) mapViewModal.mapView.originPoint!,
                            if(mapViewModal.mapView.destinationPoint!=null) mapViewModal.mapView.destinationPoint!,
                            if(mapViewModal.mapView.listMarker!=null) for(int i=0;i<mapViewModal.mapView.listMarker!.length;i++) mapViewModal.getMarker(mapViewModal.mapView.listMarker, i),
                            for(var value in listTasks) Marker(
                              markerId:  MarkerId('Destination ${listTasks.indexOf(value)}'),
                              infoWindow: InfoWindow(
                                  title: listTasks[listTasks.indexOf(value)].taskTitle,
                                  snippet: listTasks[listTasks.indexOf(value)].destinationName
                              ),
                              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                              position: value.destinationPosition!,
                            ),
                          },
                          polylines: {
                            if (mapViewModal.mapView.info != null)
                              Polyline(
                                polylineId: const PolylineId('overview_polyline'),
                                color: Colors.red,
                                width: 5,
                                points: mapViewModal.mapView.info!.polylinePoints
                                    .map((e) => LatLng(e.latitude, e.longitude))
                                    .toList(),
                              ),

                            if(mapViewModal.mapView.finalInfo!=null) for(int i=0;i<mapViewModal.mapView.finalInfo!.length;i++) Polyline(
                              polylineId:  const PolylineId('overview_polyline'),
                              color: Colors.red,
                              width: 5,
                              points: mapViewModal.mapView.finalInfo![i]!.polylinePoints
                                  .map((e) => LatLng(e.latitude, e.longitude))
                                  .toList(),
                            ),
                            for(int i=0;i<mapViewModal.mapView.listPolyline!.length;i++) mapViewModal.getPolyline(mapViewModal.mapView.listPolyline, i),


                          },
                          // onLongPress:(latlang){
                          //   myMap.mapView.isAddMultiMarker == 0 ? myMap.addMarker(myMap.mapView,latlang) : myMap.addMultiMarker(myMap.mapView,latlang);
                          //   for(int i=0;i<myMap.mapView.listMarker!.length;i++){
                          //     mapController!.showMarkerInfoWindow(myMap.mapView.listMarker![i].markerId);
                          //   }
                          // },
                        ),
                        if (mapViewModal.mapView.info != null)
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
                                '${mapViewModal.mapView.info!.totalDistance}, ${mapViewModal.mapView.info!.totalDuration}',
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
                }
              }
          );
        },
    );
  }
}