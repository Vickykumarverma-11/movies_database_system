import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../di/injection.dart';
import '../../domain/usecases/search_movies.dart';
import '../../core/utils/constants.dart';
import '../blocs/search/search_bloc.dart';
import '../blocs/search/search_event.dart';
import '../blocs/search/search_state.dart';
import '../../domain/entities/movie.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SearchBloc(searchMovies: sl<SearchMovies>()),
      child: const Scaffold(
        backgroundColor: Colors.black,
        appBar: SearchAppBar(),
        body: SearchView(),
      ),
    );
  }
}

class SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        "Search Movies",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _controller,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search movies...",
              hintStyle: TextStyle(color: Colors.white60),
              filled: true,
              fillColor: Colors.grey[900],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.search, color: Colors.white70),
            ),
            onChanged: (query) {
              context.read<SearchBloc>().add(SearchQueryChanged(query));
            },
          ),
        ),
        // Search results
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.deepPurpleAccent,
                  ),
                );
              } else if (state.error != null) {
                return Center(
                  child: Text(
                    "Error: ${state.error}",
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                );
              } else if (state.results.isEmpty) {
                return const Center(
                  child: Text(
                    "No movies found",
                    style: TextStyle(color: Colors.white70),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.results.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final Movie movie = state.results[index];
                  final posterUrl = movie.posterPath != null
                      ? '${Constants.imageBaseUrl}${movie.posterPath}'
                      : null;

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          blurRadius: 6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: posterUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                posterUrl,
                                width: 60,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              width: 60,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey[800],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.movie,
                                size: 40,
                                color: Colors.white60,
                              ),
                            ),
                      title: Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: movie.overview.isNotEmpty
                          ? Text(
                              movie.overview,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white60),
                            )
                          : null,
                      onTap: () {
                        Navigator.pushNamed(context, '/movie/${movie.id}');
                      },
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
