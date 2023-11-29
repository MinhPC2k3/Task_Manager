//path /lib/views/screen/authentication_screen.dart
import 'package:example_map/views/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/authenticate_viewModal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    //Dùng Conumer với AuthenticateAction để chỉ ra kiểu của lớp muốn truy cập
    //package Provider không hỗ trợ nếu chỉ ra kiểu này
    return Consumer<AuthenticateAction>(
        //builder là một field bắt buộc gồm 3 tham số: e, ,
        //-Tham số đầu là context để chèn widget vào widgeTre
        //-Hai là tham số nhận instance ta đã truyền vào
        //-Cuối cùng tham số child là phần widget với tham số này sẽ không rebuild mỗi lần ChangeNotifier
        builder: (context, authChecking, child) {
      return Scaffold(
        appBar: AppBar(
          leading: null,
          title: Text("Đăng nhập"),
        ),
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    controller: authChecking.userController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Tên đăng nhập"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Tên đăng nhập trống';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextFormField(
                    obscureText: authChecking.showPassword,
                    controller: authChecking.passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Mật khẩu",
                      suffixIcon: GestureDetector(
                        onTap: () {
                          authChecking.passwordVisionable();
                        },
                        child: Icon(
                          authChecking.showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Mật khẩu trống';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 16.0),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          authChecking.isLoading = true;
                        });
                        //Sử dụng Provider.of để gọi hàm trong lớp ChangeNotifier và không cần dùng giá trị trong lớp
                        await Provider.of<AuthenticateAction>(context,
                                listen: false)
                            .handleLogin();
                        if (_formKey.currentState!.validate()) {
                          if (authChecking.userCheck == false) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Sai thông tin đăng nhập')),
                            );
                          } else {
                            if (authChecking.isAdmin) {
                              authChecking.userController.clear();
                              authChecking.passwordController.clear();
                              currentPageIndex = 0;
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      isAdmin: authChecking.userCheck,
                                    ),
                                  ));
                            } else {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      isAdmin: false,
                                    ),
                                  ));
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Hãy điền thông tin của bạn')),
                          );
                        }
                      },
                      child: Container(
                        height: 30,
                        width: 100,
                        child: authChecking.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                ))
                            : const Center(
                                child: Text('Đăng nhập'),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
