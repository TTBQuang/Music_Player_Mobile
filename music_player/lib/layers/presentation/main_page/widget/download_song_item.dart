import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DownloadSongItem extends StatelessWidget{
  final String name;
  final String author;

  const DownloadSongItem({super.key, required this.name, required this.author});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('assets/image/logo.png', width: 55, height: 55),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                author,
              ),
            ],
          ),
        ),
      ],
    );
  }
}