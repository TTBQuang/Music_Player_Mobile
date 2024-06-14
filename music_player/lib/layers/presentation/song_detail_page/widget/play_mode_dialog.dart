import 'package:flutter/material.dart';
import 'package:music_player/utils/size_config.dart';

import '../../../../utils/strings.dart';
import '../notifier/play_mode_button_notifier.dart';

class PlayModeDialog extends StatelessWidget {
  final Function(PlayModeState) onItemClick;

  const PlayModeDialog({super.key, required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        title: Center(
          child: Text(
            Strings.playModeDialogTitle,
            style: TextStyle(fontSize: 20.w, fontWeight: FontWeight.bold),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: PlayModeState.values.length,
            itemBuilder: (context, index) {
              var playMode = PlayModeState.values[index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: InkWell(
                  onTap: () => onItemClick(playMode),
                  borderRadius: BorderRadius.circular(0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        playMode.icon,
                        size: 20.w,
                      ),
                      const SizedBox(width: 20),
                      Text(
                        playMode.title,
                        style: TextStyle(fontSize: 15.w),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ));
  }
}
