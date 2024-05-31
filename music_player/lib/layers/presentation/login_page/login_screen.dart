import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/base_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/main_screen.dart';
import 'package:music_player/layers/presentation/sign_up_page/sign_up_screen.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/user.dart';

class LoginScreen extends StatefulWidget {
  static Route<void> route({required bool canNavigateBack}) {
    return MaterialPageRoute(
      builder: (context) {
        return LoginScreen(canPop: canNavigateBack);
      },
    );
  }

  final bool canPop;

  const LoginScreen({super.key, required this.canPop});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(() =>
        Consumer<LoginViewModel>(builder: (context, viewModel, child) {
          void navigateBack() {
            viewModel.errorMessage = '';
            Navigator.pop(context);
          }

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: widget.canPop
                ? AppBar(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: navigateBack,
                    ),
                  )
                : null,
            body: SafeArea(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.h),
                    Image.asset('assets/image/logo.png',
                        width: SizeConfig.screenWidth * 5 / 7,
                        height: SizeConfig.screenHeight / 4),
                    SizedBox(height: 40.h),
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
                    SizedBox(height: 5.h),
                    Padding(
                      padding: EdgeInsets.only(right: 12.5.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Checkbox(
                            value: _isChecked,
                            onChanged: (bool? newValue) {
                              setState(() {
                                _isChecked = newValue ?? false;
                              });
                            },
                          ),
                          const Text(Strings.saveAccount),
                        ],
                      ),
                    ),
                    SizedBox(height: 5.h),
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
                          // login
                          String username = _usernameController.text;
                          String password = _passwordController.text;

                          if (username.isEmpty || password.isEmpty) {
                            // show error message
                            setState(() {
                              viewModel.errorMessage =
                                  Strings.usernameOrPasswordEmpty;
                            });
                          } else {
                            User? user =
                                await viewModel.login(username, password);
                            if (user != null) {
                              // save credentials if user check save account
                              if (_isChecked) {
                                viewModel.saveCredentials(username, password);
                              }

                              if (widget.canPop) {
                                // return to current screen
                                navigateBack();
                              } else {
                                goToMainPage();
                              }
                            }
                          }
                        },
                        child: Text(
                          Strings.login,
                          style: TextStyle(fontSize: 15.w),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (!widget.canPop)
                      SizedBox(
                        width: SizeConfig.screenWidth - 25.w,
                        height: SizeConfig.screenHeight / 16,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary),
                          onPressed: goToMainPage,
                          child: Text(
                            Strings.later,
                            style: TextStyle(fontSize: 15.w),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: EdgeInsets.only(bottom: 10.h),
                            child: GestureDetector(
                              onTap: goToSignUpPage,
                              child: Text(
                                Strings.signUp,
                                style: TextStyle(
                                  fontSize: 15.w,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.blue,
                                ),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  void goToMainPage() {
    final route = MainScreen.route();
    Navigator.of(context).pushReplacement(route);
  }

  void goToSignUpPage() {
    final route = SignUpScreen.route();
    Navigator.of(context).push(route);
  }
}
