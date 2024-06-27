import 'package:music_player/layers/data/dto/comment_dto.dart';
import 'package:music_player/layers/data/source/network/comment_network.dart';
import 'package:music_player/layers/domain/entity/comment.dart';
import 'package:music_player/layers/domain/repository/comment_repository.dart';

class CommentRepositoryImpl extends CommentRepository {
  final CommentNetwork commentNetwork;

  CommentRepositoryImpl(this.commentNetwork);

  @override
  Future<List<Comment>> getAllComments(songId, int? userId) async {
    List<CommentDto> list = await commentNetwork.getAllComments(songId);
    // convert to List<Comment>
    List<Comment> result = [];
    for (CommentDto commentDto in list) {
      result.add(Comment.fromCommentDto(commentDto, userId));
    }
    return result;
  }

  @override
  Future<void> addComment(Comment comment) async {
    await commentNetwork.addComment(CommentDto.fromComment(comment));
  }

  @override
  Future<List<Comment>> getCommentsByResponseId(
      int responsesId, int? userId) async {
    List<CommentDto> list =
        await commentNetwork.getCommentsByResponseId(responsesId);
    // convert to List<Comment>
    List<Comment> result = [];
    for (CommentDto commentDto in list) {
      result.add(Comment.fromCommentDto(commentDto, userId));
    }
    return result;
  }

  @override
  Future<void> updateComment(Comment comment) async {
    await commentNetwork.updateComment(CommentDto.fromComment(comment));
  }

  @override
  Future<void> likeComment(int commentId, int userId) async {
    commentNetwork.likeComment(userId, commentId);
  }

  @override
  Future<void> unlikeComment(int commentId, int userId) async {
    commentNetwork.unlikeComment(userId, commentId);
  }

  @override
  Future<void> deleteComment(int commentId) async {
    await commentNetwork.deleteComment(commentId);
  }
}
