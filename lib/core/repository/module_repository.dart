import 'dart:async';

import 'package:browser_launcher/core/models/module_status/module_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ModuleRepository {
  static const platform = MethodChannel('sample.flutter.dev/path');
  final _controller = StreamController<ModuleStatus>();
  Stream<ModuleStatus> get status async* {
    await Future.delayed(const Duration(milliseconds: 1500));
    yield ModuleStatus.none;
    yield* _controller.stream;
  }

  Future<void> getModuleStatus() async {
    try {
      final selectedFilePath = await getFilePath();
      debugPrint('Get Module Status is launched: $selectedFilePath');
      debugPrint('${selectedFilePath == null}');
      if (selectedFilePath != null && selectedFilePath.isNotEmpty) {
        _controller.add(ModuleStatus.fileLauncher);
      } else {
        _controller.add(ModuleStatus.browser);
      }
    } catch (e) {
      _controller.add(ModuleStatus.browser);
    }
  }

  Future<String?> getFilePath() async {
    try {
      final String result = await platform.invokeMethod('getFilePath');
      
      debugPrint('Returning result: $result');
      if (result == 'null') {
        return null;
      }
      return result;
    } on PlatformException catch (e) {
      debugPrint('Error occured $e');
      throw Exception(e.message);
    } catch (error) {
      return null;
    }
  }
}
