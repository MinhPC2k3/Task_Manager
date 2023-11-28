import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/change_password_viewModal.dart';
import '../component/changePwd_Dialog.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SafeArea(
      child: Column(
        children: [
          ChangeNotifierProvider(
            create: (context) => ChangePasswordProvider(),
            child: DialogExample(),
          ),
          ElevatedButton(
            onPressed: () => {
              Navigator.pushReplacementNamed(context, "/logout")
            },
            child: Text("Đăng xuất"),
          ),
        ],
      ),
    ));
  }
}
