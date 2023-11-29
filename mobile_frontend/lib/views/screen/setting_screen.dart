import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../view_model/authenticate_viewModal.dart';
import '../../view_model/change_password_viewModal.dart';
import '../component/changePwd_Dialog.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
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
                AuthenticateAction().handleLogOut(context),
              },
              child: Text("Đăng xuất"),
            ),
          ],
        ),
      ));
  }
}
