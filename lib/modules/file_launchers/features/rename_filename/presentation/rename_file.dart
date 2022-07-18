import 'package:browser_launcher/core/bloc/module_bloc.dart';
import 'package:browser_launcher/core/widgets/popus/snackbars.dart';
import 'package:browser_launcher/core/widgets/w_button.dart';
import 'package:browser_launcher/modules/file_launchers/features/rename_filename/presentation/bloc/file_renamer_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

class RenameFile extends StatefulWidget {
  final String fileName;
  const RenameFile({
    required this.fileName,
    Key? key,
  }) : super(key: key);

  @override
  State<RenameFile> createState() => _RenameFileState();
}

class _RenameFileState extends State<RenameFile> {
  late TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(
      text: widget.fileName.split('/')[widget.fileName.split('/').length - 1],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Rename the file:',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
        ),
        TextField(
          autofocus: true,
          controller: controller,
          onChanged: (value) {},
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: BlocBuilder<FileRenamerBloc, FileRenamerState>(
                  builder: (context, state) {
                    return WButton(
                      loading: state.status == FormzStatus.submissionInProgress,
                      onTap: () {
                        context.read<FileRenamerBloc>().add(RenameFileUri(
                              newUrl: controller.text.trim(),
                              oldUrl: widget.fileName,
                              onSuccess: (url) {
                                context.read<ModuleBloc>().add(FilePathChanged(
                                      name: url,
                                      onError: (message) {
                                        Navigator.of(context).pop();
                                      },
                                      onSuccess: () {},
                                    ));
                                showSuccessSnackBar(
                                  context,
                                  message: 'File has renamed successfully!',
                                );
                                Navigator.of(context).pop();
                              },
                              onFailure: (message) {
                                Navigator.of(context).pop();
                                showErrorSnackBar(context, message: message);
                              },
                            ));
                      },
                      text: 'Save',
                      color: Colors.green,
                      textStyle:
                          Theme.of(context).textTheme.headline1!.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: WButton(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  text: 'Discard',
                  color: Colors.red,
                  textStyle: Theme.of(context).textTheme.headline1!.copyWith(
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
    );
  }
}
