import 'dart:convert';

import 'package:music_player/layers/domain/entity/user.dart';

class UserDto extends User{
  String password;

  UserDto({required super.id, required super.username, required this.password, required super.displayName, required super.authority});

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      displayName: json['display_name'],
      authority: json['authority'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'display_name': displayName,
      'authority': authority,
    };
  }
}