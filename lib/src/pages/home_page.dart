import 'package:flutter/material.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';
import 'package:peliculas/src/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/widgets/header_painter.dart';
import 'package:peliculas/src/widgets/movie_horizontal_widget.dart';


class HomePage extends StatelessWidget {
  
  final peliculasProvider= PeliculasProvider();

  @override
  Widget build(BuildContext context) {
    
    peliculasProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text("Peliculas en cines"),
        backgroundColor: Color(0xFF4E8CBF),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: (){
            showSearch(context: context, delegate: DataSearch());
          })
        ],
      ),
      body: CustomPaint(
        painter: HeaderPaintWaves(),
        child: Container(
          //height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _swiperTarjetas(),
              _footer(context),
            ],
          ),
        ),
      ),
      drawer: _drawer(),
    );
  }

Widget _swiperTarjetas() {
  
  /*return CardSwiper(peliculas: [1,2,3,4,5]);*/
  return FutureBuilder(
    future: peliculasProvider.getEnCines(),
    builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
      if(snapshot.hasData){
        return CardSwiper(peliculas: snapshot.data);
      }else{
        return Container(
          height: 400,
          child: Center(
            child: CircularProgressIndicator()
          )
        );
      }
    },
  );
}

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text("Populares", style: Theme.of(context).textTheme.subhead,)),
          ),
          SizedBox(height: 5.0,),
          StreamBuilder(
            stream: peliculasProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot<List> snap){
              if(snap.hasData){
                return MovieHorizontal(
                  peliculas: snap.data,
                  siguientePagina: peliculasProvider.getPopulares,
                );
              }
              return Center(child: CircularProgressIndicator());
            }
            ),
        ],
      ),
    );
  }

  Widget _drawer(){
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
             InkWell(
                onTap: () => debugPrint("home Page"),
                child: ListTile(
                  title: Text("Actores"),
                  leading: Icon(Icons.home),
                ),
              ),
            ListTile(
              title: Text('Item 1'),
              onTap: null
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
    );
  }
}