import 'dart:convert';
import 'package:example_map/data/api_urls.dart';
import 'package:example_map/views/screen/authentication_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../model/task_model.dart';
import '../model/map_model.dart';
import 'package:http/http.dart' as http;
import '../view_model/add_task_viewModel.dart';
import '../views/screen/add_task_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage
var storage = const FlutterSecureStorage();

Future<Directions?> getDirection(LatLng origin, LatLng destination) async {
  final Uri uri = Uri.https(directionHost, directionPath, {
    'origin': '${origin.latitude},${origin.longitude}',
    'destination': '${destination.latitude},${destination.longitude}',
    'key': 'AIzaSyDOl-UTdz2i3Ect0RyQ77-JHji0cAKz5CM',
  });

  final response = await http.Client().get(uri);
  if (response.statusCode == 200) {
    return Directions.fromJSON(jsonDecode(utf8.decode(response.bodyBytes)));
  }
  return null;
}

Future<TaskObject> fetchData(http.Client myClient, String myUrl) async {
  final response = await myClient.get(Uri.parse(myUrl));
  if (response.statusCode == 200) {
    return TaskObject.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
  } else {
    throw Exception('Failed to load album');
  }
}

Future<List<TaskObject>> fetchTask(http.Client client) async {
  String? jwtToken = await storage.read(key: 'jwt');
  final user = jsonDecode(jwtToken!);
  print("got token jwt $jwtToken");
  Map<String, String> myHeaderGet = {};
  myHeaderGet.addEntries([
    const MapEntry('Content-Type', 'application/json'),
    MapEntry('Authorization', user["user_name"])
  ]);
  // final response = await client.get(Uri.parse(taskObjectPath),headers: myHeaderGet);
  final response =
      await http.get(Uri.parse(taskObjectPath), headers: myHeaderGet);
  return compute(parseTasks, response.body);
}

// A function that converts a response body into a List<Photo>.
List<TaskObject> parseTasks(String responseBody) {
  final parsed =
      (jsonDecode(responseBody) as List).cast<Map<String, dynamic>>();

  return parsed.map<TaskObject>((json) => TaskObject.fromJson(json)).toList();
}

Future<int> postTask(List<String> myList) async {
  Map<String, dynamic> myPostData = {};
  String? jwtToken = await storage.read(key: 'jwt');
  final user = jsonDecode(jwtToken!);
  Map<String, String> myHeaderPost = {};
  myHeaderPost.addEntries([
    const MapEntry('Content-Type', 'application/json'),
    MapEntry('Authorization', user["user_name"])
  ]);
  myPostData.addEntries([
    MapEntry('Status', myList[0]),
    MapEntry('Target', myList[1]),
    MapEntry('Destination', myList[2]),
    MapEntry('ProductValue', int.parse(myList[3])),
    MapEntry('ShipCost', int.parse(myList[4])),
    MapEntry('DeathLine', myList[5] + ":00"),
  ]);

  final response = await http.post(
    Uri.parse(taskPostPath),
    headers: myHeaderPost,
    body: jsonEncode(myPostData),
  );
  return response.statusCode;
}

Future<String> postAuthen(Map<String, dynamic> authenData) async {
  print("post data $authenData");
  final response = await http.post(
    Uri.parse(userAuthen),
    body: jsonEncode(authenData),
  );
  if (response.statusCode == 200) {
    // Request successful, handle response
    print('Response: ${response.body}');
    Map<String, dynamic> user = jsonDecode(response.body);
    await storage.write(key: 'jwt', value: jsonEncode(user));
    return "Success";
  } else {
    // Request failed, handle error
    print('Error: ${response.statusCode}');
    return "Failed";
  }
}
Future<String> postChangePwd (Map<String,String> newPwdData) async{
  String? jwtToken = await storage.read(key: 'jwt');
  final user = jsonDecode(jwtToken!);
  Map<String, String> myHeaderPost = {};
  myHeaderPost.addEntries([
    const MapEntry('Content-Type', 'application/json'),
    MapEntry('Authorization', user["user_name"])
  ]);
  final response = await http.post(Uri.parse(pwdChangePath),headers: myHeaderPost,body: jsonEncode(newPwdData));
  final responseInfor = response.body;
  return responseInfor;
}
