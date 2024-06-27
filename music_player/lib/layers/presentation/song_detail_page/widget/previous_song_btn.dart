import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';

class PreviousSongButton extends StatelessWidget {
  final double iconSize;
  const PreviousSongButton(this.iconSize, {super.key});

  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<bool>(
      valueListenable: audioManager.isSongInPlaylistNotifier,
      builder: (_, isInPlaylist, __) {
        return IconButton(
          iconSize: iconSize,
          color: isInPlaylist ? Colors.white : Colors.grey,
          icon: const Icon(Icons.skip_previous),
          onPressed: () {
            if (isInPlaylist) {
              audioManager.previous();
            }
          },
        );
      },
    );
  }
}