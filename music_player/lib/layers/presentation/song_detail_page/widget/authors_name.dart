import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../services/audio_manager.dart';

class AuthorsName extends StatelessWidget {
  final double fontSize;

  const AuthorsName(this.fontSize, {super.key});

  @override
  Widget build(BuildContext context) {
    final pageManager = Provider.of<AudioManager>(context, listen: false);
    return ValueListenableBuilder<String>(
      valueListenable: pageManager.currentAuthorsNameNotifier,
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
