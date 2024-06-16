import 'package:music_player/layers/data/dto/song_dto.dart';
import 'package:music_player/layers/data/dto/user_dto.dart';
import 'package:music_player/layers/domain/entity/listen_history.dart';

class ListenHistoryDto extends ListenHistory{
  ListenHistoryDto({required super.id, required super.user, required super.song, required super.time});

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': (user as UserDto).toJson(),
    'song': SongDto.fromSong(song).toJson(),
    'time': time.toIso8601String(),
  };

  factory ListenHistoryDto.fromListenHistory(ListenHistory listenHistory) {
    return ListenHistoryDto(
        id: listenHistory.id,
        user: listenHistory.user,
        song: listenHistory.song,
        time: listenHistory.time
    );
  }
}