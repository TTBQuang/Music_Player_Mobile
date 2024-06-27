import 'package:flutter/cupertino.dart';
import 'package:music_player/layers/domain/entity/comment.dart';
import 'package:music_player/layers/domain/entity/listen_history.dart';

import '../../domain/entity/playlist.dart';
import '../../domain/entity/song.dart';
import '../../domain/repository/comment_repository.dart';
import '../../domain/repository/listen_history_repository.dart';
import '../../domain/repository/song_repository.dart';

class SongDetailViewModel extends ChangeNotifier {
  Playlist? playlist;
  SongRepository songRepository;
  ListenHistoryRepository listenHistoryRepository;
  CommentRepository commentRepository;

  SongDetailViewModel(
      {required this.songRepository,
      required this.listenHistoryRepository,
      required this.commentRepository});

  Future<void> getALlSongsInPlaylist(Playlist? pl) async {
    if (pl != null) {
      List<Song> songs =
          await songRepository.getSongsInPlaylist(pl.id, 0, pl.totalItems);
      playlist = pl.clone();
      playlist?.songList.clear();
      playlist?.songList.addAll(songs);
    }
  }

  Future<void> saveListenHistory(ListenHistory listenHistory) async {
    listenHistoryRepository.saveListenHistory(listenHistory);
  }

  Future<Song> getSongById(int songId, int? userId) {
    return songRepository.getSongById(songId, userId);
  }

  Future<void> likeSong(int songId, int userId) {
    return songRepository.likeSong(songId, userId);
  }

  Future<void> unlikeSong(int songId, int userId) {
    return songRepository.unlikeSong(songId, userId);
  }

  Future<void> saveSong(int songId, int userId) {
    return songRepository.saveSong(songId, userId);
  }

  Future<void> removeSongFromFavorite(int songId, int userId) {
    return songRepository.removeSongFromFavorite(songId, userId);
  }

  Future<List<Comment>> getAllComments(int songId, int? userId) {
    return commentRepository.getAllComments(songId, userId);
  }

  Future<void> addComment(Comment comment) async {
    await commentRepository.addComment(comment);
  }

  Future<List<Comment>> getCommentsByResponseId(int responseId, int? userId) {
    return commentRepository.getCommentsByResponseId(responseId, userId);
  }

  Future<void> updateComment(Comment comment) async {
    await commentRepository.updateComment(comment);
  }

  Future<void> likeComment(int commentId, int userId) {
    return commentRepository.likeComment(commentId, userId);
  }

  Future<void> unlikeComment(int commentId, int userId) {
    return commentRepository.unlikeComment(commentId, userId);
  }

  Future<void> deleteComment(int commentId) async {
    await commentRepository.deleteComment(commentId);
  }
}
