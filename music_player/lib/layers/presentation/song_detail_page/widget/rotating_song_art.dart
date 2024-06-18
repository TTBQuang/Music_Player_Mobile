import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../services/audio_manager.dart';
import '../notifier/play_button_notifier.dart';

class RotatingSongArt extends StatefulWidget {
  const RotatingSongArt({super.key});

  @override
  State<StatefulWidget> createState() => _RotatingSongArtState();
}

class _RotatingSongArtState extends State<RotatingSongArt> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    print('object14');
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentSongArtNotifier,
      builder: (_, link, __) {
        return ValueListenableBuilder<ButtonState>(
          valueListenable: pageManager.playButtonNotifier,
          builder: (context, buttonState, child) {
            if (buttonState == ButtonState.playing) {
              _controller.repeat();
            } else {
              _controller.stop();
            }
            return RotationTransition(
              turns: _controller,
              child: Container(
                width: MediaQuery.of(context).size.width * 3 / 4,
                height: MediaQuery.of(context).size.width * 3 / 4,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: link.isEmpty
                        ? const AssetImage('assets/image/logo.png') as ImageProvider<Object>
                        : NetworkImage(link) as ImageProvider<Object>,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
