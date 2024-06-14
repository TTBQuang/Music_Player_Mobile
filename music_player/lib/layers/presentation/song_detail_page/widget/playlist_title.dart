import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';

class PlaylistTitle extends StatelessWidget {
  const PlaylistTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final pageManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentPlaylistTitleNotifier,
      builder: (_, title, __) {
        return title.isNotEmpty
            ? Text(
                'Playlist: $title',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }
}
