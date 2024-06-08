import 'package:flutter/material.dart';

import '../../../domain/entity/singer.dart';
import '../../../domain/entity/song.dart';

class HorizontalSongItem extends StatelessWidget {
  final Song song;
  final VoidCallback onItemClick;

  const HorizontalSongItem({super.key, required this.song, required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    String singers = ''; // list of singers of the song
    for (Singer singer in song.singers) {
      singers += singer.name;
      singers += ', ';
    }
    singers = singers.substring(0, singers.length - 2);

    return InkWell(
      onTap: onItemClick,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            song.image,
            width: 60,
            height: 60,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  singers,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          )
        ],
      ),
    );
  }
}
