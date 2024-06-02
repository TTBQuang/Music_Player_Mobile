import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:music_player/layers/domain/entity/playlist.dart';

import '../../../../utils/size_config.dart';

class BlurredHeader extends StatelessWidget{
  final Playlist playlist;

  const BlurredHeader(this.playlist, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: SizeConfig.screenHeight / 4
          + MediaQuery.of(context).padding.top  // Add padding for safe area
          + 50, // Add padding below image
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              playlist.image,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                color: Colors.black.withOpacity(0.35),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Image.network(
                            playlist.image,
                            width: SizeConfig.screenHeight / 4,
                            height: SizeConfig.screenHeight / 4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}