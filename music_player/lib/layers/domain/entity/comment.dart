import 'package:music_player/layers/data/dto/comment_dto.dart';
import 'package:music_player/layers/domain/entity/song.dart';
import 'package:music_player/layers/domain/entity/user.dart';

class Comment {
  int? id;
  int? responseToId;
  User user;
  Song song;
  DateTime time;
  String content;
  int numberOfUsersLiked;
  bool isUserLiked;

  Comment(
      {required this.id,
      required this.responseToId,
      required this.user,
      required this.song,
      required this.time,
      required this.content,
      required this.numberOfUsersLiked,
      required this.isUserLiked});

  factory Comment.fromCommentDto(CommentDto commentDto, int? userId) {
    bool isLiked = commentDto.usersLiked.any((userDto) => userDto.id == userId);

    return Comment(
        id: commentDto.id,
        responseToId: commentDto.responseToId,
        user: User.fromUserDto(commentDto.user),
        song: Song.fromSongDto(commentDto.song, null),
        time: commentDto.time,
        content: commentDto.content,
        numberOfUsersLiked: commentDto.usersLiked.length,
        isUserLiked: isLiked);
  }
}
