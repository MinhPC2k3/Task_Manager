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
        isAdmin= accountRepository.account.isAdmin!;
        userCheck=true;
        print("setting new value");
      }
      //Gọi hàm notifyListeners để thông báo cho các widget có sự thay đổi cần rebuild
      isLoading = false;
      notifyListeners();
  }

  Future<void> handleLogOut(BuildContext context) async{
    String logOutStatus = await accountRepository.logOut();
    print("logout status $logOutStatus");
    if(logOutStatus == "Success"){
      Navigator.pushReplacementNamed(context, "/logout");
      notifyListeners();
    }else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to logOut'))
      );
      notifyListeners();
    }
  }

  void passwordVisionable(){
    showPassword=!showPassword;
    notifyListeners();
  }
  
}
  
