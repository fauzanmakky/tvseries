import 'package:bloc_test/bloc_test.dart';
import 'package:tvseries/commons/utils/state_enum.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/presentation/bloc/top_rated_movies_bloc.dart';
import 'package:tvseries/module/movie/presentation/pages/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedMoviesBloc
    extends MockBloc<TopRatedMoviesEvent, TopRatedMoviesState>
    implements TopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedMoviesBloc();
    registerFallbackValue(const FetchTopRatedMovies());
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMoviesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state)
        .thenReturn(const TopRatedMoviesState(state: RequestState.loading));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(Center), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TopRatedMoviesState(
      state: RequestState.loaded,
      movies: <Movie>[],
    ));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display error message when error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(const TopRatedMoviesState(
      state: RequestState.error,
      message: 'Error message',
    ));

    await tester.pumpWidget(makeTestableWidget(const TopRatedMoviesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
