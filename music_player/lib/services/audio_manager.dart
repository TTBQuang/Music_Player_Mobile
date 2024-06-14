import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

import '../layers/domain/entity/playlist.dart';
import '../layers/presentation/song_detail_page/notifier/play_button_notifier.dart';
import '../layers/presentation/song_detail_page/notifier/play_mode_button_notifier.dart';
import '../layers/presentation/song_detail_page/notifier/progress_notifier.dart';

class AudioManager {
  final playButtonNotifier = PlayButtonNotifier();
  final progressNotifier = ProgressNotifier();
  final isSongInPlaylistNotifier = ValueNotifier<bool>(false);
  final currentSongNameNotifier = ValueNotifier<String>('');
  final currentAuthorsNameNotifier = ValueNotifier<String>('');
  final currentSongArtNotifier = ValueNotifier<String>('');
  final backgroundColorNotifier =
      ValueNotifier<List<Color>>([Colors.black, Colors.white]);
  final playModeButtonNotifier = PlayModeButtonNotifier();
  final currentPlaylistTitleNotifier = ValueNotifier<String>('');

  final AudioHandler _audioHandler;
  Playlist? playlist;

  AudioManager(this._audioHandler) {
    _listenToPlaybackState();
    _listenToCurrentPosition();
    _listenToBufferedPosition();
    _listenToTotalDuration();
    _listenToChangesInSong();
  }

  void play() => _audioHandler.play();

  void pause() => _audioHandler.pause();

  void _listenToPlaybackState() {
    _audioHandler.playbackState.listen((playbackState) {
      final isPlaying = playbackState.playing;
      final processingState = playbackState.processingState;
      if (processingState == AudioProcessingState.loading ||
          processingState == AudioProcessingState.buffering) {
        playButtonNotifier.value = ButtonState.loading;
      } else if (!isPlaying) {
        playButtonNotifier.value = ButtonState.paused;
      } else if (processingState != AudioProcessingState.completed) {
        playButtonNotifier.value = ButtonState.playing;
      } else {
        _audioHandler.seek(Duration.zero);
        _audioHandler.pause();
      }
    });
  }

  void addQueueItems(List<MediaItem> items) {
    _audioHandler.addQueueItems(items);
  }

  void _listenToCurrentPosition() {
    AudioService.position.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
    });
  }

  void _listenToBufferedPosition() {
    _audioHandler.playbackState.listen((playbackState) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: playbackState.bufferedPosition,
        total: oldState.total,
      );
    });
  }

  void _listenToTotalDuration() {
    _audioHandler.mediaItem.listen((mediaItem) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: mediaItem?.duration ?? Duration.zero,
      );
    });
  }

  void seek(Duration position) => _audioHandler.seek(position);

  void previous() => _audioHandler.skipToPrevious();

  void next() => _audioHandler.skipToNext();

  void _listenToChangesInSong() {
    _audioHandler.mediaItem.listen((mediaItem) {
      currentSongNameNotifier.value = mediaItem?.title ?? '';
      currentAuthorsNameNotifier.value = mediaItem?.artist ?? '';
      currentSongArtNotifier.value = mediaItem?.artUri.toString() ?? '';
      currentPlaylistTitleNotifier.value = mediaItem?.album ?? '';
      _updateSkipButtons();
      _updateBackgroundColor(mediaItem);
    });
  }

  void _updateBackgroundColor(MediaItem? mediaItem) {
    if (mediaItem != null) {
      PaletteGenerator.fromImageProvider(
              NetworkImage(mediaItem.artUri.toString()))
          .then((paletteGenerator) {
        final colors = paletteGenerator.colors
            .take(2)
            .map((color) => Color.lerp(color, Colors.black, 0.5)!)
            .toList();
        backgroundColorNotifier.value = colors;
      });
    }
  }

  void _updateSkipButtons() {
    final mediaItem = _audioHandler.mediaItem.value;
    final playlist = _audioHandler.queue.value;
    if (playlist.length == 1 || mediaItem == null) {
      isSongInPlaylistNotifier.value = false;
    } else {
      isSongInPlaylistNotifier.value = true;
    }
  }

  // Stop the current playback
  Future<void> stop() async {
    await _audioHandler.stop();
  }

  // Clear the current queue
  void clearQueue() {
    _audioHandler.updateQueue([]);
  }

  void skipToQueueItem(int index) {
    _audioHandler.skipToQueueItem(index);
  }

  void changePlayMode(PlayModeState newState) {
    playModeButtonNotifier.value = newState;
    switch (newState) {
      case PlayModeState.repeatSong:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.one);
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
        break;
      case PlayModeState.repeatPlaylist:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.none);
        break;
      case PlayModeState.shuffle:
        _audioHandler.setRepeatMode(AudioServiceRepeatMode.all);
        _audioHandler.setShuffleMode(AudioServiceShuffleMode.all);
        break;
    }
  }
}
