import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/repository/user_repository.dart';
import 'package:music_player/utils/error_message_extension.dart';

class SignUpViewModel extends ChangeNotifier{
  final UserRepository _userRepository;

  String errorMessage = '';

  SignUpViewModel(this._userRepository);

  Future<bool> registerUser(String username, String password) async {
    try {
      await _userRepository.registerUser(username, password);
      errorMessage = '';
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString().extractErrorMessage();
      notifyListeners();
      return false;
    }
  }
}