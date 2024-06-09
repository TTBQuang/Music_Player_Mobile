import 'package:flutter/material.dart';

import '../../../domain/entity/singer.dart';

class HorizontalSingerItem extends StatelessWidget {
  final Singer singer;
  final VoidCallback onItemClick;

  const HorizontalSingerItem(
      {super.key, required this.singer, required this.onItemClick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onItemClick,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              singer.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              singer.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
    );
  }
}
