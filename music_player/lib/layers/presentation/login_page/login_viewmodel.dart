import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/repository/user_repository.dart';
import 'package:music_player/utils/error_message_extension.dart';

import '../../domain/entity/user.dart';

class LoginViewModel extends ChangeNotifier {
  final UserRepository userRepository;

  String errorMessage = '';
  User? user;

  LoginViewModel(this.userRepository);

  Future<User?> login(String username, String password) async {
    try {
      user = await userRepository.login(username, password);
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
    userRepository.saveCredentials(username, password);
  }

  Future<Map<String, String?>> getCredentials() async{
    return userRepository.getCredentials();
  }
}
