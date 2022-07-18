part of 'file_renamer_bloc.dart';

class FileRenamerState extends Equatable {
  final FormzStatus status;
  final String url;

  const FileRenamerState({
    required this.status,
    required this.url,
  });

  FileRenamerState copyWith({
    FormzStatus? status,
    String? url,
  }) =>
      FileRenamerState(
        status: status ?? this.status,
        url: url ?? this.url,
      );

  @override
  List<Object> get props => [status, url];
}
