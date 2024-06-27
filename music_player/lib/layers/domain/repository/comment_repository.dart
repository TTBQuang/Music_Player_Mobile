import 'package:music_player/layers/domain/entity/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getAllComments(int songId, int? userId);
  Future<void> addComment(Comment comment);
  Future<List<Comment>> getCommentsByResponseId(int responsesId, int? userId);
  Future<void> updateComment(Comment comment);
  Future<void> likeComment(int commentId, int userId);
  Future<void> unlikeComment(int commentId, int userId);
  Future<void> deleteComment(int commentId);
}
