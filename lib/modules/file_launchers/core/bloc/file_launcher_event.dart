part of 'file_launcher_bloc.dart';

abstract class FileLauncherEvent with EquatableMixin {
  const FileLauncherEvent();

  @override
  List<Object> get props => [];
}

class GetFileType extends FileLauncherEvent {
  final String filePath;
  final VoidCallback onSuccess;
  final ValueChanged<String> onFailure;

  const GetFileType({
    required this.filePath,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  List<Object> get props => [];
}
