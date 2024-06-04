import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:music_player/layers/data/repository/playlist_repository_impl.dart';
import 'package:music_player/layers/data/repository/song_repository_impl.dart';
import 'package:music_player/layers/data/source/local/user_local_storage_impl.dart';
import 'package:music_player/layers/data/source/network/playlist_network_impl.dart';
import 'package:music_player/layers/data/source/network/song_network_impl.dart';
import 'package:music_player/layers/presentation/all_item_page/all_item_viewmodel.dart';
import 'package:music_player/layers/presentation/initial_screen/initial_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/main_viewmodel.dart';
import 'package:music_player/utils/list_factory.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import 'layers/data/repository/user_repository_impl.dart';
import 'layers/data/source/network/user_network_impl.dart';
import 'layers/presentation/playlist_detail_page/playlist_detail_viewmodel.dart';
import 'layers/presentation/sign_up_page/sign_up_viewmodel.dart';

Future<void> main() async {
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
  const storage = FlutterSecureStorage();
  final userLocalStorage = UserLocalStorageImpl(storage);
  final userNetwork = UserNetworkImpl();
  final songNetwork = SongNetworkImpl();
  final playlistNetwork = PlaylistNetworkImpl();

  final userRepository = UserRepositoryImpl(userNetwork, userLocalStorage);
  final songRepository = SongRepositoryImpl(songNetwork);
  final playlistRepository = PlaylistRepositoryImpl(playlistNetwork);

  final ListFactory listFactory = ListFactory(
      songRepository: songRepository, playlistRepository: playlistRepository);

  final signUpViewModel = SignUpViewModel(userRepository);
  final loginViewModel = LoginViewModel(userRepository);
  final mainViewModel = MainViewModel(
      userRepository: userRepository,
      songRepository: songRepository,
      playlistRepository: playlistRepository);
  final playlistDetailViewModel =
      PlaylistDetailViewModel(songRepository: songRepository);
  final allItemViewModel = AllItemViewModel(listFactory);



  runApp(MyApp(
    signUpViewModel: signUpViewModel,
    loginViewModel: loginViewModel,
    mainViewModel: mainViewModel,
    playlistDetailViewModel: playlistDetailViewModel,
    listFactory: listFactory,
    allItemViewModel: allItemViewModel,
  ));
}

class MyApp extends StatelessWidget {
  final SignUpViewModel signUpViewModel;
  final LoginViewModel loginViewModel;
  final MainViewModel mainViewModel;
  final PlaylistDetailViewModel playlistDetailViewModel;
  final ListFactory listFactory;
  final AllItemViewModel allItemViewModel;

  MyApp({
    super.key,
    required this.signUpViewModel,
    required this.loginViewModel,
    required this.mainViewModel,
    required this.playlistDetailViewModel,
    required this.listFactory,
    required this.allItemViewModel,
  });

  final SizeConfig sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);

    return MultiProvider(
      providers: [
        Provider<ListFactory>(create: (_) => listFactory),
        ChangeNotifierProvider<SignUpViewModel>.value(value: signUpViewModel),
        ChangeNotifierProvider<LoginViewModel>.value(value: loginViewModel),
        ChangeNotifierProvider<MainViewModel>.value(value: mainViewModel),
        ChangeNotifierProvider<AllItemViewModel>.value(value: allItemViewModel),
        ChangeNotifierProvider<PlaylistDetailViewModel>.value(
            value: playlistDetailViewModel),
      ],
      child: MaterialApp(
        title: 'Music Player',
        theme: ThemeData(
          // Define your theme here
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blue,
          hintColor: Colors.blueAccent,
        ),
        home: const InitialScreen(),
      ),
    );
  }
}
