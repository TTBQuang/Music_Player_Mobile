import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/usecase/register_user.dart';
import 'package:music_player/utils/error_message_extension.dart';

class SignUpViewModel extends ChangeNotifier{
  final RegisterUser _registerUser;

  String errorMessage = '';

  SignUpViewModel(this._registerUser);

  Future<void> registerUser(String username, String password) async {
    try {
      await _registerUser(username, password);
      errorMessage = '';
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().extractErrorMessage();
      notifyListeners();
    }
  }
}