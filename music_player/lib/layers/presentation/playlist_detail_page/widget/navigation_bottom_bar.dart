import 'package:flutter/material.dart';

class NavigationBottomBar extends StatelessWidget {
  final VoidCallback onPrevClick;
  final VoidCallback onNextClick;
  final int pageNumber;
  final int maxPage;

  const NavigationBottomBar(
      {super.key,
      required this.onPrevClick,
      required this.onNextClick,
      required this.pageNumber,
      required this.maxPage});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPrevClick,
          icon: const Icon(Icons.navigate_before),
        ),
        TextButton(
          onPressed: () {},
          style: const ButtonStyle(
            splashFactory: NoSplash.splashFactory,
          ),
          child: Text(
            pageNumber.toString(),
          ),
        ),
        IconButton(
          onPressed: onNextClick,
          icon: const Icon(Icons.navigate_next),
        ),
      ],
    );
  }
}
