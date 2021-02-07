import 'package:flutter/material.dart';
import 'package:peliculas/src/models/images_model.dart';
import 'package:peliculas/src/models/peopleImage_model.dart';
import 'package:peliculas/src/models/people_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeoplePage extends StatelessWidget {
  const PeoplePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final peopleId= ModalRoute.of(context).settings.arguments;
    final peliculasProvider= PeliculasProvider();

    return Scaffold(
      body:  FutureBuilder(
        future: peliculasProvider.getPeopleImage(peopleId),
        builder: (BuildContext context, AsyncSnapshot<PeopleImage> snapshot) {
          if(snapshot.hasData){
            PeopleImage peopleImage=snapshot.data;
            //return Text(peopleImage.people.name);
            return _crearScrollView(peopleImage,context);
          }else{
            return Container(
              height: 400,
              child: Center(
                child: CircularProgressIndicator()
              )
            );
          }
        }
      ),
    );
  }

  Widget _crearScrollView(PeopleImage peopleImage, BuildContext context){
    return CustomScrollView(
      slivers: [
        _crearAppbar(peopleImage),
        SliverList(delegate: SliverChildListDelegate([
          SizedBox(height: 10.0),
          _datosBasicos(peopleImage,context),
          _descripcion(peopleImage),
        ])),
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

  Widget _descripcion(PeopleImage peopleImage){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Text(
          peopleImage.people.biography,
          textAlign: TextAlign.justify,
        ),
      ),
    );
  }

  _datosBasicos(PeopleImage peopleImage, BuildContext context){
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(15),
      elevation: 10,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(Icons.border_bottom_rounded),
              Text(peopleImage.people.birthday.toString(),style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis),
            ],),
          ],
        ),
      ),
    );
  }
}