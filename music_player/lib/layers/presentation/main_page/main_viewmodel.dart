import 'package:flutter/cupertino.dart';

import '../../domain/entity/user.dart';
import '../../domain/repository/user_repository.dart';

class MainViewModel extends ChangeNotifier{
  final UserRepository userRepository;

  MainViewModel(this.userRepository);

  Future<void> logout() async {
    userRepository.deleteCredentials();
  }
}