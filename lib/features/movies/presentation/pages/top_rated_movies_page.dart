import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/top_rated/top_rated_movies_bloc.dart';
import '../widgets/movie_card.dart';

class TopRatedMoviesPage extends StatefulWidget {
  const TopRatedMoviesPage({super.key});

  @override
  State<TopRatedMoviesPage> createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<TopRatedMoviesBloc>().add(FetchTopRatedMovies());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMoviesBloc, TopRatedMoviesState>(
          builder: (context, state) {
            if (state is TopRatedMoviesLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TopRatedMoviesHasData) {
              final result = state.result;
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = result[index];
                  return MovieCard(movie);
                },
                itemCount: result.length,
              );
            } else if (state is TopRatedMoviesError) {
              return Center(
                child: Text(key: Key('error_message'), state.message),
              );
            } else {
              return const Center(
                child: Text(key: Key('no_data_message'), 'No Data'),
              );
            }
          },
        ),
      ),
    );
  }
}
