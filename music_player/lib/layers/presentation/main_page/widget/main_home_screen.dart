import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/toast_util.dart';
import '../../../domain/entity/user.dart';
import '../../login_page/login_screen.dart';
import '../../login_page/login_viewmodel.dart';
import '../main_viewmodel.dart';

class MainHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LoginViewModel loginViewModel = Provider.of<LoginViewModel>(context);
    MainViewModel viewModel = Provider.of<MainViewModel>(context);
    User? user = loginViewModel.user;

    return Center(
      child: Column(
        children: [
          FilledButton(
              onPressed: () {
                ToastUtil.showToast("message");
              },
              child: Text(user?.username ?? '123')),
          FilledButton(
              onPressed: () {
                if (user != null) {
                  viewModel.logout().then((_) {
                    loginViewModel.user = null;
                    Navigator.of(context).pushAndRemoveUntil(
                      LoginScreen.route(popToPreviousScreen: false),
                          (Route<dynamic> route) => false,
                    );
                  });
                } else {
                  final route = LoginScreen.route(popToPreviousScreen: true);
                  Navigator.of(context).push(route);
                }
              },
              child: const Text("User")),
          if (user?.authority == 'admin')
            FilledButton(
              onPressed: () {
                viewModel.logout().then((_) {
                  loginViewModel.user = null;
                  Navigator.of(context).pushAndRemoveUntil(
                    LoginScreen.route(popToPreviousScreen: false),
                        (Route<dynamic> route) => false,
                  );
                });
              },
              child: const Text("Admin"),
            ),
        ],
      ),
    );
  }
}