import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../domain/usecases/get_trending_movies.dart';
import '../../../domain/usecases/get_now_playing_movies.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetTrendingMovies getTrending;
  final GetNowPlayingMovies getNowPlaying;

  HomeBloc({required this.getTrending, required this.getNowPlaying})
    : super(const HomeState()) {
    on<LoadHome>((event, emit) async {
      emit(state.copyWith(loading: true, error: null));
      try {
        final t = await getTrending();
        final n = await getNowPlaying();
        emit(state.copyWith(trending: t, nowPlaying: n, loading: false));
      } catch (e) {
        emit(state.copyWith(loading: false, error: e.toString()));
      }
    });
  }
}
