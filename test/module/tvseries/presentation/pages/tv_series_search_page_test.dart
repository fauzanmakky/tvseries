import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/tv_series_search_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/pages/tv_series_search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTvSeriesSearchBloc
    extends MockBloc<TvSeriesSearchEvent, TvSeriesSearchState>
    implements TvSeriesSearchBloc {}

void main() {
  late MockTvSeriesSearchBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSeriesSearchBloc();
    registerFallbackValue(const SearchTvSeriesEvent(''));
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesSearchBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const TvSeriesSearchState(state: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesSearchPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TvSeriesSearchState(
      state: RequestState.loaded,
      searchResult: <TvSeries>[],
    ));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesSearchPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display empty container when initial state',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const TvSeriesSearchState(state: RequestState.empty));

    await tester.pumpWidget(makeTestableWidget(const TvSeriesSearchPage()));

    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.byType(ListView), findsNothing);
  });
}
