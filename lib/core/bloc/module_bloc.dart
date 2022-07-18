import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:browser_launcher/core/data/app_functions.dart';
import 'package:browser_launcher/core/models/module_status/module_state.dart';
import 'package:browser_launcher/core/repository/module_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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
        if (path == null || path.isEmpty) {
          emit(state.copyWith(status: ModuleStatus.browser, filePath: ''));
        } else {
          try {
            var correctPath = '';
            await AppFunctions.checkStoragePermission();
            final baseUrl = await AppFunctions.getBaseAppDirectoryUrl();
            if (Platform.isAndroid) {
              correctPath = path.split('0/')[1];
            } else if (Platform.isIOS) {}
            emit(
              state.copyWith(
                status: ModuleStatus.fileLauncher,
                filePath: '$baseUrl/$correctPath',
              ),
            );
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
        // await AppFunctions.checkManageStoragePermission();
        await AppFunctions.checkStoragePermission();
        await _repository.getModuleStatus();
      } catch (e) {
        emit(state.copyWith(
          status: ModuleStatus.accessDenied,
          filePath: '',
        ));
        event.onFailure('$e');
      }
    });

    on<FilePathChanged>((event, emit) {
      emit(state.copyWith(filePath: event.name));
      event.onSuccess();
    });
  }

  @override
  Future<void> close() {
    _streamSubscription.cancel();
    return super.close();
  }
}
