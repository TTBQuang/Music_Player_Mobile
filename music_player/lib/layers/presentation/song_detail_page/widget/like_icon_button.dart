import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';

class LikeIconButton extends StatelessWidget {
  final double iconSize;
  final VoidCallback updateLikeDatabase;

  const LikeIconButton(
      {super.key, required this.iconSize, required this.updateLikeDatabase});

  @override
  Widget build(BuildContext context) {
    final audioManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<bool>(
      valueListenable: audioManager.isSongLikedNotifier,
      builder: (_, isLiked, __) {
        return ValueListenableBuilder<int>(
            valueListenable: audioManager.numberOfLikesNotifier,
            builder: (_, number, __) {
              return Row(
                children: [
                  IconButton(
                    icon: isLiked
                        ? const Icon(Icons.thumb_up)
                        : const Icon(Icons.thumb_up_alt_outlined),
                    color: Colors.white,
                    iconSize: iconSize,
                    onPressed: () {
                      updateLikeDatabase();
                    },
                  ),
                  Text(
                    audioManager.numberOfLikesNotifier.value.toString(),
                    style: TextStyle(
                        color: Colors.white, fontSize: iconSize * 0.6),
                  ),
                ],
              );
            });
      },
    );
  }
}
