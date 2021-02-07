import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/images_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;
import 'package:peliculas/src/models/peopleImage_model.dart';
import 'package:peliculas/src/models/people_model.dart';

class PeliculasProvider{
  String _apiKey="3e2dd5809035a20cf8660785fe07d254";
  String _url="api.themoviedb.org";
  String _language="es-ES";

  int _popularesPage=0;
  bool _cargando=false;

  List<Pelicula> _populares=[];

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();
  
  Function(List<Pelicula>) get popularesSink =>_popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream =>_popularesStreamController.stream;

  void disposeStreams(){
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _procesarRespuesta(Uri uri) async{
    Peliculas peliculas= Peliculas();
    try{
      final respuesta= await http.get(uri);
      final decodedData= json.decode(respuesta.body);

      peliculas= Peliculas.fromJsonList(decodedData["results"]);
      
    }catch(err){
      print('Error');
      print(err.toString());
    }
    return peliculas.items;
    
  }

  Future<List<Pelicula>> getEnCines() async{
    final url=Uri.https(_url,"3/movie/now_playing", {
      'api_key': _apiKey,
      'language':_language
    });
    return await _procesarRespuesta(url);
  }

  Future<List<Pelicula>> getPopulares() async{
    if(_cargando) return [];
    _cargando=true;
    _popularesPage++;

    final url=Uri.https(_url,"3/movie/popular", {
      'api_key': _apiKey,
      'language':_language,
      'page':_popularesPage.toString()
    });

    final resp= await _procesarRespuesta(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando=false;
    return resp;
  }

  Future<List<Actor>> getCast(String peliId) async{
    final url=Uri.https(_url, "3/movie/$peliId/credits",{
      'api_key': _apiKey,
      'language':_language,
    });

    final resp= await http.get(url);
    final decodeData=json.decode(resp.body);

    final Cast cast= Cast.fromJsonList(decodeData["cast"]);
    return cast.actores;
  }

  Future<List<Pelicula>> buscarPelicula(String query) async{
    final url=Uri.https(_url,"3/search/movie", {
      'api_key': _apiKey,
      'language':_language,
      'query' : query
    });
    return await _procesarRespuesta(url);
  }

  Future<People> getPeople(int peopleId) async{
    final url=Uri.https(_url, "3/person/$peopleId",{
      'api_key': _apiKey,
      'language':_language,
    });
    final resp= await http.get(url);
    final decodeData=json.decode(resp.body);
    
    final People people= People.fromJson(decodeData);
    return people;
  }

  Future<ImagesModel> getImagesPeople(int peopleId) async{
    final url=Uri.https(_url, "3/person/$peopleId/images",{
      'api_key': _apiKey,
      'language':_language,
    });
    final resp= await http.get(url);
    final decodeData=json.decode(resp.body);
    final ImagesModel images=ImagesModel.fromJson(decodeData);
    return images;
  }

  Future<PeopleImage> getPeopleImage(int peopleId) async{
    final url=Uri.https(_url, "3/person/$peopleId",{
      'api_key': _apiKey,
      'language':_language,
    });
    final resp= await http.get(url);
    final decodeData=json.decode(resp.body);
    final People people= People.fromJson(decodeData);

    final url2=Uri.https(_url, "3/person/$peopleId/images",{
      'api_key': _apiKey,
      'language':_language,
    });
    final resp2= await http.get(url2);
    final decodeData2=json.decode(resp2.body);
    final ImagesModel images=ImagesModel.fromJson(decodeData2);
    return PeopleImage(people: people,imagesModel: images);
  }



}