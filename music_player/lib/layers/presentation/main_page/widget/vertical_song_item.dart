import 'package:flutter/material.dart';
import 'package:music_player/utils/size_config.dart';

import '../../../../utils/constants.dart';
import '../../../domain/entity/song.dart';

class VerticalSongItem extends StatelessWidget{
  final Song song;
  final VoidCallback onItemClick;

  const VerticalSongItem({super.key, required this.song, required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemClick,
      child: Column(
        children: [
          Image.network(
            song.image ?? Constants.defaultNetworkImage,
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
              song.name ?? '',
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