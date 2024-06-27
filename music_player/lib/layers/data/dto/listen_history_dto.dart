import 'package:music_player/layers/data/dto/song_dto.dart';
import 'package:music_player/layers/data/dto/user_dto.dart';
import 'package:music_player/layers/domain/entity/listen_history.dart';

import '../../domain/entity/song.dart';
import '../../domain/entity/user.dart';

class ListenHistoryDto {
  int? id;
  UserDto user;
  SongDto song;
  DateTime time;

  ListenHistoryDto({required this.id, required this.user, required this.song, required this.time});

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user.toJson(),
    'song': song.toJson(),
    'time': time.toIso8601String(),
  };

  factory ListenHistoryDto.fromListenHistory(ListenHistory listenHistory) {
    return ListenHistoryDto(
        id: listenHistory.id,
        user: UserDto.fromUser(listenHistory.user),
        song: SongDto.fromSong(listenHistory.song),
        time: listenHistory.time
    );
  }
}