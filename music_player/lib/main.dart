import 'package:audio_service/audio_service.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:music_player/layers/data/repository/comment_repository_impl.dart';
import 'package:music_player/layers/data/repository/listen_history_repository_impl.dart';
import 'package:music_player/layers/data/repository/playlist_repository_impl.dart';
import 'package:music_player/layers/data/repository/search_history_repository_impl.dart';
import 'package:music_player/layers/data/repository/singer_repository_impl.dart';
import 'package:music_player/layers/data/repository/song_repository_impl.dart';
import 'package:music_player/layers/data/source/local/user_local_storage_impl.dart';
import 'package:music_player/layers/data/source/network/comment_network_impl.dart';
import 'package:music_player/layers/data/source/network/listen_history_network_impl.dart';
import 'package:music_player/layers/data/source/network/playlist_network_impl.dart';
import 'package:music_player/layers/data/source/network/search_history_network_impl.dart';
import 'package:music_player/layers/data/source/network/singer_network_impl.dart';
import 'package:music_player/layers/data/source/network/song_network_impl.dart';
import 'package:music_player/layers/presentation/all_item_page/all_item_viewmodel.dart';
import 'package:music_player/layers/presentation/initial_screen/initial_screen.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/main_page/main_viewmodel.dart';
import 'package:music_player/layers/presentation/song_detail_page/song_detail_viewmodel.dart';
import 'package:music_player/services/audio_handler.dart';
import 'package:music_player/services/audio_manager.dart';
import 'package:music_player/utils/constants.dart';
import 'package:music_player/utils/playlist_factory.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'layers/data/repository/user_repository_impl.dart';
import 'layers/data/source/network/user_network_impl.dart';
import 'layers/presentation/playlist_detail_page/playlist_detail_viewmodel.dart';
import 'layers/presentation/search_page/search_viewmodel.dart';
import 'layers/presentation/sign_up_page/sign_up_viewmodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MediaStore.ensureInitialized();
  MediaStore.appFolder = "MediaStorePlugin";

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelKey: Constants.channelKey,
            channelName: 'Music Player notifications',
            channelDescription: 'Notification channel for Music Player')
      ],
      debug: true);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependencies
  const storage = FlutterSecureStorage();
  final userLocalStorage = UserLocalStorageImpl(storage);
  final userNetwork = UserNetworkImpl();
  final songNetwork = SongNetworkImpl();
  final playlistNetwork = PlaylistNetworkImpl();
  final searchHistoryNetwork = SearchHistoryNetworkImpl();
  final singerNetwork = SingerNetworkImpl();
  final listenHistoryNetwork = ListenHistoryNetworkImpl();
  final commentNetwork = CommentNetworkImpl();

  final userRepository = UserRepositoryImpl(userNetwork, userLocalStorage);
  final songRepository = SongRepositoryImpl(songNetwork);
  final playlistRepository = PlaylistRepositoryImpl(playlistNetwork);
  final searchHistoryRepository =
      SearchHistoryRepositoryImpl(searchHistoryNetwork);
  final singerRepository = SingerRepositoryImpl(singerNetwork);
  final listenHistoryRepository =
      ListenHistoryRepositoryImpl(listenHistoryNetwork);
  final commentRepository = CommentRepositoryImpl(commentNetwork);

  final PlaylistFactory listFactory = PlaylistFactory(
      songRepository: songRepository, playlistRepository: playlistRepository);

  final signUpViewModel = SignUpViewModel(userRepository);
  final loginViewModel = LoginViewModel(userRepository);
  final mainViewModel = MainViewModel(
      userRepository: userRepository, songRepository: songRepository);
  final playlistDetailViewModel =
      PlaylistDetailViewModel(songRepository: songRepository);
  final allItemViewModel = AllItemViewModel(listFactory);
  final songDetailViewModel = SongDetailViewModel(
      songRepository: songRepository,
      listenHistoryRepository: listenHistoryRepository,
      commentRepository: commentRepository);
  final searchViewModel = SearchViewModel(
      songRepository: songRepository,
      searchHistoryRepository: searchHistoryRepository,
      singerRepository: singerRepository,
      playlistRepository: playlistRepository);

  final audioHandler = await initAudioService();
  final audioManager = AudioManager(audioHandler);

  runApp(MultiProvider(
    providers: [
      Provider<AudioHandler>(create: (_) => audioHandler),
      Provider<AudioManager>(create: (_) => audioManager),
      Provider<PlaylistFactory>(create: (_) => listFactory),
      ChangeNotifierProvider<SignUpViewModel>.value(value: signUpViewModel),
      ChangeNotifierProvider<LoginViewModel>.value(value: loginViewModel),
      ChangeNotifierProvider<MainViewModel>.value(value: mainViewModel),
      ChangeNotifierProvider<AllItemViewModel>.value(value: allItemViewModel),
      ChangeNotifierProvider<PlaylistDetailViewModel>.value(
          value: playlistDetailViewModel),
      ChangeNotifierProvider<SongDetailViewModel>.value(
          value: songDetailViewModel),
      ChangeNotifierProvider<SearchViewModel>.value(value: searchViewModel),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    super.key,
  });

  final SizeConfig sizeConfig = SizeConfig();

  @override
  Widget build(BuildContext context) {
    sizeConfig.init(context);

    return MaterialApp(
      title: Strings.appName,
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
    );
  }
}
