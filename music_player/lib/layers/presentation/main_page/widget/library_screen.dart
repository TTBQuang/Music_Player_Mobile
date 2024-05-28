import 'package:flutter/cupertino.dart';

class LibraryScreen extends StatefulWidget{
  const LibraryScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LibraryState();
  }
}

class _LibraryState extends State<LibraryScreen>{
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Library'),);
  }
}