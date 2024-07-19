import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:music_player/layers/data/dto/comment_dto.dart';
import 'package:music_player/layers/data/source/network/comment_network.dart';
import 'package:http/http.dart' as http;

import '../../../../utils/strings.dart';

class CommentNetworkImpl extends CommentNetwork {
  final String baseUrl = 'http://192.168.1.13:8080/comment';

  @override
  Future<List<CommentDto>> getAllComments(int songId) async {
    try {
      final url = Uri.parse('$baseUrl/all?songId=$songId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((comment) => CommentDto.fromJson(comment))
            .toList();
      } else {
        throw Exception('${Strings.errorOccurred}: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<void> addComment(CommentDto commentDto) async {
    final url = Uri.parse('$baseUrl/add');
    try {
      await http
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(commentDto.toJson()),
          )
          .timeout(const Duration(seconds: 10));
    } catch (e) {
      if (kDebugMode) {
        print('Error add comment: $e');
      }
    }
  }

  @override
  Future<List<CommentDto>> getCommentsByResponseId(int responseId) async {
    try {
      final url = Uri.parse('$baseUrl/responses?responseId=$responseId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse =
            jsonDecode(utf8.decode(response.bodyBytes));
        return jsonResponse
            .map((comment) => CommentDto.fromJson(comment))
            .toList();
      } else {
        throw Exception('${Strings.errorOccurred}: ${response.statusCode}');
      }
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<void> updateComment(CommentDto commentDto) async {
    final url = Uri.parse('$baseUrl/update');
    try {
      await http
          .put(
            url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(commentDto.toJson()),
          )
          .timeout(const Duration(seconds: 10));
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<void> likeComment(int userId, int commentId) async {
    try {
      final url =
          Uri.parse('$baseUrl/like?userId=$userId&commentId=$commentId');
      await http.post(url);
    } on SocketException {
      // Handle network errors
      throw Exception(Strings.cannotConnectServer);
    } on TimeoutException {
      // Handle timeout errors
      throw Exception(Strings.timeout);
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<void> unlikeComment(int userId, int commentId) async {
    try {
      final url =
          Uri.parse('$baseUrl/unlike?userId=$userId&commentId=$commentId');
      await http.delete(url);
    } on SocketException {
      // Handle network errors
      throw Exception('Cannot connect to the server');
    } on TimeoutException {
      // Handle timeout errors
      throw Exception('Request timed out');
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }

  @override
  Future<void> deleteComment(int commentId) async {
    try {
      final url = Uri.parse('$baseUrl/delete?commentId=$commentId');
      await http.delete(url);
    } on SocketException {
      // Handle network errors
      throw Exception('Cannot connect to the server');
    } on TimeoutException {
      // Handle timeout errors
      throw Exception('Request timed out');
    } catch (e) {
      // Handle any other errors
      throw Exception('An error occurred: $e');
    }
  }
}
