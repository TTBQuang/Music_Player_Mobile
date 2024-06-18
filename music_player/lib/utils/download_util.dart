import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:music_player/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadUtils {
  static late String _localPath;
  static late bool _permissionReady;
  static late TargetPlatform? platform;

  static Future<void> startDownload(
      String url, String filename, BuildContext context) async {
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    _permissionReady = await _checkPermission();
    if (_permissionReady) {
      await _prepareSaveDir();
      String filePath = await _getUniqueFilePath(filename);
      try {
        await Dio().download(url, filePath);
        print("Download Completed.");
      } catch (e) {
        print("Download Failed.\n\n$e");
      }
    } else {
      if (context.mounted) {
        _showPermissionDialog(context);
      }
    }
  }

  static Future<String> _getUniqueFilePath(String filename) async {
    String basePath = _localPath;
    String filePath = '$basePath/$filename.mp3';
    int count = 1;

    // Check if file already exists, if yes, append a number in brackets
    while (await File(filePath).exists()) {
      filePath = '$basePath/$filename ($count).mp3';
      count++;
    }

    return filePath;
  }

  static Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.audio.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.audio.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  static Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  static Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getApplicationDocumentsDirectory();
      return '${directory.path}${Platform.pathSeparator}Download';
    }
  }

  static void _showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(Strings.explainPermissionTitle),
        content: const Text(Strings.explainAudioPermissionContent),
        actions: <Widget>[
          TextButton(
            child: const Text(Strings.cancel),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text(Strings.goToSetting),
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}
