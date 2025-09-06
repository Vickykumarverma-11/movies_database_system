import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

class HomeState extends Equatable {
  final List<Movie> trending;
  final List<Movie> nowPlaying;
  final bool loading;
  final String? error;

  const HomeState({
    this.trending = const [],
    this.nowPlaying = const [],
    this.loading = false,
    this.error,
  });
  HomeState copyWith({
    List<Movie>? trending,
    List<Movie>? nowPlaying,
    bool? loading,
    String? error,
  }) => HomeState(
    trending: trending ?? this.trending,
    nowPlaying: nowPlaying ?? this.nowPlaying,
    loading: loading ?? this.loading,
    error: error,
  );

  @override
  List<Object?> get props => [trending, nowPlaying, loading, error];
}
