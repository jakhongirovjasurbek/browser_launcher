import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class AppFunctions {
  static Future<bool> checkManageStoragePermission() async {
    if (Platform.isAndroid) {
      if (!(await Permission.manageExternalStorage.isGranted)) {
        final status = await Permission.manageExternalStorage.request();
        if (!(status.isGranted)) {
          throw Exception('Access for storage is denied');
        } else {
          return true;
        }
      } else if (await Permission.manageExternalStorage.isRestricted) {
        final status = await Permission.manageExternalStorage.request();
        if (!(status.isGranted)) {
          throw Exception('Access for storage is denied');
        } else {
          return true;
        }
      }
    }
    return true;
  }

  static Future<void> checkStoragePermission() async {
    if (!(await Permission.storage.isGranted)) {
      final status = await Permission.storage.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Permission is denied');
      }
    }
  }

  static Future<String?> getBaseAppDirectoryUrl() async {
    try {
      if (Platform.isAndroid) {
        final base = await path_provider.getExternalStorageDirectories();
        print(base);
        final folders = base?.first.path.split('/');
        print(folders);
        var baseUrl = '';
        if (folders != null) {
          for (var i = 1; i < folders.length; i++) {
            if (folders[i] != 'Android') {
              baseUrl += '/${folders[i]}';
            } else {
              break;
            }
          }
        }
        return baseUrl;
      } else if (Platform.isIOS) {
        final base = await path_provider.getApplicationDocumentsDirectory();
        return base.path;
      }
    } catch (e) {
      throw Exception('$e');
    }
    return null;
  }

  static Future<void> createAppLocalFolder() async {}

  static Future<void> createLocalNotification({String? changedFileInfo}) async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();

    if (isAllowed) {
      // This is just a basic example. For real apps, you must show some
      // friendly dialog box before call the request method.
      // This is very important to not harm the user experience
      AwesomeNotifications().requestPermissionToSendNotifications();
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: 'Browser & Launcher',
          body: changedFileInfo,
          autoDismissible: false,
          category: NotificationCategory.Recommendation,
          criticalAlert: true,
          wakeUpScreen: true,
          locked: true,
        ),
      );
    }
  }
}

void appLogger(Object object) {
  if (kDebugMode) {
    print(object);
  }
}
