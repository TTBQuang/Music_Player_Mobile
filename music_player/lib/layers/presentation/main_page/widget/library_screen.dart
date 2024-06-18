import 'package:flutter/material.dart';
import 'package:music_player/utils/size_config.dart';
import 'package:music_player/utils/strings.dart';

import 'download_song_list.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LibraryState();
  }
}

class _LibraryState extends State<LibraryScreen> {
  bool isText1Underlined = true;
  bool isText2Underlined = false;

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
                        fontWeight: isText1Underlined
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isText1Underlined
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isText1Underlined = true;
                        isText2Underlined = false;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: TextButton(
                    child: Text(
                      Strings.savedSong,
                      style: TextStyle(
                        fontSize: 15.w,
                        fontWeight: isText2Underlined
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isText2Underlined
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        isText1Underlined = false;
                        isText2Underlined = true;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: Stack(
                children: [
                  if (isText1Underlined) const DownloadSongList(),
                  if (isText2Underlined) const FavoriteSongList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteSongList extends StatelessWidget {
  const FavoriteSongList({super.key});

  @override
  Widget build(BuildContext context) {
    // Here you can add your own implementation for the FavoriteSongList
    return const Center(child: Text('Favorite Songs'));
  }
}
