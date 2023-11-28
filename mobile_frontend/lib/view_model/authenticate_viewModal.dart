import 'package:example_map/data/api_services.dart';
import 'package:example_map/model/account_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Tạo class ChangeNotifier
class AuthenticateAction extends ChangeNotifier{

  bool showPassword = true;
  var userCheck = false;
  bool isLoading = false;
  bool isAdmin = false;
  TextEditingController userController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  AccountRepository accountRepository = AccountRepository();

  Future<void> handleLogin() async{
    accountRepository.setAccount(userController.text.toString(), passwordController.text.toString());
    String loginStatus = await accountRepository.loginUser();
      if(loginStatus == "Success"){
        isAdmin= accountRepository.myAccount.isAdmin!;
        userCheck=true;
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
  
