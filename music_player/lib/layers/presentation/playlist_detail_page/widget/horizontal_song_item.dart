import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/file_utils.dart';
import '../../../domain/entity/song.dart';

class HorizontalSongItem extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final VoidCallback onItemClick;

  const HorizontalSongItem(
      {super.key,
      required this.isPlaying,
      required this.song,
      required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemClick,
      child: Container(
        color: isPlaying ? Colors.blueAccent : Colors.transparent,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              song.image ?? Constants.defaultNetworkImage,
              width: 60,
              height: 60,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    song.name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    song.getSingerNames(),
                  ),
                ],
              ),
            ),
            IconButton(
                onPressed: () {
                  String url = song.linkSong ?? '';
                  String name = song.name ?? '';
                  FileUtils.startDownload(url, name, context);
                },
                icon: const Icon(Icons.download))
          ],
        ),
      ),
    );
  }
}
