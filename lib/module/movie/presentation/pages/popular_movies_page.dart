import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:tvseries/module/movie/presentation/widgets/movie_card_list.dart';

class PopularMoviesPage extends StatelessWidget {
  static const routeName = '/popular-movie';

  const PopularMoviesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular Movies')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularMoviesBloc, PopularMoviesState>(
          builder: (context, state) {
            if (state.state == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) =>
                    MovieCard(state.movies[index]),
                itemCount: state.movies.length,
              );
            }
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          },
        ),
      ),
    );
  }
}
