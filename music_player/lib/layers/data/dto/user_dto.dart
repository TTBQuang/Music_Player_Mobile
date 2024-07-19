import 'dart:convert';

import 'package:music_player/layers/domain/entity/user.dart';

class UserDto {
  int id;
  String username;
  String password;
  String displayName;
  String role;

  UserDto(
      {required this.id,
      required this.username,
      required this.password,
      required this.displayName,
        required this.role});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      displayName: json['display_name'],
      role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'display_name': displayName,
      'role': role,
    };
  }

  factory UserDto.fromUser(User user) {
    return UserDto(
      id: user.id,
      username: user.username,
      password: user.password,
      displayName: user.displayName,
      role: user.role,
    );
  }
}
