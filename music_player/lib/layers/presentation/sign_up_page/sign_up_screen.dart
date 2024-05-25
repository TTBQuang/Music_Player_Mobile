import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/sign_up_page/sign_up_viewmodel.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../utils/strings.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) {
        // final useCase = context.read<RegisterUser>();
        //
        // return ChangeNotifierProvider(
        //   create: (_) => SignUpViewModel(useCase),
        //   child: const SignUpScreen(),
        // );
        return const SignUpScreen();
      },
    );
  }

  @override
  State<StatefulWidget> createState() {
    return _SignUpState();
  }
}

class _SignUpState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpViewModel>(builder: (context, viewModel, child) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SafeArea(
            child: Center(
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Text(Strings.createNewAccount, style: TextStyle(fontSize: 22.w)),
              SizedBox(height: 50.h),
              SizedBox(
                width: SizeConfig.screenWidth - 25.w,
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: Strings.username,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: SizeConfig.screenWidth - 25.w,
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: Strings.password,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Visibility(
                visible: viewModel.errorMessage.isNotEmpty,
                child: Text(
                  viewModel.errorMessage,
                  style: const TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              SizedBox(
                width: SizeConfig.screenWidth - 25.w,
                height: SizeConfig.screenHeight / 16,
                child: FilledButton(
                  onPressed: () async {
                    String username = _usernameController.text;
                    String password = _passwordController.text;

                    if (username.isEmpty || password.isEmpty) {
                      setState(() {
                        viewModel.errorMessage = Strings.usernameOrPasswordEmpty;
                      });
                    } else {
                      await viewModel.registerUser(username, password);
                    }
                  },
                  child: Text(
                    Strings.signUp,
                    style: TextStyle(fontSize: 15.w),
                  ),
                ),
              ),
            ],
          ),
        )),
      );
    });
  }
}
