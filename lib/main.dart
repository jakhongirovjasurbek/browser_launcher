// import 'dart:convert';
// import 'dart:io';

import 'package:browser_launcher/core/bloc/module_bloc.dart';
import 'package:browser_launcher/core/models/module_status/module_state.dart';
import 'package:browser_launcher/core/repository/module_repository.dart';
import 'package:browser_launcher/core/screens/access_denied_screen.dart';
import 'package:browser_launcher/core/screens/splash_screen.dart';
import 'package:browser_launcher/modules/browser/browser_screen.dart';
import 'package:browser_launcher/modules/file_launchers/file_launchers.dart';
// import 'package:convert/convert.dart';
// import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:logging/logging.dart';
// import 'package:simple_json_persistence/simple_json_persistence.dart';

// final _logger = Logger('main');

// class AppDataBloc {
//   final store = SimpleJsonPersistence.getForTypeWithDefault(
//     (json) => AppData.fromJson(json),
//     defaultCreator: () => AppData(files: []),
//     name: 'AppData',
//   );
// }

// class AppData implements HasToJson {
//   AppData({required this.files});
//   final List<FileInfo> files;

//   static AppData fromJson(Map<String, dynamic> json) => AppData(
//       files: (json['files'] as List<dynamic>)
//           .where((dynamic element) => element != null)
//           .map((dynamic e) => FileInfo.fromJson(e as Map<String, dynamic>))
//           .toList());

//   @override
//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'files': files,
//       };

//   AppData copyWith({required List<FileInfo> files}) => AppData(files: files);
// }

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // final state = FilePickerWritable().init();
    // state.registerFileOpenHandler((fileInfo, file) async {
    //   _logger.fine('got file info. we are mounted:$mounted');
    //   if (!mounted) {
    //     return false;
    //   }
    //   await SimpleAlertDialog.readFileContentsAndShowDialog(
    //     fileInfo,
    //     file,
    //     _navigator.context,
    //     bodyTextPrefix: 'Should open file from external app.\n\n'
    //         'fileName: ${fileInfo.uri}\n'
    //         'uri: ${fileInfo.uri}\n\n\n',
    //   );
    //   return true;
    // });
    // state.registerUriHandler((uri) {
    //   SimpleAlertDialog(
    //     titleText: 'Handling Uri',
    //     bodyText: 'Got a uri to handle: $uri',
    //   ).show(_navigator.context);
    //   return true;
    // });
    // state.registerErrorEventHandler((errorEvent) async {
    //   _logger.fine('Handling error event, mounted: $mounted');
    //   if (!mounted) {
    //     return false;
    //   }
    // await SimpleAlertDialog(
    //   titleText: 'Received error event',
    //   bodyText: errorEvent.message,
    // ).show(_navigator.context);
    // return true;
    // });
  }

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => ModuleRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ModuleBloc(
              repository: RepositoryProvider.of<ModuleRepository>(context),
            ),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Browser & Launcher',
          onGenerateRoute: (settings) => SplashScreen.route(),
          navigatorKey: _navigatorKey,
          builder: (context, child) => BlocListener<ModuleBloc, ModuleState>(
            listener: (context, state) {
              switch (state.status) {
                case ModuleStatus.browser:
                  _navigator.pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const Browser()),
                    (route) => false,
                  );
                  break;
                case ModuleStatus.fileLauncher:
                  _navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (_) => FileLaunchers(
                              filePath: state.filePath,
                            )),
                    (route) => false,
                  );
                  break;
                case ModuleStatus.none:
                  context.read<ModuleBloc>().add(GetModuleStatus(
                        onSuccess: () {},
                        onFailure: (message) {},
                      ));
                  break;
                case ModuleStatus.accessDenied:
                  _navigator.pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const AccessDeniedScreen(),
                    ),
                    (route) => false,
                  );
                  break;
              }
            },
            child: child!,
          ),
        ),
      ),
    );
  }
}

// class SimpleAlertDialog extends StatelessWidget {
//   const SimpleAlertDialog({Key? key, this.titleText, required this.bodyText})
//       : super(key: key);
//   final String? titleText;
//   final String bodyText;

//   Future<void> show(BuildContext context) =>
//       showDialog<void>(context: context, builder: (context) => this);

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       scrollable: true,
//       title: titleText == null ? null : Text(titleText!),
//       content: Text(bodyText),
//       actions: <Widget>[
//         TextButton(
//             child: const Text('Ok'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             }),
//       ],
//     );
//   }

  // static Future readFileContentsAndShowDialog(
  //   FileInfo fi,
  //   File file,
  //   BuildContext context, {
  //   String bodyTextPrefix = '',
  // }) async {
  //   final dataList = await file.openRead(0, 64).toList();
  //   final data = dataList.expand((element) => element).toList();
  //   final hexString = hex.encode(data);
  //   final utf8String = utf8.decode(data, allowMalformed: true);
  //   final fileContentExample = 'hexString: $hexString\n\nutf8: $utf8String';

  //   // ignore: use_build_context_synchronously
  //   await SimpleAlertDialog(
  //     titleText: 'Read first ${data.length} bytes of file',
  //     bodyText: '$bodyTextPrefix $fileContentExample',
  //   ).show(context);
  // }

  // static Future showErrorDialog(Exception e, BuildContext context) async {
  //   await SimpleAlertDialog(
  //     titleText: 'Error',
  //     bodyText: e.toString(),
  //   ).show(context);
  // }
// }