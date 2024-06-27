import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/comment.dart';
import 'package:music_player/layers/domain/entity/song.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/layers/presentation/song_detail_page/song_detail_viewmodel.dart';
import 'package:music_player/layers/presentation/song_detail_page/widget/response_comments_bottom_sheet.dart';
import 'package:music_player/services/audio_manager.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../utils/strings.dart';
import '../../login_page/login_screen.dart';
import 'comment_item.dart';

class CommentBottomSheet extends StatefulWidget {
  final int songId;

  const CommentBottomSheet({super.key, required this.songId});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  late Future<List<Comment>> _commentsFuture;

  @override
  void initState() {
    super.initState();
    _loadComments();
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    // add listener when user login in this screen
    loginViewModel.addListener(_onUserChange);
  }

  void _onUserChange() {
    // reload comment after user login successfully
    _loadComments();
  }

  // load all comments of current song
  void _loadComments() {
    final songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    _commentsFuture = songDetailViewModel.getAllComments(
        audioManager.songIdNotifier.value, loginViewModel.user?.id);
  }

  // show response comments of a comment
  void _showResponsesBottomSheet(Comment comment, List<Comment> allComments) async {
    // if user delete a comment in ResponsesBottomSheet, reload comments list to update UI
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.8,
          child: ResponseCommentsBottomSheet(
            comment: comment,
            onAddComment: (value) async {
              await addNewComment(value, comment.id);
            },
          ),
        );
      },
    );

    if (result == true) {
      _loadComments();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          FutureBuilder<List<Comment>>(
            future: _commentsFuture,
            builder: (context, snapshot) {
              String commentCountText;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                commentCountText = 'Error: ${snapshot.error}';
              } else {
                final comments = snapshot.data!;
                commentCountText = '${comments.length} ${Strings.comment}';
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48),
                  Expanded(
                    child: Text(
                      commentCountText,
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          ),
          const Divider(),
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _commentsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text(Strings.hasNoComment));
                }

                final comments = snapshot.data!;
                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    if (comment.responseToId == null) {
                      final responseCount = comments
                          .where((c) => c.responseToId == comment.id)
                          .length;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: CommentItem(
                          comment: comment,
                          shouldShowResponseText: responseCount > 0,
                          responseCount: responseCount,
                          onResponseTap: () {
                            _showResponsesBottomSheet(comment, comments);
                          },
                          onUpdateComment: (value) async {
                            // update comment
                            Comment newComment = Comment(
                                id: comment.id,
                                responseToId: comment.responseToId,
                                user: comment.user,
                                song: comment.song,
                                time: comment.time,
                                content: value,
                                numberOfUsersLiked: comment.numberOfUsersLiked,
                                isUserLiked: comment.isUserLiked);
                            await songDetailViewModel.updateComment(newComment);
                            // reload after adding new comment
                            _loadComments();
                            setState(() {});
                          },
                          onLikeOrUnlikeComment: () {
                            if (loginViewModel.user?.id != null) {
                              likeOrUnlikeComment(comment);
                            } else {
                              Navigator.of(context).push(
                                LoginScreen.route(canNavigateBack: true),
                              );
                            }
                          },
                          shouldShowResponseIcon: true,
                          onDeleteComment: () async {
                            // delete comment, then reload to update UI
                            await songDetailViewModel
                                .deleteComment(comment.id!);
                            _loadComments();
                            setState(() {});
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink(); // Non-root comments
                  },
                );
              },
            ),
          ),
          if (loginViewModel.user != null)
            Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 10,
                right: 10,
              ),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: Strings.enterComment,
                  hintStyle: const TextStyle(color: Colors.blue),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onSubmitted: (String value) {
                  addNewComment(value, null);
                },
              ),
            ),
        ],
      ),
    );
  }

  void likeOrUnlikeComment(Comment comment) {
    final songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    // update databse and UI
    if (comment.isUserLiked) {
      songDetailViewModel.unlikeComment(comment.id!, loginViewModel.user!.id);
      setState(() {
        comment.numberOfUsersLiked--;
        comment.isUserLiked = false;
      });
    } else {
      songDetailViewModel.likeComment(comment.id!, loginViewModel.user!.id);
      setState(() {
        comment.numberOfUsersLiked++;
        comment.isUserLiked = true;
      });
    }
  }

  Future<void> addNewComment(String value, int? responseId) async {
    final songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    await songDetailViewModel.addComment(Comment(
      id: null,
      responseToId: responseId,
      user: loginViewModel.user!,
      song: Song(
        id: widget.songId,
        name: null,
        image: null,
        linkSong: null,
        releaseDate: null,
        numberOfUserLike: null,
        isLiked: null,
        isSaved: null,
        singers: null,
      ),
      time: DateTime.now(),
      content: value,
      numberOfUsersLiked: 0,
      isUserLiked: false,
    ));

    // reload after adding new comment
    _loadComments();
  }
}
