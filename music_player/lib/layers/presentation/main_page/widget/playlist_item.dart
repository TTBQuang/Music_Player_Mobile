import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';
import 'package:music_player/utils/size_config.dart';

class PlaylistItem extends StatelessWidget{
  final Playlist playlist;
  final VoidCallback onItemClick;

  const PlaylistItem({super.key, required this.playlist, required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemClick,
      child: Column(
        children: [
          Image.network(
            playlist.image,
            width: 150,
            height: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(
            height: 5.h,
          ),
          SizedBox(
            width: 150,
            child: Text(
              playlist.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.w,
              ),
            ),
          )
        ],
      ),
    );
  }
}