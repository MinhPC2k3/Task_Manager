import 'package:example_map/view_model/authenticate_viewModal.dart';
import 'package:example_map/views/screen/authentication_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //ChangeNotifierProvider có tác dụng tạo và truyền instance của lớp ChangeNotifier
      //đến widget con trường hợp này là MyLogin;
      home: ChangeNotifierProvider(
        create: (context) => AuthenticateAction(),
        child: const LoginScreen(),
      ),
      routes: {
        "/logout": (context) => ChangeNotifierProvider(
              create: (context) => AuthenticateAction(),
              child: const LoginScreen(),
            ),
      },
    );
  }
}

