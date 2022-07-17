import 'package:browser_launcher/core/bloc/module_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Browser extends StatefulWidget {
  const Browser({Key? key}) : super(key: key);

  @override
  State<Browser> createState() => _BrowserState();
}

class _BrowserState extends State<Browser> with WidgetsBindingObserver {
  AppLifecycleState? _notification;
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      print('Lifecycle has changed in browser');
      // context.read<ModuleBloc>().add(
      //       GetModuleStatus(onSuccess: () {}, onFailure: (_) {}),
      //     );
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Browser ${context.read<ModuleBloc>().state.filePath}',
        ),
      ),
    );
  }
}
