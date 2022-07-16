import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:browser_launcher/core/models/module_status/module_state.dart';
import 'package:browser_launcher/core/repository/module_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:permission_handler/permission_handler.dart';
part 'module_event.dart';
part 'module_state.dart';

class ModuleBloc extends Bloc<ModuleEvent, ModuleState> {
  final ModuleRepository _repository;

  late StreamSubscription<ModuleStatus> _streamSubscription;
  ModuleBloc({required ModuleRepository repository})
      : _repository = repository,
        super(
          const ModuleState(
            status: ModuleStatus.none,
            filePath: '',
          ),
        ) {
    _streamSubscription = _repository.status.listen((status) {
      add(ModuleStatusChanged(status: status));
    });

    on<ModuleStatusChanged>((event, emit) async {
      if (event.status == ModuleStatus.fileLauncher) {
        final path = await _repository.getFilePath();
        debugPrint('This is path: $path');
        if (path == null || path.isEmpty) {
          emit(state.copyWith(status: ModuleStatus.browser, filePath: ''));
        } else {
          try {
            if (!(await Permission.storage.isGranted)) {
              final status = await Permission.storage.request();
              if (status != PermissionStatus.granted) {
                throw Exception('Permission is denied');
              }
            }

            if (await Permission.storage.isGranted) {
              var correctPath = '';
              if (Platform.isAndroid) {
              correctPath = path;
              }
              final base = await path_provider.getExternalStorageDirectories();
              final folders = base?.first.path.split('/');
              var newPath = '';
              if (folders != null) {
                var i = 0;
                for (final folderName in folders) {
                  if (folderName != 'Android') {
                    if (i == 0) {
                      newPath += folderName;
                      i++;
                    } else {
                      newPath += '/$folderName';
                    }
                  } else {
                    break;
                  }
                }
                
                emit(
                  state.copyWith(
                    status: ModuleStatus.fileLauncher,
                    // filePath: '$newPath$correctPath',
                    filePath: correctPath
                  ),
                );
              } else {
                throw Exception('Folder cannot be found');
              }
            } else {
              throw Exception('Permission is denied');
            }
          } catch (e) {
            emit(state.copyWith(status: ModuleStatus.browser, filePath: ''));
          }
        }
      } else {
        emit(state.copyWith(status: event.status));
      }
    });
    on<GetModuleStatus>((event, emit) async {
      try {
        await _repository.getModuleStatus();
      } catch (e) {
        event.onFailure('$e');
      }
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
