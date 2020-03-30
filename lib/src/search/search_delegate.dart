import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate{
  
  String seleccion="";
  final PeliculasProvider peliculasProvider= new PeliculasProvider();

  final peliculas=[
    "uno",
    "dos",
    "tres",
  ];

  final peliculasRecientes =[
    "cuatro",
    "cinco",
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: (){
          query='';
        }
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ), 
      onPressed: (){
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(

    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty){
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
        if(snapshot.hasData){
          final peliculas=snapshot.data;
          
          return ListView(
            children: peliculas.map( (pelicula){
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage("assets/img/no-image.jpg"),
                  image: NetworkImage(pelicula.getPosterBackgroundImg()),
                  width: 50.0,
                  fit: BoxFit.contain,
                  ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: (){
                  close(context, null);
                  pelicula.uniqueID='';
                  Navigator.pushNamed(context, "detalle", arguments: pelicula);
                },
              );
            }).toList(),
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

}