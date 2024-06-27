import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';

class SongName extends StatelessWidget {
  final double fontSize;

  const SongName(this.fontSize, {super.key});

  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<String>(
      valueListenable: audioManager.songNameNotifier,
      builder: (_, title, __) {
        return Text(title,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: fontSize));
      },
    );
  }
}
