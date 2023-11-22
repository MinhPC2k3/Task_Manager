import 'package:example_map/data/api_services.dart';
import 'package:example_map/model/account_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Tạo class ChangeNotifier
class AuthenticateAction extends ChangeNotifier{
  var userCheckClass = false;
  bool isLoading = false;
  TextEditingController userController = TextEditingController();
  bool showPassword = true;
  TextEditingController passwordController = TextEditingController();
  AccountModel myAccount = AccountModel();
  Future<void>loginUser() async{
    myAccount.userName=userController.text.toString();
    myAccount.userPassword = passwordController.text.toString();
    dynamic response = await postAuthen(myAccount.toJson());
    print(myAccount.toString());
    print("this is response ${myAccount.isAdmin}");
    if(response == "Success"){
      userCheckClass=true;
      print("setting new value");
    }
    //Gọi hàm notifyListeners để thông báo cho các widget có sự thay đổi cần rebuild
    isLoading = false;
    notifyListeners();
  }
  void passwordVisionable(){
    showPassword=!showPassword;
    notifyListeners();
  }
  
}
  
