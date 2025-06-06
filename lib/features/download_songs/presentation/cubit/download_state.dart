part of 'download_cubit.dart';

abstract class DownloadState extends Equatable {
  const DownloadState();

  @override
  List<Object?> get props => [];
}

class DownloadListInitial extends DownloadState {}

class DownloadListLoading extends DownloadState {}

class Downloading extends DownloadState {
 final int ?id;
  const Downloading({this.id});
}

class IsDownloadedLoading extends DownloadState {}

class IsDownloadedLoaded extends DownloadState {}
class DownloadingProgress extends DownloadState {  // ✅ New state for progress
  final int id;
  final double progress;
  const DownloadingProgress({required this.id, required this.progress});

  @override
  List<Object> get props => [id, progress];
}
class Downloaded extends DownloadState {}

class DownloadListLoaded extends DownloadState {
  const DownloadListLoaded();

  @override
  List<Object?> get props => [];
}

class DownloadListSaved extends DownloadState {
  const DownloadListSaved();

  @override
  List<Object?> get props => [];
}

class DownloadListError extends DownloadState {
  final String? message;
  const DownloadListError({this.message});
  @override
  List<Object?> get props => [message];
}
