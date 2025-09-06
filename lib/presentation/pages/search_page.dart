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
      child: Scaffold(
        appBar: AppBar(title: const Text("Search Movies")),
        body: const SearchView(),
      ),
    );
  }
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Search movies...",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              // Trigger search as user types
              context.read<SearchBloc>().add(SearchQueryChanged(query));
            },
          ),
        ),
        Expanded(
          child: BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.error != null) {
                return Center(child: Text("Error: ${state.error}"));
              } else if (state.results.isEmpty) {
                return const Center(child: Text("No movies found"));
              }

              return ListView.separated(
                itemCount: state.results.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final Movie movie = state.results[index];
                  final posterUrl = movie.posterPath != null
                      ? '${Constants.imageBaseUrl}${movie.posterPath}'
                      : null;

                  return ListTile(
                    leading: posterUrl != null
                        ? Image.network(
                            posterUrl,
                            width: 60,
                            height: 90,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 60,
                            height: 90,
                            color: Colors.grey,
                            child: const Icon(Icons.movie, size: 40),
                          ),
                    title: Text(movie.title),
                    subtitle: movie.overview.isNotEmpty
                        ? Text(
                            movie.overview,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    onTap: () {
                      // Navigate to MovieDetailPage
                      Navigator.pushNamed(context, '/movie/${movie.id}');
                    },
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
