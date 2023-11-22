import 'package:flutter/cupertino.dart';

import '../data/api_services.dart';
import '../views/screen/add_task_screen.dart';

var myText = '';
// PostDataProvider myProvider = PostDataProvider();
class PostDataProvider extends ChangeNotifier{
  getErrorText (String myController , int myInputIndex) {
    if (myController.isEmpty) {
      return 'Can\'t be empty';
    }
    if (regexCheck[myInputIndex].hasMatch(myController) == false) {
      return InputError[myInputIndex];
    }
    if(regexCheckLength.hasMatch(myController) == false){
      return 'Input can\'t be long or short ';
    }
    // return null if the text is valid
    return null;
  }
  var InputError = [
    "Không thể có ký tự đặc biệt",
    "Không thể có ký tự đặc biệt",
    "Không thể có ký tự đặc biệt",
    "Tiền hàng không thể có số",
    "Phí ship không thể có số",
    "Không đúng định dạng dd/MM/yyyy hh/mm",
  ];
  var myErrorChecking = 0;

  var regexCheckLength = RegExp(r"^.{2,45}$");
  var regexCheck = [
    RegExp(
        r"^([A-Za-z\s0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]*)$"),
    RegExp(
        r"^([A-Za-z\s0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ]*)$"),
    RegExp(
        r"^([A-Za-z\s0-9ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ,]*)$"),
    RegExp(r"^([0-9]*)$"),
    RegExp(r"^([0-9]*)$"),
    RegExp(
        r"^\d{4}[-](0[1-9]|1[0-2])[-](0[1-9]|[12][0-9]|3[01]) (0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$"),
  ];
  List  myListController =[TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()];
  var InputFieldAddService = [
    'Trạng thái nhiệm vụ',
    'Mục tiêu nhiệm vụ',
    'Địa chỉ đến',
    'Nhập tiền hàng',
    'Nhập phí ship',
    'Nhập thời gian kết thúc'
  ];

  var titleTextFiled = [
    'Trang thái',
    'Nhiệm vụ',
    'Địa chỉ',
    'Tiền hàng',
    'Phí ship',
    'Kết thúc',
  ];
  int? postStatus;
  void checkText(BuildContext context){
    if (myListController[0]?.value.text.isEmpty ||
        myListController[1]?.value.text.isEmpty ||
        myListController[2]?.value.text.isEmpty ||
        myListController[3]?.value.text.isEmpty ||
        myListController[4]?.value.text.isEmpty ||
        myListController[5]?.value.text.isEmpty) {
        myErrorChecking = 1;
    } else {
      int tempVar = 0;
      for (int i = 0; i < 6; i++) {
        if (getErrorText(myListController[i]?.value.text, i) != null) {
          tempVar++;
        }
      }
      if (tempVar != 0){
          myErrorChecking = 2;
      } else{
        postFunction(context);
      }
    }
  }
  void postFunction (BuildContext context) async{
    List<String> tempList=[];
    for(int i=0;i<6;i++) {
      tempList.add(myListController[i]!.value.text.toString());
    }
    postStatus=await postTask(tempList);
    if(postStatus == 200){
      for (var element in myListController) {
        element.clear();
      }
      Navigator.pop(context);
      notifyListeners();
    }

  }
}