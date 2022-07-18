import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:browser_launcher/core/data/app_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
import 'package:permission_handler/permission_handler.dart';

part 'file_renamer_event.dart';
part 'file_renamer_state.dart';

class FileRenamerBloc extends Bloc<FileRenamerEvent, FileRenamerState> {
  FileRenamerBloc()
      : super(
          const FileRenamerState(
            status: FormzStatus.pure,
            url: '',
          ),
        ) {
    on<RenameFileUri>((event, emit) async {
      emit(state.copyWith(status: FormzStatus.submissionInProgress));
      try {
        if (!(await Permission.storage.isGranted)) {
          Permission.storage.request();
        }
        var lastSeparator = event.oldUrl.lastIndexOf(Platform.pathSeparator);
        var newPath =
            event.oldUrl.substring(0, lastSeparator + 1) + event.newUrl;

        await AppFunctions.checkManageStoragePermission();

        await File(event.oldUrl).rename(newPath);

        emit(state.copyWith(
          status: FormzStatus.submissionSuccess,
          url: newPath,
        ));
        event.onSuccess(newPath);
      } catch (e) {
        try {
          if (!(await Permission.storage.isGranted)) {
            Permission.storage.request();
          }
          var lastSeparator = event.oldUrl.lastIndexOf(Platform.pathSeparator);
          var newPath =
              event.oldUrl.substring(0, lastSeparator + 1) + event.newUrl;
          await File(event.oldUrl).copy(newPath);
          emit(state.copyWith(
            status: FormzStatus.submissionSuccess,
            url: newPath,
          ));
          event.onSuccess(newPath);
        } catch (e) {
          emit(state.copyWith(status: FormzStatus.submissionFailure));
          event.onFailure('$e');
        }
      }
    });
  }
}
