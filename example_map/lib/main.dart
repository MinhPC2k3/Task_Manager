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
        child: const MyLogin(),
      ),
      routes: {
        "/logout": (context) => ChangeNotifierProvider(
              create: (context) => AuthenticateAction(),
              child: const MyLogin(),
            ),
      },
    );
  }
}

// return ListenableBuilder(
// listenable: myChecking,
// builder: (BuildContext context, Widget? child) {
// return Scaffold(
// appBar: AppBar(
// title: Text("Đăng nhập"),
// ),
// body: Form(
// key: _formKey,
// child: Padding(
// padding:
// const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 8, vertical: 16),
// child: TextFormField(
// controller: userController,
// decoration: const InputDecoration(
// border: OutlineInputBorder(),
// labelText: "Tên đăng nhập"),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'Tên đăng nhập trống';
// }
// return null;
// },
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 8, vertical: 16),
// child: TextFormField(
// obscureText: _showPassword,
// controller: passwordController,
// decoration: InputDecoration(
// border: OutlineInputBorder(),
// labelText: "Mật khẩu",
// suffixIcon: GestureDetector(
// onTap: () {
// setState(() => _showPassword = !_showPassword);
// },
// child: Icon(
// _showPassword
// ? Icons.visibility
//     : Icons.visibility_off,
// color: Colors.grey,
// ),
// ),
// ),
// // const InputDecoration(
// //     border: OutlineInputBorder(), labelText: "Mật khẩu"),
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'Mật khẩu trống';
// }
// return null;
// },
// ),
// ),
// Padding(
// padding: const EdgeInsets.symmetric(
// horizontal: 8, vertical: 16.0),
// child: Center(
// child: ElevatedButton(
// onPressed: () async {
// await myChecking.loginUser();
// if (_formKey.currentState!.validate()) {
// if (userCheck == false) {
// ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(
// content: Text('Sai thông tin đăng nhập')),
// );
// } else {
// if (userController.text == "admin") {
// Navigator.pushReplacement(
// context,
// MaterialPageRoute(
// builder: (context) => HomePage(
// isAdmin: true,
// ),
// ));
// } else {
// Navigator.pushReplacement(
// context,
// MaterialPageRoute(
// builder: (context) => HomePage(
// isAdmin: false,
// ),
// ));
// }
// }
// } else {
// ScaffoldMessenger.of(context).showSnackBar(
// const SnackBar(
// content:
// Text('Hãy điền thông tin của bạn')),
// );
// }
// },
// child: const Text('Đăng nhập'),
// ),
// ),
// ),
// ],
// ),
// ),
// ),
// );
// });
