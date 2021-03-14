import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle_page.dart';
import 'package:peliculas/src/pages/people_page.dart';
import 'package:peliculas/src/widgets/GradientHelper.dart';
import 'package:provider/provider.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> GradientHelper(),
      //builder: (context)=> GradientHelper(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: '/',
        routes: {
          '/': (BuildContext context) => HomePage(),
          'detalle' : (BuildContext context) => PeliculaDetalle(),
          'people':(BuildContext context) => PeoplePage(),
        },
      ),
    );
  }

}