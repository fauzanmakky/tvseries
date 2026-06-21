import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_detail_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/pages/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../dummy_data/dummy_objects.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<TvSeriesDetailEvent, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
    registerFallbackValue(const FetchTvSeriesDetail(1));
    registerFallbackValue(const AddTvSeriesWatchlist(testTvSeriesDetail));
    registerFallbackValue(
        const RemoveFromTvSeriesWatchlist(testTvSeriesDetail));
    registerFallbackValue(const LoadTvSeriesWatchlistStatus(1));
    registerFallbackValue(const FetchTvSeriesSeasonDetail(1, 1));
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
      tvSeriesState: RequestState.loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.loaded,
      recommendations: <TvSeries>[],
      isAddedToWatchlist: false,
    ));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
      tvSeriesState: RequestState.loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.loaded,
      recommendations: <TvSeries>[],
      isAddedToWatchlist: true,
    ));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        const TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        ),
        const TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: false,
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
        ),
      ]),
      initialState: const TvSeriesDetailState(
        tvSeriesState: RequestState.loaded,
        tvSeries: testTvSeriesDetail,
        recommendationState: RequestState.loaded,
        recommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(TvSeriesDetailBloc.watchlistAddSuccessMessage),
        findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
      mockBloc,
      Stream.fromIterable([
        const TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        ),
        const TvSeriesDetailState(
          tvSeriesState: RequestState.loaded,
          tvSeries: testTvSeriesDetail,
          recommendationState: RequestState.loaded,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      ]),
      initialState: const TvSeriesDetailState(
        tvSeriesState: RequestState.loaded,
        tvSeries: testTvSeriesDetail,
        recommendationState: RequestState.loaded,
        recommendations: <TvSeries>[],
        isAddedToWatchlist: false,
      ),
    );

    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets('Season section should display loading indicator when season is loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
      tvSeriesState: RequestState.loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.loaded,
      recommendations: <TvSeries>[],
      isAddedToWatchlist: false,
      seasonDetailState: RequestState.loading,
    ));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('Season section should display episode list when season is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
      tvSeriesState: RequestState.loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.loaded,
      recommendations: <TvSeries>[],
      isAddedToWatchlist: false,
      seasonDetailState: RequestState.loaded,
      seasonDetail: testTvSeriesSeason,
      selectedSeason: 1,
    ));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.text('Season & Episodes'), findsOneWidget);
    expect(find.text('Season 1'), findsWidgets);
    expect(find.text('Ep 1 · Winter Is Coming'), findsOneWidget);
  });

  testWidgets('Season section should display error message when season fetch fails',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesDetailState(
      tvSeriesState: RequestState.loaded,
      tvSeries: testTvSeriesDetail,
      recommendationState: RequestState.loaded,
      recommendations: <TvSeries>[],
      isAddedToWatchlist: false,
      seasonDetailState: RequestState.error,
      message: 'Failed to load season',
    ));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesDetailPage(id: 1)));

    expect(find.text('Failed to load season'), findsOneWidget);
  });
}
