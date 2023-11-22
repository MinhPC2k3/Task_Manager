import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/change_password_viewModal.dart';

class DialogExample extends StatefulWidget {
  const DialogExample({super.key});

  @override
  State<DialogExample> createState() => _DialogExampleState();
}

class _DialogExampleState extends State<DialogExample> {
  late String jsonMessage;
  final textDialogKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<ChangePasswordProvider>(
        builder: (context, changePwd, child) {
      return TextButton(
        onPressed: () => showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: const Text('Đổi mật khẩu'),
            content: Form(
              key: textDialogKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          changePwd.checkIsPassword = true;
                        });
                      },
                      controller: changePwd.currentPassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), labelText: "Mật khẩu"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa điển thông tin';
                        } else if (!changePwd.checkIsPassword) {
                          return 'Sai mật khẩu';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      controller: changePwd.newPassword,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Mật khẩu mới"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa điển thông tin';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          setState(() {
                            changePwd.checkConfirmPwd = true;
                          });
                        });
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: changePwd.confirmPassword,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Xác nhận mật khẩu"),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Chưa điển thông tin';
                        } else if (!changePwd.checkConfirmPwd) {
                          return 'Mật khẩu không khớp';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Container(
                  height: 30,
                  width: 50,
                  child: const Center(
                    child: Text('Thoát'),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    changePwd.isLoading = true;
                  });
                  jsonMessage = await changePwd.changePassword();
                  print("this is message $jsonMessage");
                  if (textDialogKey.currentState!.validate()) {
                    if (jsonMessage == "success") {
                      changePwd.currentPassword.clear();
                      changePwd.newPassword.clear();
                      changePwd.confirmPassword.clear();
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, "/logout");
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Đổi mật khẩu thành công, Hãy đăng nhập lại')),
                      );
                    }
                  }
                },
                child: Container(
                  height: 30,
                  width: 50,
                  child: changePwd.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.blue,
                            ),
                          ))
                      : const Center(
                          child: Text('OK'),
                        ),
                ),
              ),
            ],
          ),
        ),
        child: const Text('Đổi mật khẩu'),
      );
    });
  }
}
