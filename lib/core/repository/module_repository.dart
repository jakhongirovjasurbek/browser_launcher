import 'dart:async';

import 'package:browser_launcher/core/models/module_status/module_state.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class ModuleRepository {
  static const platform = MethodChannel('sample.flutter.dev/path');
  static const intentPlatform = MethodChannel('sample.flutter.dev/intentPath');
  final _controller = StreamController<ModuleStatus>();
  final intentShareController = StreamController<String>();
  final state = FilePickerWritable().init();

  Stream<ModuleStatus> get status async* {
    await Future.delayed(const Duration(milliseconds: 1500));
    yield ModuleStatus.none;
    yield* _controller.stream;
  }

  Stream<String> get intentStatus async* {
    yield* intentShareController.stream;
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
      state.registerErrorEventHandler((errorEvent) async {
        // await SimpleAlertDialog(
        //   titleText: 'Received error event',
        //   bodyText: errorEvent.message,
        // ).show(_navigator.context);
        return true;
      });

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

  Future<void> getIntentUrlOnShareContent() async {
    state.registerFileOpenHandler((fileInfo, file) async {
      print('It is here in first plcae;');
      final Map<String, dynamic> params = <String, dynamic>{
        'uri': fileInfo.uri,
      };
      final String? path =
          await intentPlatform.invokeMethod('getAbsolutePath', params);
      if (path != null && path.isNotEmpty) {
        intentShareController.add(path);
      }
      return true;
    });
    state.registerUriHandler((uri) {
      print('It is here in second place');
      // SimpleAlertDialog(
      //   titleText: 'Handling Uri',
      //   bodyText: 'Got a uri to handle: $uri',
      // ).show(_navigator.context);
      return true;
    });
  }
}
