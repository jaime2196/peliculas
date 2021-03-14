import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';


class GradientHelper with ChangeNotifier{

  LinearGradient _linearGradient = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [Colors.blue, Colors.red]
  );


  get gradient =>  _linearGradient;


  set gradient(LinearGradient gradient){
    _linearGradient=gradient;
    notifyListeners();
  }

  generarColor(String hola)async{
    PaletteGenerator generator = await PaletteGenerator.fromImageProvider(
      NetworkImage(hola),
      //size: Size(200,100),
    );
    //PaletteColor color= generator.dominantColor;

    LinearGradient gradiente = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      
      colors: [generator.darkMutedColor.color, generator.lightMutedColor.color]
    );

    

    
    this.gradient=gradiente;
    
  }

  



}