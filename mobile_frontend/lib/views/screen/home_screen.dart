import 'package:auto_size_text/auto_size_text.dart';
import 'package:example_map/data/api_services.dart';
import 'package:example_map/view_model/add_task_viewModel.dart';
import 'package:example_map/views/screen/static_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../model/task_model.dart';
import '../component/list_task.dart';
import '../component/map.dart';
import 'add_task_screen.dart';
import 'setting_screen.dart';

class HomePage extends StatefulWidget {
  final bool isAdmin;

  const HomePage({super.key, required this.isAdmin});

  @override
  State<HomePage> createState() => _HomePageState();
}
var currentPageIndex = 0;
class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var checkAdmin = widget.isAdmin;
    final List<Widget> widgetOptions = [
      ChangeNotifierProvider(
          create: (context) => PostDataProvider(),
          child: MyHomePageScreen(myCheckAdmin: checkAdmin,),
      ),
      const StaticScreen(),
      const NotificationScreen(),
      // MyMap(),
    ];
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 1.0))),
        child: BottomNavigationBar(
          currentIndex: currentPageIndex,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.deepOrangeAccent,
          onTap: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.house,
              ),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.chartColumn),
              label: 'Quản lý',
            ),
            BottomNavigationBarItem(
              icon: Icon(FontAwesomeIcons.gear),
              label: 'Cài đặt',
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: widgetOptions,
      ),
    );
  }
}

class MyHomePageScreen extends StatefulWidget {
  final bool myCheckAdmin;

  const MyHomePageScreen({super.key, required this.myCheckAdmin});

  @override
  State<MyHomePageScreen> createState() => _MyHomePageScreenState();
}

class _MyHomePageScreenState extends State<MyHomePageScreen> {
  @override
  Widget build(BuildContext context) {
    bool myChecking = widget.myCheckAdmin;
    return Consumer<PostDataProvider>(builder: (context,listTask,child){
    return FutureBuilder<List<TaskObject>>(
        future: fetchTask(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child:
                  Text('An error has occurred! ${snapshot.error.toString()}'),
            );
          } else if (snapshot.hasData) {
            myTask = snapshot.data!;
            //ListenableBuilder(
            //                 listenable: myProvider,
            //                 builder:

                return Scaffold(
                  appBar: AppBar(
                    backgroundColor: Colors.deepOrangeAccent,
                    title: myChecking ? Text("Admin") : Text("Người dùng"),
                    actions: [
                      myChecking
                          ? Container(
                            margin: EdgeInsets.only(right: 15),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyHTestPage(addProviderClass: listTask,),
                                  ));
                            },
                            child: const Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Tạo task",
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      )
                          : Container(
                        margin: EdgeInsets.only(right: 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const MyMap()));
                            },
                            child: const Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Xem map",
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SafeArea(
                        minimum: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AutoSizeText(
                                  "Người thực hiện : Minh",
                                  style: TextStyle(
                                      color: Colors.deepOrangeAccent,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                  minFontSize: 14,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),

                                // const Icon(FontAwesomeIcons.chevronDown,color:  Colors.deepOrangeAccent,size: 17,)
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        // flex: 1,
                        child: Container(
                            decoration: const BoxDecoration(
                              color: Color.fromRGBO(255, 237, 224, 0.7),
                            ),
                            // padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            // child: taskList(),
                            child: ListCard(
                                iconName: taskIcon,
                                detailTitle: myDetailTitle,
                                myIcon: myViewIcon,
                                myTaskList: snapshot.data!,
                                enableDialog: true,
                                dialogAction: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const MyMap()));
                                })),
                      ),
                    ],
                  ),
                );

                // );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
    });
  }
}
// if (dialogContent != null) {
// showDialog(
// context: context,
// builder: (BuildContext context) =>
// AlertDialog(
// title: Text(myTaskList[index].taskTitle),
// content: SingleChildScrollView(
// child: ListBody(
// children: <Widget>[
// Text(dialogDetail![0]),
// ],
// ),
// ),
// actions: <Widget>[
// for (var value in dialogButton!) value,
// ],
// ),
// );
// }
