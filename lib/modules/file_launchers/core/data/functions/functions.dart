import 'package:browser_launcher/modules/file_launchers/core/models/launcher_file_types.dart';

class LauncherFunctions {
  static LauncherFileTypes getFileType({required String path}) {
    if (path.endsWith('.pdf')) {
      return LauncherFileTypes.pdf;
    } else if (path.endsWith('.jpg') ||
        path.endsWith('.png') ||
        path.endsWith('.giff')) {
      return LauncherFileTypes.image;
    } else if (path.endsWith('.mp4')) {
      return LauncherFileTypes.video;
    }
    return LauncherFileTypes.other;
  }
}
