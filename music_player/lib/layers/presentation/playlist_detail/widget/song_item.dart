import 'package:flutter/material.dart';

import '../../../domain/entity/song.dart';

class SongItem extends StatelessWidget {
  final Song song;

  const SongItem(this.song, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
                  song.singers.first.name,
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
