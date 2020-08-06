import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/models/cast_model.dart';

class MoviesProvider {
  String _apikey    = 'bbfb7914ea065584601635ffee2cccb3';
  String _url       = 'api.themoviedb.org';
  String _language  = 'es-ES';

  int _popularesPage = 0;
  bool _loading = false;

  // FIXME: STREAM
  // Nuestra data que vamos a mandar por el flujo
  List<Movie> _populares = new List();
  // Nuestro canal del flujo
  final _popularesStreamController = StreamController<List<Movie>>.broadcast();
  Function(List<Movie>) get popularesSink => _popularesStreamController.sink.add;
  // Emite información cada vez que agregamos, mediante el Sink
  Stream<List<Movie>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Movie>> _procesarRespuesta(Uri url) async {
    final res = await http.get( url );
    final decodedeData = json.decode(res.body);
    // print(decodedeData['results']);
    final movies = new Movies.fromJsonList(decodedeData['results']);
    // print(movies.items[1].title);
    return movies.items;
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key'   : _apikey,
      'language' : _language,
    });
    // Query String
    // - api_key
    // - language
    // - page
    // - region
    // https://api.themoviedb.org/3/movie/now_playing?api_key=bbfb7914ea065584601635ffee2cccb3&language=en-ES&page=1

    return await _procesarRespuesta(url);
  }

  Future<List<Movie>> getPopular() async {

    if (_loading) return [];
    _loading = true;

    _popularesPage++;
    final url = Uri.https(_url, '3/movie/popular', {
      'api_key'   : _apikey,
      'language'  : _language,
      'page'      : _popularesPage.toString(),
    });

    final res = await _procesarRespuesta(url);
    _populares.addAll(res);
    popularesSink(_populares);

    _loading = false;
    return res;
  }

  Future<List<Actor>> getCast( String idMovie ) async {
    final url = Uri.https(_url, '3/movie/$idMovie/credits', {
      'api_key'   : _apikey,
      'language'  : _language,
    });
    final res = await http.get(url);
    final decodedData = json.decode(res.body);
    final cast = new Cast.fromJsonList( decodedData['cast'] );
    return cast.actors;
  }

}
