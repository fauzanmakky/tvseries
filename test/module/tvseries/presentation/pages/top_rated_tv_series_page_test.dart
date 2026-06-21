import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/top_rated_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/pages/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedTvSeriesBloc
    extends MockBloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState>
    implements TopRatedTvSeriesBloc {}

void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTvSeriesBloc();
    registerFallbackValue(const FetchTopRatedTvSeries());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const TopRatedTvSeriesState(state: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TopRatedTvSeriesState(
      state: RequestState.loaded,
      tvSeries: <TvSeries>[],
    ));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TopRatedTvSeriesState(
      state: RequestState.error,
      message: 'Error message',
    ));

    await tester.pumpWidget(makeTestableWidget(const TopRatedTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
