import 'package:auto_size_text/auto_size_text.dart';
import 'package:example_map/view_model/authenticate_viewModal.dart';
import 'package:example_map/view_model/picture_viewModal.dart';
import 'package:example_map/view_model/task_viewModel.dart';
import 'package:example_map/views/screen/static_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../data/fixed_data_display.dart';
import '../../model/task_model.dart';
import '../../view_model/map_viewModel.dart';
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
    var checkAdminValue = widget.isAdmin;
    final List<Widget> widgetOptions = [
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => TaskViewModal(),),
            ChangeNotifierProvider(
              create: (context) => PictureViewModal(),),
          ],
        child: HomePageScreen(
          checkAdmin: checkAdminValue,
        ),
      ),
      // const StaticScreen(),
      ChangeNotifierProvider(
        create: (context) => PictureViewModal(),
        child: const StaticScreen(),
      ),
      const SettingScreen(),
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

class HomePageScreen extends StatefulWidget {
  final bool checkAdmin;

  const HomePageScreen({super.key, required this.checkAdmin});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {

  @override
  Widget build(BuildContext context) {
    bool checkRole = widget.checkAdmin;
    return Consumer<TaskViewModal>(builder: (context, listTask, child) {
      print("From home");
      return FutureBuilder<List<TaskObject>>(
          future: listTask.getListTask(),
          builder: (context, snapshot) {
            print("from home future");
            if (snapshot.hasError) {
              return Center(
                child:
                    Text('An error has occurred! ${snapshot.error.toString()}'),
              );
            } else if (snapshot.hasData) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.deepOrangeAccent,
                  title: checkRole ? Text("Admin") : Text("Người dùng"),

                ),
                body: Stack(
                  children: [
                    Column(
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
                              child: Consumer<PictureViewModal>(
                                builder: (context,pictureViewModal,child){
                                  return ListCard(
                                    iconName: taskIcon,
                                    detailTitle: detailTitle,
                                    cardIcon: viewIcon,
                                    listTask: snapshot.data!,
                                    enableDialog: true,
                                    dialogAction: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChangeNotifierProvider(
                                                  create: (context) => MapViewModal(),
                                                  child: MapScreen(listTasks: snapshot.data!,)
                                              )));
                                    },
                                    cardButton: Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 15, 0),

                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepOrangeAccent,
                                        ),
                                        onPressed: () {
                                          pictureViewModal.openBottomModal(context);
                                        },
                                        child: Text("Thêm ảnh"),
                                      ),
                                    ),
                                    imageFile: pictureViewModal.listImgFile,
                                  );
                                },
                              ),
                          ),
                        ),
                      ]
                    ),
                    checkRole ?
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Container(
                        margin: const EdgeInsets.all(10),
                        child: FloatingActionButton(

                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddTaskScreen(
                                    addProviderClass: listTask,
                                  ),
                                ));
                          },
                          backgroundColor: Colors.deepOrangeAccent,
                          child: const Icon(Icons.add),
                        ),
                      )
                    ):
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: FloatingActionButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                            create: (context) => MapViewModal(),
                                            child: MapScreen(listTasks: snapshot.data!,)
                                        )
                                )
                            );
                          },
                          backgroundColor: Colors.deepOrangeAccent,
                          child: const Icon(Icons.map),
                        ),
                      ),
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