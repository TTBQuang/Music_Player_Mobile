import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/repository/user_repository.dart';
import 'package:music_player/utils/error_message_extension.dart';

import '../../domain/entity/user.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository _userRepository;

  String errorMessage = '';
  User? user;

  LoginViewModel(this._userRepository);

  Future<User?> login(String username, String password) async {
    try {
      user = await _userRepository.login(username, password);
      errorMessage = '';
      notifyListeners();
      return user;
    } catch (e) {
      errorMessage = e.toString().extractErrorMessage();
      notifyListeners();
      return null;
    }
  }

  Future<void> saveCredentials(String username, String password) async {
    _userRepository.saveCredentials(username, password);
  }

  Future<Map<String, String?>> getCredentials() async{
    return _userRepository.getCredentials();
  }
}
