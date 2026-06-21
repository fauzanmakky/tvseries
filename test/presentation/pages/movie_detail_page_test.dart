import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:tvseries/module/movie/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc
    extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
    registerFallbackValue(const FetchMovieDetail(1));
    registerFallbackValue(AddWatchlist(testMovieDetail));
    registerFallbackValue(RemoveFromWatchlist(testMovieDetail));
    registerFallbackValue(const LoadWatchlistStatus(1));
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(MovieDetailState(
      movieState: RequestState.loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.loaded,
      movieRecommendations: const <Movie>[],
      isAddedToWatchlist: false,
    ));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(MovieDetailState(
      movieState: RequestState.loaded,
      movie: testMovieDetail,
      recommendationState: RequestState.loaded,
      movieRecommendations: const <Movie>[],
      isAddedToWatchlist: true,
    ));

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loaded,
          movieRecommendations: const <Movie>[],
          isAddedToWatchlist: false,
        ),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loaded,
          movieRecommendations: const <Movie>[],
          isAddedToWatchlist: false,
          watchlistMessage: MovieDetailBloc.watchlistAddSuccessMessage,
        ),
      ]),
      initialState: MovieDetailState(
        movieState: RequestState.loaded,
        movie: testMovieDetail,
        recommendationState: RequestState.loaded,
        movieRecommendations: const <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(MovieDetailBloc.watchlistAddSuccessMessage), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loaded,
          movieRecommendations: const <Movie>[],
          isAddedToWatchlist: false,
        ),
        MovieDetailState(
          movieState: RequestState.loaded,
          movie: testMovieDetail,
          recommendationState: RequestState.loaded,
          movieRecommendations: const <Movie>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ]),
      initialState: MovieDetailState(
        movieState: RequestState.loaded,
        movie: testMovieDetail,
        recommendationState: RequestState.loaded,
        movieRecommendations: const <Movie>[],
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
