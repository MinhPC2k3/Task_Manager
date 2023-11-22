//path /lib/model/account_model.dart
//Tạo object AccountMidel và các field của nó
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