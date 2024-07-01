import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/strings.dart';
import '../../../domain/entity/comment.dart';
import '../../login_page/login_viewmodel.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    super.key,
    required this.comment,
    required this.shouldShowResponseText,
    required this.shouldShowResponseIcon,
    required this.responseCount,
    required this.onResponseTap,
    required this.onUpdateComment,
    required this.onDeleteComment,
    required this.onLikeOrUnlikeComment,
  });

  final Comment comment;
  final bool shouldShowResponseText;
  final bool shouldShowResponseIcon;
  final int responseCount;
  final VoidCallback onResponseTap;
  final Function(String) onUpdateComment;
  final VoidCallback onLikeOrUnlikeComment;
  final VoidCallback onDeleteComment;

  @override
  Widget build(BuildContext context) {
    final loginViewModel = Provider.of<LoginViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 20,
                child: Icon(
                  Icons.person,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${comment.user.displayName} · ${comment.time.day}/${comment.time.month}/${comment.time.year}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (loginViewModel.user?.id == comment.user.id)
                          PopupMenuButton<int>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                            ),
                            onSelected: (item) => _onSelected(context, item),
                            itemBuilder: (context) => [
                              const PopupMenuItem<int>(
                                value: Constants.deleteCommentOption,
                                child: Text(Strings.delete),
                              ),
                              const PopupMenuItem<int>(
                                value: Constants.updateCommentOption,
                                child: Text(Strings.update),
                              ),
                            ],
                          )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(comment.content,
                        style: const TextStyle(color: Colors.white)),
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: 8,
                            top: shouldShowResponseIcon ? 0 : 10,
                          ),
                          child: InkWell(
                            onTap: onLikeOrUnlikeComment,
                            child: comment.isUserLiked
                                ? const Icon(Icons.thumb_up)
                                : const Icon(Icons.thumb_up_alt_outlined),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: shouldShowResponseIcon ? 0 : 10,
                          ),
                          child: Text(
                            comment.numberOfUsersLiked.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        if (shouldShowResponseIcon)
                          IconButton(
                              onPressed: onResponseTap,
                              icon: const Icon(Icons.reply))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          if (shouldShowResponseText)
            Row(
              children: [
                const SizedBox(width: 40), // Avatar width
                TextButton(
                  onPressed: onResponseTap,
                  child: Text(
                    '$responseCount ${Strings.response}',
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case Constants.deleteCommentOption:
        onDeleteComment();
        break;
      case Constants.updateCommentOption:
        // show dialog to type new content of comment
        showDialog(
          context: context,
          builder: (BuildContext context) {
            TextEditingController controller =
                TextEditingController(text: comment.content);

            return AlertDialog(
              content: TextField(
                controller: controller,
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(Strings.cancel),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text(Strings.update),
                  onPressed: () {
                    // update comment
                    String updatedComment = controller.text;
                    onUpdateComment(updatedComment);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        break;
    }
  }
}
