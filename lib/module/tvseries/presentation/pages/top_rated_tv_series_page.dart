import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/widgets/tv_series_card.dart';

class TopRatedTvSeriesPage extends StatelessWidget {
  const TopRatedTvSeriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Rated TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedTvSeriesBloc, TopRatedTvSeriesState>(
          builder: (context, state) {
            if (state.state == RequestState.loading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state.state == RequestState.loaded) {
              return ListView.builder(
                itemCount: state.tvSeries.length,
                itemBuilder: (context, index) =>
                    TvSeriesCard(state.tvSeries[index]),
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
