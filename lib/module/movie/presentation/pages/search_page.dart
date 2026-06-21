import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/commons/constants/api_constants.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_search_bloc.dart';
import 'package:tvseries/module/movie/presentation/widgets/movie_card_list.dart';

class SearchPage extends StatelessWidget {
  static const routeName = '/search';

  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) =>
                  context.read<MovieSearchBloc>().add(SearchMoviesEvent(query)),
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<MovieSearchBloc, MovieSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == RequestState.loaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemBuilder: (context, index) =>
                          MovieCard(state.searchResult[index]),
                      itemCount: state.searchResult.length,
                    ),
                  );
                }
                return const Expanded(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }
}
