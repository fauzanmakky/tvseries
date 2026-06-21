import 'package:tvseries/module/movie/data/model/movie_table.dart';
import 'package:tvseries/module/movie/domain/entity/genre_entity.dart';
import 'package:tvseries/module/movie/domain/entity/movie_entity.dart';
import 'package:tvseries/module/movie/domain/entity/movie_detail_entity.dart';
import 'package:tvseries/module/tvseries/data/model/tv_series_table.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_detail_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_episode_entity.dart';
import 'package:tvseries/module/tvseries/domain/entity/tv_series_season_entity.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [const Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'originalTitle',
  overview: 'overview',
  posterPath: 'posterPath',
  releaseDate: 'releaseDate',
  runtime: 120,
  title: 'title',
  voteAverage: 1,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieTable = MovieTable(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
);

const testMovieMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
};

// TV Series test data
const testTvSeries = TvSeries(
  id: 1,
  name: 'Stranger Things',
  overview: 'When a young boy vanishes, a small town uncovers a mystery.',
  posterPath: '/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
  backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
  voteAverage: 8.6,
  voteCount: 14000,
  popularity: 369.0,
  firstAirDate: '2016-07-15',
  genreIds: [18, 9648],
  originalName: 'Stranger Things',
);

final testTvSeriesList = [testTvSeries];

const testTvSeriesDetail = TvSeriesDetail(
  id: 1,
  name: 'Stranger Things',
  originalName: 'Stranger Things',
  overview: 'When a young boy vanishes, a small town uncovers a mystery.',
  posterPath: '/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
  backdropPath: '/56v2KjBlU4XaOv9rVYEQypROD7P.jpg',
  genres: [Genre(id: 18, name: 'Drama')],
  numberOfEpisodes: 34,
  numberOfSeasons: 4,
  voteAverage: 8.6,
  voteCount: 14000,
  firstAirDate: '2016-07-15',
  status: 'Ended',
);

const testTvSeriesEpisode = TvSeriesEpisode(
  id: 63056,
  name: 'Winter Is Coming',
  overview: 'Jon Arryn, the Hand of the King, is dead.',
  stillPath: '/9hGF3WUkBf7cSjMg0cdMDHJkByd.jpg',
  airDate: '2011-04-17',
  episodeNumber: 1,
  seasonNumber: 1,
  runtime: 62,
  voteAverage: 8.1,
);

const testTvSeriesSeason = TvSeriesSeason(
  id: 3624,
  name: 'Season 1',
  airDate: '2011-04-17',
  seasonNumber: 1,
  overview: 'Trouble is brewing in the Seven Kingdoms of Westeros.',
  posterPath: '/wgfKiqzuMrFIkU1M68DDDY8kGC1.jpg',
  voteAverage: 8.4,
  episodes: [testTvSeriesEpisode],
);

const testTvSeriesTable = TvSeriesTable(
  id: 1,
  name: 'Stranger Things',
  posterPath: '/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
  overview: 'When a young boy vanishes, a small town uncovers a mystery.',
);

const testTvSeriesMap = {
  'id': 1,
  'name': 'Stranger Things',
  'posterPath': '/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
  'overview': 'When a young boy vanishes, a small town uncovers a mystery.',
};

final testWatchlistTvSeries = TvSeries(
  id: 1,
  name: 'Stranger Things',
  overview: 'When a young boy vanishes, a small town uncovers a mystery.',
  posterPath: '/x2LSRK2Cm7MZhjluni1msVJ3wDF.jpg',
  backdropPath: null,
  voteAverage: null,
  voteCount: null,
  popularity: null,
  firstAirDate: null,
  genreIds: null,
  originalName: null,
);
