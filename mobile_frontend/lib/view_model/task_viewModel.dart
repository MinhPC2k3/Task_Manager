import 'package:flutter/cupertino.dart';

import '../data/api_services.dart';
import '../model/task_model.dart';
import '../views/screen/add_task_screen.dart';
import '../data/fixed_data_display.dart';

var emptyText = '';

class TaskViewModal extends ChangeNotifier{
  
  List  listTextController =[TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController(),TextEditingController()];
  var errorCode = 0;
  int? postStatus;
  List<TaskObject> listTaskObject =[];
  TaskRepository taskRepository = TaskRepository();

  Future<List<TaskObject>> getListTask () async{
    listTaskObject = await taskRepository.getListTask();
    return listTaskObject;
  }

  getErrorText (String controller , int inputIndex) {
    if (controller.isEmpty) {
      return 'Can\'t be empty';
    }
    if (regexCheck[inputIndex].hasMatch(controller) == false) {
      return InputError[inputIndex];
    }
    if(regexCheckLength.hasMatch(controller) == false){
      return 'Input can\'t be long or short ';
    }
    // return null if the text is valid
    return null;
  }

  void checkText(BuildContext context) {
    if (listTextController[0]?.value.text.isEmpty ||
        listTextController[1]?.value.text.isEmpty ||
        listTextController[2]?.value.text.isEmpty ||
        listTextController[3]?.value.text.isEmpty ||
        listTextController[4]?.value.text.isEmpty ||
        listTextController[5]?.value.text.isEmpty) {
        errorCode = 1;
    } else {
      int tempVar = 0;
      for (int i = 0; i < 6; i++) {
        if (getErrorText(listTextController[i]?.value.text, i) != null) {
          tempVar++;
        }
      }
      if (tempVar != 0){
          errorCode = 2;
      } else{
        postCreateTask(context);
      }
    }
  }

  void postCreateTask (BuildContext context) async{
    List<String> tempList=[];
    for(int i=0;i<6;i++) {
      tempList.add(listTextController[i]!.value.text.toString());
    }
    int postStatus = await taskRepository.postTaskRequest(tempList);
    if(postStatus == 200){
      for (var element in listTextController) {
        element.clear();
      }
      Navigator.pop(context);
      notifyListeners();
    }
  }

}