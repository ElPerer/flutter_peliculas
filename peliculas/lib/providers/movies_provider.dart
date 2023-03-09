

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/helpers/debouncers.dart';
import 'package:peliculas/models/models.dart';
import 'package:peliculas/models/search_response.dart';

class MoviesProvider extends ChangeNotifier{

  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '84c5e4470d92992987d8b1115a4fe8c2';
  final String _lenguaje = 'es-ES';

  List<Movie> onDisplayMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};
  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 500),
  );

  final StreamController<List<Movie>> _suggestionStreamController = StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestionStreamController.stream;

  MoviesProvider(){
    getOnDisplayMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    var url = Uri.https(_baseUrl, endpoint, 
      {
        'api_key': _apiKey,
        'lenguage': _lenguaje,
        'page': '$page'
      });
    final response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);
    // final Map<String, dynamic> decodedData = json.decode(response.body);

    onDisplayMovies = nowPlayingResponse.results;

    //Redibuja los compoenntes necesarios cuando la información cambia
    notifyListeners();

  }

  getPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);
    // final Map<String, dynamic> decodedData = json.decode(response.body);

    popularMovies = [...popularMovies, ...popularResponse.results];
    //Redibuja los compoenntes necesarios cuando la información cambia
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if(moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>>searchMovies(String query) async{
    final url = Uri.https(_baseUrl, '3/search/movie', 
      {
        'api_key': _apiKey,
        'lenguage': _lenguaje,
        'query': query
      });

      final response = await http.get(url);
      final searchResponse = SearchResponse.fromJson(response.body);

      return searchResponse.results;
  }

  void getSuggestionsByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async{
      final results = await searchMovies(value);
      _suggestionStreamController.add(results);
    };
    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) { 
      debouncer.value = query;
    });
    Future.delayed(const Duration(milliseconds: 301)).then((_) => timer.cancel());

  }
}