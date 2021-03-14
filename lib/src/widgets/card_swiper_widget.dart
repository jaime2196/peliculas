import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:provider/provider.dart';

import 'GradientHelper.dart';

class CardSwiper extends StatelessWidget {
  final List<Pelicula> peliculas;

  CardSwiper({@required this.peliculas});
  
  
  @override
  Widget build(BuildContext context) {

    final _screenSize= MediaQuery.of(context).size;
    final gradientHelper= Provider.of<GradientHelper>(context);
    
    //gradientHelper.generarColor(peliculas[0].getPosterImg());
    return Container(
    padding: EdgeInsets.only(top: 10.0, ),
    //width: _screenSize.width *0.7,
    height: _screenSize.height*0.5,
    child: Swiper(
      itemBuilder: (BuildContext context,int index){
        peliculas[index].uniqueID="${peliculas[index].id}-tarjeta";
        //gradientHelper.generarColor(peliculas[0].getPosterImg());
        return Hero(
          tag: peliculas[index].uniqueID,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: _imagenDeTarjeta(index,peliculas[index],context),
          ),
        );
        
        
      },
      itemWidth: 250,
      itemHeight: _screenSize.height *0.5,
      layout: SwiperLayout.STACK,
      itemCount: peliculas.length,
      //pagination:  SwiperPagination(),
      control:  SwiperControl(size: 0),
      onIndexChanged: (indexChange){
        gradientHelper.generarColor(peliculas[indexChange].getPosterImg());
      },
      
    ),
  );
  }

  Widget _imagenDeTarjeta(int index,Pelicula pelicula,BuildContext context){
    final imagen= FadeInImage(
      placeholder: AssetImage("assets/img/no-image.jpg"),
      fit: BoxFit.cover, 
      image: NetworkImage(
        peliculas[index].getPosterImg()
      )
    );
    
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(
            context, 
            'detalle', 
            arguments: pelicula
          );
      },
      child: imagen,
    );
    
    
  }
}