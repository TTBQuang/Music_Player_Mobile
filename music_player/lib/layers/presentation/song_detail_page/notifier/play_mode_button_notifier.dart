import 'package:flutter/material.dart';

import '../../../../utils/strings.dart';

class PlayModeButtonNotifier extends ValueNotifier<PlayModeState> {
  PlayModeButtonNotifier() : super(_initialValue);
  static const _initialValue = PlayModeState.repeatPlaylist;
}

enum PlayModeState {
  repeatSong(Strings.repeat, Icons.loop),
  repeatPlaylist(Strings.playSequentially, Icons.list),
  shuffle(Strings.playRandomly, Icons.shuffle);

  final String title;
  final IconData icon;

  const PlayModeState(this.title, this.icon);
}
