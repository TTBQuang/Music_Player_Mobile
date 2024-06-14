import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';
import '../notifier/play_button_notifier.dart';

class PlayButton extends StatelessWidget {
  final double iconSize;

  const PlayButton(this.iconSize, {super.key});

  @override
  Widget build(BuildContext context) {
    final pageManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<ButtonState>(
      valueListenable: pageManager.playButtonNotifier,
      builder: (_, value, __) {
        switch (value) {
          case ButtonState.loading:
            return const CircularProgressIndicator(color: Colors.white);
          case ButtonState.paused:
            return IconButton(
              icon: const Icon(Icons.play_arrow),
              color: Colors.white,
              iconSize: iconSize,
              onPressed: pageManager.play,
            );
          case ButtonState.playing:
            return IconButton(
              color: Colors.white,
              icon: const Icon(Icons.pause),
              iconSize: iconSize,
              onPressed: pageManager.pause,
            );
        }
      },
    );
  }
}