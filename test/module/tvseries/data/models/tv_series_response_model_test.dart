import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_model.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_response_model.dart';

import '../../../../json_reader.dart';

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

  const tTvSeriesResponseModel =
      TvSeriesResponse(tvSeriesList: <TvSeriesModel>[tTvSeriesModel]);

  group('fromJson', () {
    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/tv_on_air.json'));
      final result = TvSeriesResponse.fromJson(jsonMap);
      expect(result, tTvSeriesResponseModel);
    });
  });
}
