import '../../domain/repository/user_repository.dart';
import '../source/network/user_service.dart';

class UserRepositoryImpl extends UserRepository{
  final UserService userService;

  UserRepositoryImpl(this.userService);

  @override
  Future<void> registerUser(String username, String password) async {
    await userService.registerUser(username, password);
  }
}