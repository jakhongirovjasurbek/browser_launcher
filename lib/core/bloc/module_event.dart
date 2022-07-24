part of 'module_bloc.dart';

abstract class ModuleEvent with EquatableMixin {
  const ModuleEvent();
}

class GetModuleStatus extends ModuleEvent {
  final VoidCallback onSuccess;
  final ValueChanged<String> onFailure;

  const GetModuleStatus({
    required this.onSuccess,
    required this.onFailure,
  });
  @override
  List<Object?> get props => [onSuccess, onFailure];
}

class ModuleStatusChanged extends ModuleEvent {
  final ModuleStatus status;

  const ModuleStatusChanged({required this.status});

  @override
  List<Object?> get props => [status];
}

class ModuleStateChangedOnIntent extends ModuleEvent {
  final String fileUri;

  const ModuleStateChangedOnIntent(this.fileUri);

  @override
  List<Object?> get props => [fileUri];
}

class FilePathChanged extends ModuleEvent {
  final String name;
  final VoidCallback onSuccess;
  final ValueChanged<String> onError;

  FilePathChanged({
    required this.name,
    required this.onSuccess,
    required this.onError,
  });
  @override
  List<Object?> get props => [];
}

class ModuleStatusChangedOnShareIntent extends ModuleEvent {
  final String path;

  const ModuleStatusChangedOnShareIntent({required this.path});

  @override
  List<Object?> get props => [path];
}
