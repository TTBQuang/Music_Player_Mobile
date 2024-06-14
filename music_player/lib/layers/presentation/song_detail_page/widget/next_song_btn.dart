import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';

class NextSongButton extends StatelessWidget {
  final double iconSize;
  const NextSongButton(this.iconSize, {super.key});

  @override
  Widget build(BuildContext context) {
    final pageManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<bool>(
      valueListenable: pageManager.isSongInPlaylistNotifier,
      builder: (_, isInPlaylist, __) {
        return IconButton(
          iconSize: iconSize,
          color: Colors.white,
          icon: const Icon(Icons.skip_next),
          onPressed: (isInPlaylist) ? pageManager.next : null,
        );
      },
    );
  }
}