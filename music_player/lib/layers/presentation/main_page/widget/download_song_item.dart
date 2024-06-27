import 'package:flutter/material.dart';

import '../../../../utils/strings.dart';

class DownloadSongItem extends StatelessWidget {
  final String name;
  final String author;
  final String uri;
  final bool isPlaying;
  final Function(String) onDelete; // Add the callback

  const DownloadSongItem({
    super.key,
    required this.name,
    required this.author,
    required this.uri,
    required this.onDelete,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isPlaying ? Colors.blueAccent : Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.asset('assets/image/logo.png', width: 50, height: 50),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => _showDeleteConfirmationDialog(context, uri),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  // show dialog asking the user if they are sure they want to delete
  void _showDeleteConfirmationDialog(BuildContext context, String uri) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(Strings.deleteConfirmationTitle),
          content: const Text(Strings.deleteConfirmationContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(Strings.no),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onDelete(uri);
              },
              child: const Text(Strings.yes),
            ),
          ],
        );
      },
    );
  }
}
