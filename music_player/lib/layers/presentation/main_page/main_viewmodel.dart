import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/utils/error_message_extension.dart';

import '../../domain/entity/song.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/playlist_repository.dart';
import '../../domain/repository/song_repository.dart';
import '../../domain/repository/user_repository.dart';

class MainViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final SongRepository songRepository;
  final PlaylistRepository playlistRepository;

  MainViewModel(
      {required this.userRepository,
      required this.songRepository,
      required this.playlistRepository});

  String errorMessage = '';

  Future<void> deleteCredentials() async {
    userRepository.deleteCredentials();
  }

  Future<bool> updateUser(User user) async {
    try {
      return userRepository.updateUser(user);
    } catch (e) {
      errorMessage = e.toString().extractErrorMessage();
      return false;
    }
  }
}
