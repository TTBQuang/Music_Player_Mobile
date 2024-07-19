import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/entity/singer.dart';
import 'package:music_player/layers/domain/entity/uploaded_song.dart';
import 'package:music_player/layers/domain/repository/genre_repository.dart';
import 'package:music_player/layers/domain/repository/singer_repository.dart';
import 'package:music_player/utils/error_message_extension.dart';

import '../../domain/entity/genre.dart';
import '../../domain/entity/song.dart';
import '../../domain/entity/user.dart';
import '../../domain/repository/song_repository.dart';
import '../../domain/repository/user_repository.dart';

class MainViewModel extends ChangeNotifier {
  final UserRepository userRepository;
  final SongRepository songRepository;
  final SingerRepository singerRepository;
  final GenreRepository genreRepository;

  MainViewModel(
      {required this.userRepository,
      required this.songRepository,
      required this.singerRepository,
      required this.genreRepository});

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

  Future<List<Song>> getFavoriteSongs(int userId) {
    return songRepository.getFavoriteSong(userId);
  }

  Future<void> removeSongFromFavorite(int songId, int userId) async {
    songRepository.removeSongFromFavorite(songId, userId);
  }

  Future<List<Singer>> getAllSingers() async {
    return singerRepository.getAllSingers();
  }

  Future<List<Genre>> getAllGenres() async {
    return genreRepository.getAllGenres();
  }

  Future<String> upload(String filePath, String destination) async {
    return await songRepository.upload(filePath, destination);
  }

  Future<bool> uploadSong(UploadedSong song) async {
    return await songRepository.uploadSong(song);
  }
}
