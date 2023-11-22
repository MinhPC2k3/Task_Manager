import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../view_model/map_viewModel.dart';

class MapDisplay{
  LatLng? currentPosition ;
  Marker? originPoint;
  Marker? destinationPoint;
  Directions? info;
  List<Directions?>? finalInfo;
  List<Marker>? listMarker;
  int isAddMultiMarker =0;
  int listIndex =0;
  Set<Polyline>? listPolyline ;
  List<int>? indexMarker;
  LocationData? currentLocation;
  String? locationPermission;
  MapDisplay(this.currentPosition,this.originPoint,this.destinationPoint,this.info,this.finalInfo,this.listMarker,this.isAddMultiMarker,this.listIndex,this.listPolyline,this.indexMarker,this.currentLocation);
}

class Directions {
  final LatLngBounds bounds;
  final List<PointLatLng> polylinePoints;
  final String totalDistance;
  final String totalDuration;

  const Directions({
    required this.bounds,
    required this.polylinePoints,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory Directions.fromJSON(Map<String, dynamic> map) {
    // Check if route is not available
    // Get route information
    final data = Map<String, dynamic>.from(map['routes'][0]);

    // Bounds
    final northeast = data['bounds']['northeast'];
    final southwest = data['bounds']['southwest'];
    final bounds = LatLngBounds(
      northeast: LatLng(northeast['lat'], northeast['lng']),
      southwest: LatLng(southwest['lat'], southwest['lng']),
    );

    // Distance & Duration
    String distance = '';
    String duration = '';
    if ((data['legs'] as List).isNotEmpty) {
      final leg = data['legs'][0];
      distance = leg['distance']['text'];
      duration = leg['duration']['text'];
    }

    return Directions(
      bounds: bounds,
      polylinePoints:
      PolylinePoints().decodePolyline(data['overview_polyline']['points']),
      totalDistance: distance,
      totalDuration: duration,
    );
  }
}

MapViewModal myMap = MapViewModal();
GoogleMapController? mapController;
bool isLoading = true;