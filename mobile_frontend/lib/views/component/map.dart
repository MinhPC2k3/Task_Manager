import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../model/map_model.dart';
import '../../model/task_model.dart';
import '../../view_model/map_viewModel.dart';

class MapScreen extends StatefulWidget{
  final List<TaskObject> listTasks;
  const MapScreen({super.key,required this.listTasks});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

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