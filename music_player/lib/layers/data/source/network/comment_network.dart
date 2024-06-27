import 'package:music_player/layers/data/dto/comment_dto.dart';

abstract class CommentNetwork {
  Future<List<CommentDto>> getAllComments(int songId);
  Future<void> addComment(CommentDto commentDto);
  Future<List<CommentDto>> getCommentsByResponseId(int responseId);
  Future<void> updateComment(CommentDto commentDto);
  Future<void> likeComment(int userId, int commentId);
  Future<void> unlikeComment(int userId, int commentId);
  Future<void> deleteComment(int commentId);
}