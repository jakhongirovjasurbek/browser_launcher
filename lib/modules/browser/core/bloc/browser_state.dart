// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'browser_bloc.dart';

class BrowserState extends Equatable {
  final FormzStatus folderstatus;
  final FormzStatus fileStatus;
  final List<Directory> directories;
  final List<FileSystemEntity> directoryFiles;

  const BrowserState({
    required this.folderstatus,
    required this.fileStatus,
    required this.directories,
    required this.directoryFiles,
  });

  BrowserState copyWith({
    FormzStatus? folderstatus,
    FormzStatus? fileStatus,
    List<Directory>? directories,
    List<FileSystemEntity>? directoryFiles,
  }) =>
      BrowserState(
        folderstatus: folderstatus ?? this.folderstatus,
        directories: directories ?? this.directories,
        directoryFiles: directoryFiles ?? this.directoryFiles,
        fileStatus: fileStatus ?? this.fileStatus,
      );

  @override
  List<Object> get props =>
      [folderstatus, fileStatus, directories, directoryFiles];
}
