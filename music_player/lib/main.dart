import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/layers/domain/usecase/register_user.dart';
import 'package:music_player/layers/presentation/login_page/screen.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import 'layers/data/repository/user_repository_impl.dart';
import 'layers/data/source/network/user_service.dart';
import 'layers/presentation/sign_up_page/sign_up_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // final storageRef = FirebaseStorage.instance.ref();
  // final listResult = await storageRef.listAll();
  // String url = '';
  // for (var item in listResult.items) {
  //   url = await item.getDownloadURL();
  // }
  // final player = AudioPlayer();
  // await player.play(UrlSource(url));

  // Initialize dependencies
  final userService = UserService();
  final userRepository = UserRepositoryImpl(userService);
  final registerUser = RegisterUser(userRepository);
  final signUpViewModel = SignUpViewModel(registerUser);

  runApp(MyApp(signUpViewModel: signUpViewModel));
}

class MyApp extends StatelessWidget {
  final SignUpViewModel signUpViewModel;

  MyApp({required this.signUpViewModel});

  final SizeConfig sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SignUpViewModel>.value(value: signUpViewModel),
      ],
      child: MaterialApp(
        title: 'Your App Title',
        theme: ThemeData(
          // Define your theme here
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
