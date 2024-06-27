import 'dart:convert';

import 'package:music_player/layers/domain/entity/user.dart';

class UserDto {
  int id;
  String username;
  String password;
  String displayName;

  UserDto(
      {required this.id,
      required this.username,
      required this.password,
      required this.displayName});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      displayName: json['display_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'display_name': displayName,
    };
  }

  factory UserDto.fromUser(User user) {
    return UserDto(
      id: user.id,
      username: user.username,
      password: user.password,
      displayName: user.displayName,
    );
  }
}
