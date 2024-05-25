import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/sign_up_page/sign_up_screen.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 20.h),
              Image.asset('assets/image/logo.png',
                  width: SizeConfig.screenWidth * 5 / 7,
                  height: SizeConfig.screenHeight / 4),
              SizedBox(height: 20.h),
              Text(
                Strings.appName,
                style: TextStyle(fontSize: 18.w),
              ),
              SizedBox(height: 50.h),
              SizedBox(
                width: SizeConfig.screenWidth - 25.w,
                child: TextField(
                  controller: _emailController,
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
              SizedBox(
                width: SizeConfig.screenWidth - 25.w,
                height: SizeConfig.screenHeight / 16,
                child: FilledButton(
                  onPressed: () {
                    String email = _emailController.text;
                    String password = _passwordController.text;

                  },
                  child: Text(
                    Strings.login,
                    style: TextStyle(fontSize: 15.w),
                  ),
                ),
              ),
              Expanded(
                // Widget Expanded để đảm bảo dòng Text nằm ở bottom màn hình
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: GestureDetector(
                        onTap: _goToSignUpPage,
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
  }

  void _goToSignUpPage() {
    final route = SignUpScreen.route();
    Navigator.of(context).push(route);
  }
}
