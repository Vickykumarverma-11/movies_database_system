import 'package:equatable/equatable.dart';
import '../../../domain/entities/movie.dart';

class SearchState extends Equatable {
  final bool loading;
  final List<Movie> results;
  final String query;
  final String? error;
  const SearchState({
    this.loading = false,
    this.results = const [],
    this.query = '',
    this.error,
  });
  SearchState copyWith({
    bool? loading,
    List<Movie>? results,
    String? query,
    String? error,
  }) => SearchState(
    loading: loading ?? this.loading,
    results: results ?? this.results,
    query: query ?? this.query,
    error: error,
  );
  @override
  List<Object?> get props => [loading, results, query, error];
}
