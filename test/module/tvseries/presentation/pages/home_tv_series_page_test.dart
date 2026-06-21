import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_list_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/pages/home_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesListBloc
    extends MockBloc<TvSeriesListEvent, TvSeriesListState>
    implements TvSeriesListBloc {}

void main() {
  late MockTvSeriesListBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSeriesListBloc();
    registerFallbackValue(const FetchOnAirTvSeries());
    registerFallbackValue(const FetchTvSeriesListPopular());
    registerFallbackValue(const FetchTvSeriesListTopRated());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesListBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display loading indicator when on air is loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesListState(
      onAirState: RequestState.loading,
      popularState: RequestState.loading,
      topRatedState: RequestState.loading,
    ));

    await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsWidgets);
  });

  testWidgets('Page should display ListView when on air data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesListState(
      onAirState: RequestState.loaded,
      onAirTvSeries: <TvSeries>[],
      popularState: RequestState.loaded,
      popularTvSeries: <TvSeries>[],
      topRatedState: RequestState.loaded,
      topRatedTvSeries: <TvSeries>[],
    ));

    await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

    expect(find.byType(ListView), findsWidgets);
  });

  testWidgets('Page should display error text when on air failed',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesListState(
      onAirState: RequestState.error,
      popularState: RequestState.error,
      topRatedState: RequestState.error,
      message: 'Failed',
    ));

    await tester.pumpWidget(makeTestableWidget(const HomeTvSeriesPage()));

    expect(find.text('Failed'), findsWidgets);
  });
}
