part of 'browser_bloc.dart';

abstract class BrowserEvent extends Equatable {
  const BrowserEvent();

  @override
  List<Object> get props => [];
}

class GetDirectories extends BrowserEvent {
  final VoidCallback onSuccess;
  final ValueChanged<String> onFailure;

  const GetDirectories({required this.onSuccess, required this.onFailure});
}

class GetDirectoryFiles extends BrowserEvent {
  final Directory parentDirectory;
  final VoidCallback onSuccess;
  final ValueChanged<String> onFailure;

  const GetDirectoryFiles({
    required this.parentDirectory,
    required this.onSuccess,
    required this.onFailure,
  });
}
