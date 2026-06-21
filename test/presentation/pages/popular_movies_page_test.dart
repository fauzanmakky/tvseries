import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/presentation/bloc/popular_movies_bloc.dart';
import 'package:tvseries/module/movie/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularMoviesBloc
    extends MockBloc<PopularMoviesEvent, PopularMoviesState>
    implements PopularMoviesBloc {}

void main() {
  late MockPopularMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockPopularMoviesBloc();
    registerFallbackValue(const FetchPopularMovies());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<PopularMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const PopularMoviesState(state: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const PopularMoviesState(
      state: RequestState.loaded,
      movies: <Movie>[],
    ));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const PopularMoviesState(
      state: RequestState.error,
      message: 'Error message',
    ));

    await tester.pumpWidget(makeTestableWidget(const PopularMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
