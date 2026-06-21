import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/commons/constants/api_constants.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_search_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/widgets/tv_series_card.dart';

class TvSeriesSearchPage extends StatelessWidget {
  const TvSeriesSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              onSubmitted: (query) => context
                  .read<TvSeriesSearchBloc>()
                  .add(SearchTvSeriesEvent(query)),
              decoration: const InputDecoration(
                hintText: 'Search title',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.search,
            ),
            const SizedBox(height: 16),
            Text('Search Result', style: kHeading6),
            BlocBuilder<TvSeriesSearchBloc, TvSeriesSearchState>(
              builder: (context, state) {
                if (state.state == RequestState.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.state == RequestState.loaded) {
                  return Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.searchResult.length,
                      itemBuilder: (context, index) =>
                          TvSeriesCard(state.searchResult[index]),
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
