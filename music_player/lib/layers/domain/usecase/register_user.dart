import 'package:music_player/layers/domain/repository/user_repository.dart';

class RegisterUser {
  RegisterUser(this._repository);

  final UserRepository _repository;

  Future<void> call(String username, String password) async {
    await _repository.registerUser(username, password);
  }
}