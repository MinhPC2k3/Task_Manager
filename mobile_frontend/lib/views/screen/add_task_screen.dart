import 'dart:async';
import 'dart:convert';

import 'package:example_map/view_model/task_viewModel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../data/api_services.dart';
import '../../data/fixed_data_display.dart';
final _formKey = GlobalKey<FormState>();

class AddTaskScreen extends StatefulWidget {
  final TaskViewModal addProviderClass;
  const AddTaskScreen({super.key,required this.addProviderClass});

  @override
  State<AddTaskScreen> createState() => AddTaskScreenState();
}

class AddTaskScreenState extends State<AddTaskScreen>{
  @override
  Widget build(BuildContext context) {
    print("from add task");
    TaskViewModal tempProvider = widget.addProviderClass;
    var tWidth = MediaQuery.of(context).size.width * 0.3;
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Colors.deepOrangeAccent,
        title: Text("Tạo task mới"),
        // actions: [
        //   Container(
        //     padding: EdgeInsets.only(right: 10),
        //     child: ElevatedButton(
        //       style: TextButton.styleFrom(
        //         backgroundColor: Colors.amber, // Text Color
        //         elevation: 0,
        //       ),
        //       child: Text('Lưu', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w400),),
        //       onPressed: () {
        //         tempProvider.checkText(context);
        //
        //       },
        //     ),
        //   ),
        // ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          tempProvider.checkText(context);
        },
        backgroundColor: Colors.deepOrangeAccent,
        child: const Icon(Icons.done),

      ),
      body:  ListView.separated(
        key: _formKey,
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (BuildContext context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width * 1,
            height: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 10),
                      width: tWidth,
                      child: Text(titleTextFiled[index],
                        style: TextStyle(fontSize: 15),),
                    ),
                    SizedBox(
                      width: tWidth * 2,
                      child: TextFormField(
                        minLines: 1,
                        maxLines: 1,
                        // Allow unlimited lines
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.newline,
                        onChanged: (text) => setState(() => emptyText),
                        controller: tempProvider.listTextController[index],
                        obscureText: false,
                        expands: false,
                        decoration: InputDecoration(
                          hintText: InputFieldAddService[index],
                          errorText: tempProvider.errorCode == 0 ? null : tempProvider.getErrorText(tempProvider.listTextController[index]?.value.text, index),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) => Divider(),
        itemCount: InputFieldAddService.length,
      ),
    );
  }
}
