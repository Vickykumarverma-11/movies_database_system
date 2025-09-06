import 'package:flutter_bloc/flutter_bloc.dart';
import 'bookmarks_event.dart';
import 'bookmarks_state.dart';
import '../../../domain/usecases/get_bookmarks.dart';
import '../../../domain/usecases/toggle_bookmark.dart';

class BookmarksBloc extends Bloc<BookmarksEvent, BookmarksState> {
  final GetBookmarks getBookmarks;
  final ToggleBookmark toggleBookmark;

  BookmarksBloc({required this.getBookmarks, required this.toggleBookmark})
    : super(BookmarksInitial()) {
    on<LoadBookmarksEvent>((event, emit) async {
      emit(BookmarksLoading());
      try {
        final movies = await getBookmarks();
        emit(BookmarksLoaded(movies));
      } catch (e) {
        emit(BookmarksError(e.toString()));
      }
    });

    on<ToggleBookmarkEvent>((event, emit) async {
      await toggleBookmark(event.movieId);
      add(LoadBookmarksEvent()); // refresh list
    });
  }
}
