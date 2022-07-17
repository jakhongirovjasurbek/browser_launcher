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
