import 'package:browser_launcher/core/widgets/popus/snackbars.dart';
import 'package:browser_launcher/modules/file_launchers/core/bloc/file_launcher_bloc.dart';
import 'package:browser_launcher/modules/file_launchers/core/models/launcher_file_types.dart';
import 'package:browser_launcher/modules/file_launchers/features/image_opener/presentation/image_opener_screen.dart';
import 'package:browser_launcher/modules/file_launchers/features/unknown_type_handler/presentation/unknown_file_handler_screen.dart';
import 'package:browser_launcher/modules/file_launchers/features/video_player/presentation/video_player_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:open_file/open_file.dart';

import 'features/pdf_reader/presentation/pdf_reader_screen.dart';

class FileLaunchers extends StatelessWidget {
  final String filePath;
  const FileLaunchers({
    required this.filePath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FileLauncherBloc()
        ..add(GetFileType(
          filePath: filePath,
          onSuccess: () {},
          onFailure: (message) {
            showErrorSnackBar(context, message: message);
          },
        )),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('File Browser'),
        ),
        body: BlocConsumer<FileLauncherBloc, FileLauncherState>(
          listener: (context, state) {
            if (state.type == LauncherFileTypes.other) {
              showOptionDialog(context);
            }
          },
          builder: (context, state) {
            if (state.status == FormzStatus.submissionInProgress) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (state.status == FormzStatus.submissionSuccess) {
              if (state.type == LauncherFileTypes.image) {
                return ImageOpenerScreen(path: state.filePath);
              } else if (state.type == LauncherFileTypes.video) {
                return VideoPlayerScreem(path: state.filePath);
              } else if (state.type == LauncherFileTypes.pdf) {
                return PdfReaderScreen(path: state.filePath);
              } else {
                return const UnknownFileHandlerScreen();
              }
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  void showOptionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        content: Text(
          'We could not recognize or open this file.\n Would you like to open it via native app features?',
          style: Theme.of(context).textTheme.headline1!.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
          textAlign: TextAlign.center,
        ),
        actions: [
          Row(
            children: [
              MaterialButton(
                onPressed: () async {
                  await OpenFile.open(filePath);
                },
                color: Colors.green,
                child: Text(
                  'Yes',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              MaterialButton(
                onPressed: () => Navigator.pop(dialogContext),
                color: Colors.red,
                child: Text(
                  'No',
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
