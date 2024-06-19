import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:music_player/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationUtils {
  static triggerNotification({required String? title, double? progress}) {
    var notificationContent = NotificationContent(
      id: 1,
      channelKey: Constants.channelKey,
      title: title,
      notificationLayout: progress != null
          ? NotificationLayout.ProgressBar
          : NotificationLayout.Default,
      progress: progress,
    );

    AwesomeNotifications().createNotification(content: notificationContent);
  }

  static Future<bool> checkAndRequestNotificationPermission() async {
    final PermissionStatus status = await Permission.notification.request();
    if (status.isGranted) {
      return true;
    } else {
      return false;
    }
  }
}
