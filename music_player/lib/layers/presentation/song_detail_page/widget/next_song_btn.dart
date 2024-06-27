import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';

class NextSongButton extends StatelessWidget {
  final double iconSize;

  const NextSongButton(this.iconSize, {super.key});

  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<bool>(
      valueListenable: audioManager.isSongInPlaylistNotifier,
      builder: (_, isInPlaylist, __) {
        return IconButton(
          iconSize: iconSize,
          color: isInPlaylist ? Colors.white : Colors.grey,
          icon: const Icon(Icons.skip_next),
          onPressed: () {
            if (isInPlaylist) {
              audioManager.next();
            }
          },
        );
      },
    );
  }
}
