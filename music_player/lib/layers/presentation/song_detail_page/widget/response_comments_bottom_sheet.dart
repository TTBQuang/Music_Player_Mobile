import 'package:flutter/material.dart';
import 'package:music_player/layers/presentation/login_page/login_viewmodel.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../../utils/strings.dart';
import '../../../domain/entity/comment.dart';
import '../../../presentation/song_detail_page/song_detail_viewmodel.dart';
import '../../login_page/login_screen.dart';
import 'comment_item.dart';

class ResponseCommentsBottomSheet extends StatefulWidget {
  final Comment comment;
  final Function(String) onAddComment;

  const ResponseCommentsBottomSheet({
    super.key,
    required this.comment,
    required this.onAddComment,
  });

  @override
  State<ResponseCommentsBottomSheet> createState() =>
      _ResponseCommentsBottomSheetState();
}

class _ResponseCommentsBottomSheetState
    extends State<ResponseCommentsBottomSheet> {
  late Future<List<Comment>> _responsesFuture;

  @override
  void initState() {
    super.initState();
    _loadResponses();
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    // add listener when user login in this screen
    loginViewModel.addListener(_onUserChange);
  }

  void _onUserChange() {
    _loadResponses();
  }

  // load all comments which respond to widget.song
  void _loadResponses() {
    final songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    _responsesFuture = songDetailViewModel.getCommentsByResponseId(
        widget.comment.id!, loginViewModel.user?.id);
  }

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);
    final songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Expanded(
                child: Text(
                  Strings.response,
                  style: TextStyle(
                    fontSize: 15.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            color: Colors.white12,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CommentItem(
                comment: widget.comment,
                shouldShowResponseText: false,
                responseCount: 0,
                onResponseTap: () {},
                onLikeOrUnlikeComment: () {
                  if (loginViewModel.user?.id != null) {
                    likeOrUnlikeComment(widget.comment);
                  } else {
                    Navigator.of(context).push(
                      LoginScreen.route(canNavigateBack: true),
                    );
                  }
                },
                onUpdateComment: (value) async {
                  await updateComment(widget.comment, value);
                  setState(() {
                    widget.comment.content = value;
                  });
                },
                shouldShowResponseIcon: false,
                onDeleteComment: () async {
                  await songDetailViewModel.deleteComment(widget.comment.id!);
                  if (context.mounted) {
                    Navigator.pop(context, true);
                  }
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Comment>>(
              future: _responsesFuture,
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

                final responses = snapshot.data!;
                return ListView.builder(
                  itemCount: responses.length,
                  itemBuilder: (context, index) {
                    final response = responses[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 30, top: 5, bottom: 5),
                      child: CommentItem(
                        comment: response,
                        responseCount: 0,
                        shouldShowResponseText: false,
                        onResponseTap: () {},
                        onUpdateComment: (value) async {
                          await updateComment(response, value);
                        },
                        onLikeOrUnlikeComment: () {
                          if (loginViewModel.user?.id != null) {
                            likeOrUnlikeComment(response);
                          } else {
                            Navigator.of(context).push(
                              LoginScreen.route(canNavigateBack: true),
                            );
                          }
                        },
                        shouldShowResponseIcon: false,
                        onDeleteComment: () async {
                          await songDetailViewModel.deleteComment(response.id!);
                          _loadResponses();
                          setState(() {});
                        },
                      ),
                    );
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
                  right: 10),
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
                onSubmitted: (String value) async {
                  await widget.onAddComment(value);
                  _loadResponses();
                },
              ),
            ),
        ],
      ),
    );
  }

  Future<void> updateComment(Comment comment, String value) async {
    final songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);

    Comment newComment = Comment(
      id: comment.id,
      responseToId: comment.responseToId,
      user: comment.user,
      song: comment.song,
      time: comment.time,
      content: value,
      numberOfUsersLiked: comment.numberOfUsersLiked,
      isUserLiked: comment.isUserLiked,
    );
    await songDetailViewModel.updateComment(newComment);
    // reload after adding new comment
    _loadResponses();
    setState(() {});
  }

  void likeOrUnlikeComment(Comment comment) {
    final songDetailViewModel =
        Provider.of<SongDetailViewModel>(context, listen: false);
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    // update databse and reload to update UI
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
}
