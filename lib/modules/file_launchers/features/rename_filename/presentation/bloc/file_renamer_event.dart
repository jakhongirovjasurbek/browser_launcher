part of 'file_renamer_bloc.dart';

abstract class FileRenamerEvent extends Equatable {
  const FileRenamerEvent();

  @override
  List<Object> get props => [];
}

class RenameFileUri extends FileRenamerEvent {
  final String newUrl;
  final String oldUrl;
  final ValueChanged<String> onSuccess;
  final ValueChanged<String> onFailure;

  const RenameFileUri({
    required this.newUrl,
    required this.oldUrl,
    required this.onSuccess,
    required this.onFailure,
  });
}
