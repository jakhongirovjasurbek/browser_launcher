part of 'module_bloc.dart';

class ModuleState with EquatableMixin {
  final ModuleStatus status;
  final String filePath;
  const ModuleState({
    required this.status,
    required this.filePath,
  });

  ModuleState copyWith({
    ModuleStatus? status,
    String? filePath,
  }) =>
      ModuleState(
        status: status ?? this.status,
        filePath: filePath ?? this.filePath,
      );

  @override
  List<Object?> get props => [status, filePath];
}
