import 'dart:io';

import 'package:browser_launcher/core/data/app_functions.dart';
import 'package:browser_launcher/core/widgets/popus/snackbars.dart';
import 'package:browser_launcher/core/widgets/w_bottomsheet.dart';
import 'package:browser_launcher/core/widgets/w_button.dart';
import 'package:browser_launcher/modules/file_launchers/core/bloc/file_launcher_bloc.dart';
import 'package:browser_launcher/modules/file_launchers/core/models/launcher_file_types.dart';
import 'package:browser_launcher/modules/file_launchers/features/image_opener/presentation/image_opener_screen.dart';
import 'package:browser_launcher/modules/file_launchers/features/rename_filename/presentation/bloc/file_renamer_bloc.dart';
import 'package:browser_launcher/modules/file_launchers/features/rename_filename/presentation/rename_file.dart';
import 'package:browser_launcher/modules/file_launchers/features/unknown_type_handler/presentation/unknown_file_handler_screen.dart';
import 'package:browser_launcher/modules/file_launchers/features/video_player/presentation/video_player_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:open_file/open_file.dart';

import 'features/pdf_reader/presentation/pdf_reader_screen.dart';

class FileLaunchers extends StatefulWidget {
  final String filePath;
  const FileLaunchers({
    required this.filePath,
    Key? key,
  }) : super(key: key);

  @override
  State<FileLaunchers> createState() => _FileLaunchersState();
}

class _FileLaunchersState extends State<FileLaunchers>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {});
  }

  late FileRenamerBloc fileRenamerBloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fileRenamerBloc = FileRenamerBloc();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
    fileRenamerBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FileLauncherBloc()
            ..add(GetFileType(
              filePath: widget.filePath,
              onSuccess: () {},
              onFailure: (message) {
                showErrorSnackBar(context, message: message);
              },
            )),
        ),
        BlocProvider.value(value: fileRenamerBloc),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            AppFunctions.createLocalNotification();
          },
          child: const Icon(Icons.notifications),
        ),
        appBar: AppBar(
          title: const Text('File Browser'),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocConsumer<FileLauncherBloc, FileLauncherState>(
                listener: (context, state) {
                  if (state.type == LauncherFileTypes.other) {
                    // showOptionDialog(context);
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
                      return UnknownFileHandlerScreen(path: state.filePath);
                    }
                  }
                  return const SizedBox();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: WButton(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          useRootNavigator: true,
                          isScrollControlled: true,
                          builder: (bottomsheetContext) => Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: WBottomSheet(children: [
                              BlocProvider.value(
                                value: fileRenamerBloc,
                                child: RenameFile(fileName: widget.filePath),
                              ),
                            ]),
                          ),
                        );
                      },
                      text: 'Rename file',
                      color: Colors.green,
                      textStyle:
                          Theme.of(context).textTheme.headline1!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: WButton(
                      onTap: () async {
                        final result =
                            await OpenFile.open(File(widget.filePath).path);
                        if (result.type == ResultType.error ||
                            result.type == ResultType.fileNotFound ||
                            result.type == ResultType.noAppToOpen ||
                            result.type == ResultType.permissionDenied) {
                          showErrorSnackBar(context, message: result.message);
                        }
                        // showOptionDialog(context);
                      },
                      text: 'Open file',
                      color: Colors.blue,
                      textStyle:
                          Theme.of(context).textTheme.headline1!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//   void showOptionDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (dialogContext) => AlertDialog(
//         content: Text(
//           'Do you want to rename this file:\n',
//           style: Theme.of(context).textTheme.headline1!.copyWith(
//                 fontSize: 16,
//                 fontWeight: FontWeight.w500,
//               ),
//           textAlign: TextAlign.center,
//         ),
//         actions: [
//           Row(
//             children: [
//               Expanded(
//                 child: MaterialButton(
//                   onPressed: () async {
//                     Navigator.pop(dialogContext);
//                   },
//                   color: Colors.green,
//                   child: Text(
//                     'Yes',
//                     style: Theme.of(context).textTheme.headline1!.copyWith(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: MaterialButton(
//                   onPressed: () => Navigator.pop(dialogContext),
//                   color: Colors.red,
//                   child: Text(
//                     'No',
//                     style: Theme.of(context).textTheme.headline1!.copyWith(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w500,
//                         ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
