import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'search_event.dart';
import 'search_state.dart';
import '../../../domain/usecases/search_movies.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchMovies searchMovies;

  SearchBloc({required this.searchMovies}) : super(const SearchState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: debounce(const Duration(milliseconds: 500)),
    );
  }

  EventTransformer<SearchEvent> debounce<SearchEvent>(Duration duration) {
    return (events, mapper) =>
        events.debounceTime(duration).asyncExpand(mapper);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final q = event.query.trim();
    if (q.isEmpty) {
      emit(state.copyWith(query: q, results: []));
      return;
    }
    emit(state.copyWith(loading: true, query: q));
    try {
      final res = await searchMovies(q, page: 1); // ✅ correct usage
      emit(state.copyWith(loading: false, results: res));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }
}
