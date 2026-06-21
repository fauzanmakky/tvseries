import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/presentation/bloc/on_air_tv_series_bloc.dart';
import 'package:tvseries/module/tvseries/presentation/pages/on_air_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOnAirTvSeriesBloc
    extends MockBloc<OnAirTvSeriesEvent, OnAirTvSeriesState>
    implements OnAirTvSeriesBloc {}

void main() {
  late MockOnAirTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockOnAirTvSeriesBloc();
    registerFallbackValue(const FetchOnAirTvSeriesList());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<OnAirTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const OnAirTvSeriesState(state: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(const OnAirTvSeriesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const OnAirTvSeriesState(
      state: RequestState.loaded,
      tvSeries: <TvSeries>[],
    ));

    await tester.pumpWidget(makeTestableWidget(const OnAirTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const OnAirTvSeriesState(
      state: RequestState.error,
      message: 'Error message',
    ));

    await tester.pumpWidget(makeTestableWidget(const OnAirTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
