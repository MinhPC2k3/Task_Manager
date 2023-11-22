import 'dart:convert';

import 'package:example_map/data/api_services.dart';
import 'package:flutter/material.dart';

class ChangePasswordProvider extends ChangeNotifier{
  TextEditingController currentPassword =  TextEditingController();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  bool isLoading = false;
  bool checkIsPassword = false;
  Map<String,String> jsonPost = {};
  bool checkConfirmPwd = true;
  late String message;
  late String statusChange;
  Future<String> changePassword() async{
    if(newPassword.text != confirmPassword.text){
      print("Wrong confirm password");
      checkConfirmPwd=false;
      isLoading=false;
      notifyListeners();
      return "Wrong confirm password";
    }else{
      checkConfirmPwd = true;
      jsonPost.addEntries([
        MapEntry("Password", currentPassword.text),
        MapEntry("NewPassword", newPassword.text)
      ]);
      statusChange= await postChangePwd(jsonPost);
      Map<String,dynamic> temp = jsonDecode(statusChange);
      print("This is status changePwd ${temp["Message"]}");
      if(temp["Message"]!="success"){
        checkIsPassword=false;
      }else{
        checkIsPassword = true;
      }
      isLoading=false;
      notifyListeners();
      return temp["Message"];
    }
  }
}
