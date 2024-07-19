import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:music_player/layers/data/source/firebase/song_upload.dart';

class SongUploadImpl extends SongUpload{
  @override
  Future<String> upload(String filePath, String destination) async {
    final firebaseStorage = FirebaseStorage.instance;
    final file = File(filePath);
    final fileName = filePath.split('/').last;
    final ref = firebaseStorage.ref().child('$destination/$fileName');
    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}