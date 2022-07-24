import 'package:browser_launcher/modules/file_launchers/core/models/launcher_file_types.dart';

class LauncherFunctions {
  static LauncherFileTypes getFileType({required String path}) {
    // if (path.endsWith('.pdf')) {
    //   return LauncherFileTypes.pdf;
    // } else if (path.endsWith('.jpg') ||
    //     path.endsWith('.png') ||
    //     path.endsWith('.giff')) {
    //   return LauncherFileTypes.image;
    // } else if (path.endsWith('.mp4')) {
    //   return LauncherFileTypes.video;
    // }
    return LauncherFileTypes.other;
  }

  static String getFileName({required String absolutePath}) {
    var name = '';
    final fileName =
        absolutePath.split('/')[absolutePath.split('/').length - 1];
    final fileNameArrow = fileName.split('.');
    for (var i = 0; i < fileNameArrow.length; i++) {
      if (i != fileNameArrow.length - 1) {
        name += fileNameArrow[i];
      }
    }

    return name;
  }

  static String getFileExtention({required String absolutePath}) {
    var extention = '';
    final fileName =
        absolutePath.split('/')[absolutePath.split('/').length - 1];
    final fileNameArrow = fileName.split('.');
    for (var i = 0; i < fileNameArrow.length; i++) {
      if (i == fileNameArrow.length - 1) {
        extention = fileNameArrow[i];
      }
    }

    return extention;
  }
}
