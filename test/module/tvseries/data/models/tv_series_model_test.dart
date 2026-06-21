import 'package:flutter_test/flutter_test.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_model.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';

void main() {
  const tTvSeriesModel = TvSeriesModel(
    id: 1,
    name: 'Stranger Things',
    overview: 'When a young boy vanishes, a small town uncovers a mystery.',
    posterPath: '/path.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.6,
    voteCount: 14000,
    popularity: 369.0,
    firstAirDate: '2016-07-15',
    genreIds: [18, 9648],
    originalName: 'Stranger Things',
  );

  const tTvSeries = TvSeries(
    id: 1,
    name: 'Stranger Things',
    overview: 'When a young boy vanishes, a small town uncovers a mystery.',
    posterPath: '/path.jpg',
    backdropPath: '/backdrop.jpg',
    voteAverage: 8.6,
    voteCount: 14000,
    popularity: 369.0,
    firstAirDate: '2016-07-15',
    genreIds: [18, 9648],
    originalName: 'Stranger Things',
  );

  test('should be a subclass of TvSeries entity', () {
    final result = tTvSeriesModel.toEntity();
    expect(result, tTvSeries);
  });
}
