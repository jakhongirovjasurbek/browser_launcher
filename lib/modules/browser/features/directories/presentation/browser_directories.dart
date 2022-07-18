import 'dart:io';

import 'package:browser_launcher/core/widgets/popus/snackbars.dart';
import 'package:browser_launcher/core/widgets/w_scale.dart';
import 'package:browser_launcher/modules/browser/core/bloc/browser_bloc.dart';
import 'package:browser_launcher/modules/browser/features/directory_files/presentation/directory_files.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrowserDirecotiresScreen extends StatelessWidget {
  const BrowserDirecotiresScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ...context
            .read<BrowserBloc>()
            .state
            .directories
            .map((e) => WScaleAnimation(
                  onTap: () {
                    context.read<BrowserBloc>().add(GetDirectoryFiles(
                          parentDirectory: e,
                          onSuccess: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => BlocProvider.value(
                                value: context.read<BrowserBloc>(),
                                child: DirectoryFilesScreen(
                                  parentFileName:
                                      e.path.split(Platform.pathSeparator).last,
                                ),
                              ),
                            ));
                          },
                          onFailure: (message) {
                            showErrorSnackBar(
                              context,
                              message: message,
                            );
                          },
                        ));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.folder_outlined,
                          size: 50,
                        ),
                        Text(
                          e.path.split(Platform.pathSeparator).last,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ))
            .toList(),
      ],
    );
  }
}
