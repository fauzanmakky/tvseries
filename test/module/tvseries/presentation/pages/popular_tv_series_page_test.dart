import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/popular_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/pages/popular_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularTvSeriesBloc
    extends MockBloc<PopularTvSeriesEvent, PopularTvSeriesState>
    implements PopularTvSeriesBloc {}

void main() {
  late MockPopularTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularTvSeriesBloc();
    registerFallbackValue(const FetchPopularTvSeries());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const PopularTvSeriesState(state: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const PopularTvSeriesState(
      state: RequestState.loaded,
      tvSeries: <TvSeries>[],
    ));

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const PopularTvSeriesState(
      state: RequestState.error,
      message: 'Error message',
    ));

    await tester.pumpWidget(makeTestableWidget(const PopularTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
