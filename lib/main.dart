import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:browser_launcher/core/bloc/module_bloc.dart';
import 'package:browser_launcher/core/data/app_functions.dart';
import 'package:browser_launcher/core/models/module_status/module_state.dart';
import 'package:browser_launcher/core/repository/module_repository.dart';
import 'package:browser_launcher/core/screens/access_denied_screen.dart';
import 'package:browser_launcher/core/screens/splash_screen.dart';
import 'package:browser_launcher/modules/browser/browser_screen.dart';
import 'package:browser_launcher/modules/file_launchers/file_launchers.dart';
import 'package:file_picker_writable/file_picker_writable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_json_persistence/simple_json_persistence.dart';

class AppDataBloc {
  final store = SimpleJsonPersistence.getForTypeWithDefault(
    (json) => AppData.fromJson(json),
    defaultCreator: () => AppData(files: []),
    name: 'AppData',
  );
}

class AppData implements HasToJson {
  AppData({required this.files});
  final List<FileInfo> files;

  static AppData fromJson(Map<String, dynamic> json) => AppData(
      files: (json['files'] as List<dynamic>)
          .where((dynamic element) => element != null)
          .map((dynamic e) => FileInfo.fromJson(e as Map<String, dynamic>))
          .toList());

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'files': files,
      };

  AppData copyWith({required List<FileInfo> files}) => AppData(files: files);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      // 'resource://drawable/res_app_icon',
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  final baseDirPath = await AppFunctions.getBaseAppDirectoryUrl();
  if (baseDirPath != null) {
    try {
      final subscription = Directory('$baseDirPath/Download').watch();
      subscription.listen((event) {
        AppFunctions.createLocalNotification(changedFileInfo: event.path);
      });
    } catch (e) {
      print(e);
    }
  }

  runApp(MyApp(repository: ModuleRepository()));
}

class MyApp extends StatefulWidget {
  final ModuleRepository _moduleRepository;
  const MyApp({
    required ModuleRepository repository,
    Key? key,
  })  : _moduleRepository = repository,
        super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    AwesomeNotifications()
        .actionStream
        .listen((ReceivedNotification receivedNotification) {
      // showDialog(
      //     context: _navigator.context,
      //     builder: (_) => AlertDialog(
      //           content: Text('$receivedNotification'),
      //         ));
      if (receivedNotification.body != null &&
          receivedNotification.body!.isNotEmpty) {
        widget._moduleRepository.intentShareController
            .add(receivedNotification.body!);
      }
    });

    final state = FilePickerWritable().init();
    state.registerFileOpenHandler((fileInfo, file) async {
      if (!mounted) {
        return false;
      }
      final Map<String, dynamic> params = <String, dynamic>{
        'uri': fileInfo.uri,
      };
      try {
        final String? path = await ModuleRepository.intentPlatform
            .invokeMethod('getIntentPath', params);
        if (path != null && path.isNotEmpty) {
          widget._moduleRepository.intentShareController.add(path);
        }

        if (Platform.isIOS) {
          widget._moduleRepository.intentShareController
              .add(path ?? 'File url is unknown');
        }
      } catch (e) {
        appLogger(e);
      }
      return true;
    });

    state.registerUriHandler((uri) {
      print('This has been launched');
      if (!mounted) {
        return false;
      }
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Text(uri.path),
              ));
      return true;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => widget._moduleRepository,
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
