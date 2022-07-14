import 'package:browser_launcher/core/bloc/module_bloc.dart';
import 'package:browser_launcher/core/models/module_status/module_state.dart';
import 'package:browser_launcher/core/repository/module_repository.dart';
import 'package:browser_launcher/core/screens/splash_screen.dart';
import 'package:browser_launcher/modules/browser/browser_screen.dart';
import 'package:browser_launcher/modules/file_launchers/file_launchers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
