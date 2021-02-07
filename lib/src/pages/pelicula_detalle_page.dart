

import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {
  
  
  
  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula=ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppbar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10.0,),
              _posterTitulo(pelicula,context),
              _descripcion(pelicula),
              _crearCasting(pelicula),
            ]),
          )
        ],
      ),

    );
  }

 Widget _crearAppbar(Pelicula pelicula) {
   return SliverAppBar(
     elevation: 2.0,
     backgroundColor: Colors.indigoAccent,
     expandedHeight: 200.0,
     floating: false,
     pinned: true,
     flexibleSpace: FlexibleSpaceBar(
       title: Text(
          pelicula.title,
          style: TextStyle(color:Colors.white,fontSize: 16, ),
        ),
        background: FadeInImage(
          placeholder: AssetImage("assets/img/loading.gif"), 
          image: NetworkImage(pelicula.getPosterBackgroundImg(),),
          fadeInDuration: Duration(milliseconds: 15),
          fit : BoxFit.cover
        ),
     ),
   );
  }

  Widget _posterTitulo(Pelicula pelicula, BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
        child: Row(
          children: <Widget>[
            Hero(
              tag: pelicula.uniqueID,
              child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                  image: NetworkImage(pelicula.getPosterImg()),
                  height: 150.0,
                )
              ),
            ),
            SizedBox(width: 20.0,),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis),
                  Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                  Row(children: [
                    Icon(Icons.date_range),
                    Text(pelicula.releaseDate.toString(),style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis)
                  ]),
                  Row(
                    children: <Widget>[
                      Icon(Icons.star_border),
                      Text(pelicula.voteAverage.toString(),style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis)
                    ],
                  ),
                  Row(children: [
                    Icon(Icons.supervisor_account_outlined ),
                    pelicula.adult?Text('+18',style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis):Text('+0',style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis),
                  ]),
                ],
              )),
          ],
        ),
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text(
          pelicula.overview,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliculaProvider=new PeliculasProvider();
    return FutureBuilder(
      future: peliculaProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if(snapshot.hasData){
          return _crearActoresPageView(snapshot.data);
        }else{
          return Center(child: CircularProgressIndicator(),);
        }
      },
    );
    
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actores.length,
        itemBuilder: (contex, i)=>_actorTargeta(actores[i],contex),
      ),
      );
  }

  Widget _actorTargeta(Actor actor,BuildContext context){
    print(actor.id);
    return GestureDetector(
      child: Container(
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
                child: FadeInImage(
                  placeholder: AssetImage("assets/img/no-image.jpg"),
                  image: NetworkImage(actor.getFoto()),
                  height: 150.0,
                  fit: BoxFit.cover,
              ),
            ),
            Text(
              actor.name,
              overflow: TextOverflow.ellipsis,
              )
          ],
        ),
      ),
      onTap: (){
        Navigator.pushNamed(context, 'people',arguments: actor.id);
      },
    );
  }
}