import 'package:flutter/material.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/file_utils.dart';
import '../../../../utils/strings.dart';
import '../../../domain/entity/song.dart';

class FavoriteSongItem extends StatelessWidget {
  final Song song;
  final bool isPlaying;
  final Function(int) onRemoveFromFavorite;

  const FavoriteSongItem(
      {super.key,
      required this.song,
      required this.isPlaying,
      required this.onRemoveFromFavorite});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isPlaying ? Colors.blueAccent : Colors.transparent,
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.network(
            song.image ?? Constants.defaultNetworkImage,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  song.getSingerNames(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          PopupMenuButton<int>(
            icon: const Icon(
              Icons.more_vert,
            ),
            onSelected: (item) => _onSelected(context, item),
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: Constants.downloadOption,
                child: Text(Strings.download),
              ),
              const PopupMenuItem<int>(
                value: Constants.saveFavoriteOption,
                child: Text(Strings.removeFromFavorites),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _onSelected(BuildContext context, int item) {
    switch (item) {
      case Constants.downloadOption:
        FileUtils.startDownload(song.linkSong!, song.name!, context);
        break;
      case Constants.saveFavoriteOption:
        onRemoveFromFavorite(song.id!);
        break;
    }
  }
}
