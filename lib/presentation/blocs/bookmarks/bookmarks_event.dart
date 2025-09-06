import 'package:equatable/equatable.dart';

abstract class BookmarksEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadBookmarksEvent extends BookmarksEvent {}

class ToggleBookmarkEvent extends BookmarksEvent {
  final int movieId;

  ToggleBookmarkEvent(this.movieId);

  @override
  List<Object?> get props => [movieId];
}
