import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_page/login_screen.dart';
import '../login_page/login_viewmodel.dart';
import '../main_page/main_screen.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const InitialScreen());
  }

  @override
  State<StatefulWidget> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final loginViewModel = context.read<LoginViewModel>();

    loginViewModel.getCredentials().then((data) {
      if (data['username'] != null && data['password'] != null) {
        loginViewModel.login(data['username']!, data['password']!).then((user) {
          if (user != null) {
            Navigator.of(context).pushReplacement(
              MainScreen.route(),
            );
          } else {
            Navigator.of(context).pushReplacement(
              LoginScreen.route(canNavigateBack: false),
            );
          }
        });
      } else {
        Navigator.of(context).pushReplacement(
          LoginScreen.route(canNavigateBack: false),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
