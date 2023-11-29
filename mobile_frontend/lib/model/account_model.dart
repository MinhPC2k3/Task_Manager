//path /lib/model/account_model.dart
//Tạo object AccountMidel và các field của nó
import '../data/api_services.dart';

class AccountModel{
  String? userName;
  String? userPassword;
  bool? isAdmin;

  AccountModel(
      { this.userName,
         this.userPassword,
        this.isAdmin});

  //Hàm giúp chuyển class sang dạng JSON để liên kết với api
  Map<String,String> toJson (){
    Map<String,String> objectField =  <String,String>{};
    bool temp;
    if(userName == "admin"){
      isAdmin=true;
    }else {
      isAdmin= false;
    }
    objectField['UserName']= userName!;
    objectField['Password']= userPassword!;
    return objectField;
  }
}

class AccountRepository{
  AccountModel account = AccountModel();

  void setAccount(String userName,String userPassword){
    account.userName = userName;
    account.userPassword = userPassword;
  }

  Future<String> loginUser() async{
    dynamic response = await postAuthen(account.toJson());
    print(account.toString());
    print("this is response ${account.isAdmin}");
    if(response == "Success"){
      print("setting new value");
      return "Success";
    }
    return "Failed";
  }

  Future<String> logOut() async{
    dynamic response = await logOutUser();
    print("respone logout $response");
    if(response == "Success"){
      print("setting new value");
      return "Success";
    }
    return "Failed";
  }
}