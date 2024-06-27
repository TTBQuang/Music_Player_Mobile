import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';
import '../notifier/play_mode_button_notifier.dart';

class PlayModeButton extends StatelessWidget {
  final double iconSize;
  final VoidCallback onTap;

  const PlayModeButton(
      {super.key, required this.iconSize, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<PlayModeState>(
        valueListenable: audioManager.playModeButtonNotifier,
        builder: (_, state, __) {
          return IconButton(
            icon: Icon(state.icon),
            color: Colors.white,
            iconSize: iconSize,
            onPressed: onTap,
          );
        });
  }
}
