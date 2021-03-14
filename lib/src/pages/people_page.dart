import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';

import 'package:peliculas/src/models/peopleImage_model.dart';

import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:intl/intl.dart';
import 'package:peliculas/src/widgets/GradientHelper.dart';
import 'package:provider/provider.dart';


class PeoplePage extends StatelessWidget {
  const PeoplePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Actor actor= ModalRoute.of(context).settings.arguments;
    final peliculasProvider= PeliculasProvider();
    

    return Scaffold(
      body:   FutureBuilder(
        future: peliculasProvider.getPeopleImage(actor.id),
        builder: (BuildContext context, AsyncSnapshot<PeopleImage> snapshot) {
          if(snapshot.hasData){
            PeopleImage peopleImage=snapshot.data;
            //return Text(peopleImage.people.name);
            return _crearScrollView(peopleImage,context);
          }else{
            return _crearScrollViewLoading(actor,context);
          }
        }
      ),
    );
  }

  Widget _crearScrollView(PeopleImage peopleImage, BuildContext context){
    final gradientHelper= Provider.of<GradientHelper>(context);
    return Container(
      decoration: BoxDecoration(
          gradient: gradientHelper.gradient,
        ),
      child: CustomScrollView(
        slivers: [
          _crearAppbar(peopleImage),
          SliverList(delegate: SliverChildListDelegate([
            SizedBox(height: 10.0),
            _datosBasicos(peopleImage,context),
            peopleImage.people.biography==''?Container(): _descripcion(peopleImage),
            _fotos(peopleImage),
          ])),
        ],
      ),
    );
  }

  Widget _crearScrollViewLoading(Actor actor, BuildContext context){
    return CustomScrollView(
      slivers: [
        _crearAppbarLoading(actor),
      ],
    );
  }

  _crearAppbar(PeopleImage peopleImage){
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 600.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(peopleImage.people.name, style: TextStyle(color:Colors.white,fontSize: 16)),
        background: FadeInImage(
          placeholder: AssetImage("assets/img/loading.gif"),
          image: NetworkImage(peopleImage.imagesModel.getURLImagen(0)),
          fadeInDuration: Duration(milliseconds: 15),
          fit: BoxFit.cover,
        ),
      ),
      
    );
  }

  _crearAppbarLoading(Actor actor){
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 600.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(actor.name, style: TextStyle(color:Colors.white,fontSize: 16)),
        background: FadeInImage(
          placeholder: AssetImage("assets/img/loading.gif"),
          image: AssetImage("assets/img/loading.gif"),
          fadeInDuration: Duration(milliseconds: 15),
          fit: BoxFit.cover,
        ),
      ),
      
    );
  }

  Widget _descripcion(PeopleImage peopleImage){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text(
          peopleImage.people.biography==''?'(No hay descripcion)':peopleImage.people.biography,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  _datosBasicos(PeopleImage peopleImage, BuildContext context){
    String fechaNacimiento=fechaFormateada(peopleImage.people.birthday, 'Fecha de nacimiento:');
    String edad=calcularEdad(peopleImage.people.birthday);
    String lugarNacimiento= peopleImage.people.placeOfBirth==null?'~' :'${peopleImage.people.placeOfBirth}';
    String sexo=calcularSexo(peopleImage.people.gender);
    return 
      Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(15),
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              rowDatoBasico(Icons.face,fechaNacimiento,context),
              rowDatoBasico(Icons.person,edad,context),
              rowDatoBasico(Icons.place,lugarNacimiento,context),
              rowDatoBasico(Icons.star_border,'Popularidad: ${peopleImage.people.popularity.truncate().toString()}',context),
              rowDatoBasico(Icons.people,sexo,context),
            ],
          ),
        ),
    );
  }

  Widget rowDatoBasico(IconData icon, String texto, BuildContext context){
    if(texto==null || texto=='~'){
      return Container();
    }

    return Row(children: [
                Icon(icon),
                SizedBox(width: 8),
                Text(texto,style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis),
            ]);
  }
  String fechaFormateada(DateTime date, String literal){
    if(date==null || date==DateTime.parse("1500-02-03")){
      return '~';
    }
    return '$literal ${DateFormat("dd-MM-yyyy").format(date)}';
  }

  String calcularEdad(DateTime date){
    if(date==null || date==DateTime.parse("1500-02-03")){
      return '~';
    }
    return 'Edad: ${(DateTime.now().difference(date).inDays/365).floor().toString()} años';
  }

  String calcularSexo(int gender){
    if(gender==2){
      return 'Sexo: masculino';
    }else if(gender==1){
      return 'Sexo: femenino';
    }else{
      return 'Sexo: ~';
    }
  }

  Widget _foto(FadeInImage image){
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: EdgeInsets.all(15),
        elevation: 10,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          child: image/*Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: getImagenes(peopleImage)
          )*/
        ),
    );
  }

  Widget _fotos(PeopleImage peopleImage){
    List<Widget> listaWidget=[];
    if(peopleImage.imagesModel.profiles.length>1){
      List<Image> lista=[];
      for(int i=1;i!=peopleImage.imagesModel.profiles.length;i++){
        lista.add(Image.network(peopleImage.imagesModel.getURLImagen(i)));
      }
      
      for(int a=1;a!=lista.length;a++){
        FadeInImage fadeInImage=FadeInImage.assetNetwork(
          image: peopleImage.imagesModel.getURLImagen(a),
          placeholder: "assets/img/loading.gif",
        );
        listaWidget.add(_foto(fadeInImage));
      }
    }
    
    return Column(
      children: listaWidget,
    );
  }
}