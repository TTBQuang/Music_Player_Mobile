import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:music_player/utils/notification_utils.dart';
import 'package:music_player/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtils {
  static late String _localPath;
  static late bool _permissionReady;

  static Future<void> startDownload(
      String url, String filename, BuildContext context) async {
    Timer? timer;
    int currentProgress = 0;
    int total = 0;

    bool isAllowed =
        await NotificationUtils.checkAndRequestNotificationPermission();

    _permissionReady = await _checkAudioPermission();
    if (_permissionReady) {
      await _prepareSaveDir();
      String filePath = await _getUniqueFilePath(filename);

      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (total != 0) {
          double progressPercentage = (currentProgress / total * 100);
          if (isAllowed) {
            NotificationUtils.triggerNotification(
                title: '${Strings.downloadingNotification} $filename',
                progress: progressPercentage);
          }
        }
      });

      try {
        await Dio().download(
          url,
          filePath,
          onReceiveProgress: (received, totalBytes) {
            if (totalBytes != -1) {
              currentProgress = received;
              total = totalBytes;
            }
          },
        );
        timer.cancel();
        if (isAllowed) {
          NotificationUtils.triggerNotification(
              title: '${Strings.downloadSuccessNotification} $filename',
              progress: null);
        }
      } catch (e) {
        if (isAllowed) {
          NotificationUtils.triggerNotification(
              title: '${Strings.downloadFailNotification} $filename',
              progress: null);
        }
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

  static Future<bool> _checkAudioPermission() async {
    int sdk = 0;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      sdk = androidInfo.version.sdkInt;
    }

    if (Platform.isAndroid) {
      late dynamic status;

      if (sdk >= 33) {
        status = await Permission.audio.status;
        if (status != PermissionStatus.granted) {
          final result = await Permission.audio.request();
          if (result == PermissionStatus.granted) {
            return true;
          }
        } else {
          return true;
        }
      } else {
        status = await Permission.storage.status;
        if (status != PermissionStatus.granted) {
          final result = await Permission.storage.request();
          if (result == PermissionStatus.granted) {
            return true;
          }
        } else {
          return true;
        }
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
    if (Platform.isAndroid) {
      return "/sdcard/download";
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

  static Future<bool> deleteFile(String uri) async {
    final mediaStorePlugin = MediaStore();
    String? filePath =
        await mediaStorePlugin.getFilePathFromUri(uriString: uri);
    if (filePath != null) {
      try {
        final file = File(filePath);
        file.delete();
      } catch (e) {
        return false;
      }
    } else {
      return false;
    }
    return true;
  }
}
