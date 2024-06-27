import 'package:flutter/material.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';

import 'download_song_list.dart';
import 'favorite_song_list.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LibraryState();
  }
}

class _LibraryState extends State<LibraryScreen> {
  bool isTextDownloadUnderlined = true;
  bool isTextFavoriteUnderlined = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    child: Text(
                      Strings.downloadedSong,
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: isTextDownloadUnderlined
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isTextDownloadUnderlined
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isTextDownloadUnderlined = true;
                        isTextFavoriteUnderlined = false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: Text(
                      Strings.favoriteSong,
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: isTextFavoriteUnderlined
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isTextFavoriteUnderlined
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isTextDownloadUnderlined = false;
                        isTextFavoriteUnderlined = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  if (isTextDownloadUnderlined) const DownloadSongList(),
                  if (isTextFavoriteUnderlined) const FavoriteSongList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
