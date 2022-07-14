import 'package:bloc/bloc.dart';
import 'package:browser_launcher/modules/file_launchers/core/data/functions/functions.dart';
import 'package:browser_launcher/modules/file_launchers/core/models/launcher_file_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

part 'file_launcher_event.dart';
part 'file_launcher_state.dart';

class FileLauncherBloc extends Bloc<FileLauncherEvent, FileLauncherState> {
  FileLauncherBloc()
      : super(
          const FileLauncherState(
            type: LauncherFileTypes.none,
            status: FormzStatus.pure,
            filePath: '',
          ),
        ) {
    on<GetFileType>((event, emit) {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      final type = LauncherFunctions.getFileType(path: event.filePath);
      emit(state.copyWith(
        type: type,
        filePath: event.filePath,
        status: FormzStatus.submissionSuccess,
      ));
    });
  }
}
