import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:browser_launcher/core/data/app_functions.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:formz/formz.dart';
part 'browser_event.dart';
part 'browser_state.dart';

class BrowserBloc extends Bloc<BrowserEvent, BrowserState> {
  BrowserBloc()
      : super(
          const BrowserState(
            folderstatus: FormzStatus.pure,
            fileStatus: FormzStatus.pure,
            directories: [],
            directoryFiles: [],
          ),
        ) {
    on<GetDirectories>((event, emit) async {
      emit(state.copyWith(folderstatus: FormzStatus.submissionInProgress));
      try {
        AppFunctions.checkStoragePermission();
        var dirToDownloads = await AppFunctions.getBaseAppDirectoryUrl();
        late Directory downloadsFolder;
        if (Platform.isAndroid) {
          downloadsFolder = Directory('$dirToDownloads/Download');
        } else if (Platform.isIOS) {
          downloadsFolder = Directory('$dirToDownloads');
        }
        if (await Directory(dirToDownloads!).exists()) {
          print('This folder exists');
          print(Directory(dirToDownloads).listSync());
        }
        final appFolder = Directory('$dirToDownloads/BrowserLauncher');

        if (!(await appFolder.exists())) {
          AppFunctions.checkManageStoragePermission();
          await appFolder.create(recursive: true);
        }
        emit(state.copyWith(
            folderstatus: FormzStatus.submissionSuccess,
            directories: [downloadsFolder, appFolder]));

        if (appFolder.listSync().isEmpty) {
          AppFunctions.checkManageStoragePermission();
          for (var downloadsFolderItem in downloadsFolder.listSync()) {
            if (!Directory(downloadsFolderItem.uri.path).existsSync()) {
              await File(
                downloadsFolderItem.path,
              ).copy(
                '${appFolder.path}/${downloadsFolderItem.path.split(Platform.pathSeparator).last}',
              );
            } else {
              Directory(downloadsFolderItem.uri.path)
                  .listSync()
                  .forEach((element) {
                print(element);
              });
            }
          }
        } else if (appFolder.listSync().length <
            downloadsFolder.listSync().length) {
          AppFunctions.checkManageStoragePermission();
          final filesInDownloads = downloadsFolder.listSync();
          final filesInAppFolder = appFolder.listSync();
          final fileNamesInDownloadFolder = filesInDownloads
              .map((e) => e.path.split(Platform.pathSeparator).last)
              .toList();
          final fileNamesInAppFolder = filesInAppFolder
              .map((e) => e.path.split(Platform.pathSeparator).last)
              .toList();

          for (var i = 0; i < fileNamesInDownloadFolder.length; i++) {
            if (fileNamesInAppFolder.contains(fileNamesInDownloadFolder[i])) {
            } else {
              if (Directory(
                      '${downloadsFolder.path}/${fileNamesInDownloadFolder[i]}')
                  .existsSync()) {
              } else {
                await File(
                  '${downloadsFolder.path}/${fileNamesInDownloadFolder[i]}',
                ).copy(
                  '${appFolder.path}/${fileNamesInDownloadFolder[i]}',
                );
              }
            }
          }
        }
        event.onSuccess();
      } catch (e) {
        AppFunctions.checkStoragePermission();
        var dirToDownloads = await AppFunctions.getBaseAppDirectoryUrl();
        final downloadsFolder = Directory('$dirToDownloads/Download');
        if (downloadsFolder.existsSync()) {
          emit(state.copyWith(
              folderstatus: FormzStatus.submissionSuccess,
              directories: [
                downloadsFolder,
              ]));
        } else {
          emit(state.copyWith(folderstatus: FormzStatus.submissionFailure));
        }
        event.onFailure('$e');
      }
    });

    on<GetDirectoryFiles>((event, emit) async {
      emit(state.copyWith(fileStatus: FormzStatus.submissionInProgress));
      try {
        AppFunctions.checkStoragePermission();

        final folderFiles = event.parentDirectory.listSync();
        emit(state.copyWith(
          fileStatus: FormzStatus.submissionSuccess,
          directoryFiles: folderFiles,
        ));
        event.onSuccess();
      } catch (e) {
        emit(state.copyWith(fileStatus: FormzStatus.submissionFailure));
        event.onFailure('$e');
      }
    });
  }
}
