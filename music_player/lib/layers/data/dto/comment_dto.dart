import 'package:music_player/layers/data/dto/song_dto.dart';
import 'package:music_player/layers/data/dto/user_dto.dart';
import 'package:music_player/layers/domain/entity/comment.dart';

class CommentDto {
  int? id;
  int? responseToId;
  UserDto user;
  SongDto song;
  DateTime time;
  String content;
  List<UserDto> usersLiked;

  CommentDto(
      {required this.id,
      required this.responseToId,
      required this.user,
      required this.song,
      required this.time,
      required this.content,
      required this.usersLiked});

  factory CommentDto.fromComment(Comment comment) {
    return CommentDto(
        id: comment.id,
        time: comment.time,
        content: comment.content,
        responseToId: comment.responseToId,
        user: UserDto.fromUser(comment.user),
        song: SongDto.fromSong(comment.song),
        usersLiked: []);
  }

  factory CommentDto.fromJson(Map<String, dynamic> json) {
    List<UserDto> usersLiked = [];
    if (json['users_liked'] != null) {
      List<dynamic> usersLikedJsonList = json['users_liked'] as List<dynamic>;
      usersLiked = usersLikedJsonList.map((userJson) => UserDto.fromJson(userJson)).toList();
    }

    return CommentDto(
      id: json['id'],
      content: json['content'],
      time: DateTime.parse(json['time']),
      responseToId: json['responseId'],
      user: UserDto.fromJson(json['user']),
      song: SongDto.fromJson(json['song']),
      usersLiked: usersLiked,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user.toJson(),
        'song': song.toJson(),
        'time': time.toIso8601String(),
        'content': content,
        'responseId': responseToId,
      };
}
