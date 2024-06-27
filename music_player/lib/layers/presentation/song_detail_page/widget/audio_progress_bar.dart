import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';
import '../notifier/progress_notifier.dart';

class AudioProgressBar extends StatelessWidget {
  const AudioProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<ProgressBarState>(
      valueListenable: audioManager.progressNotifier,
      builder: (_, value, __) {
        return ProgressBar(
          timeLabelTextStyle: const TextStyle(color: Colors.white),
          baseBarColor: Colors.grey,
          progressBarColor: Colors.white,
          thumbColor: Colors.white,
          bufferedBarColor: Colors.white70,
          progress: value.current,
          buffered: value.buffered,
          total: value.total,
          onSeek: audioManager.seek,
        );
      },
    );
  }
}