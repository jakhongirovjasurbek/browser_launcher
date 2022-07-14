// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'file_launcher_bloc.dart';

class FileLauncherState with EquatableMixin {
  final LauncherFileTypes type;
  final FormzStatus status;
  final String filePath;

  const FileLauncherState({
    required this.type,
    required this.status,
    required this.filePath,
  });

  FileLauncherState copyWith({
    LauncherFileTypes? type,
    FormzStatus? status,
    String? filePath,
  }) =>
      FileLauncherState(
        type: type ?? this.type,
        status: status ?? this.status,
        filePath: filePath ?? this.filePath,
      );

  @override
  List<Object> get props => [type, status, filePath];
}
