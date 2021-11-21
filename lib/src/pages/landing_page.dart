import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LandingPage extends StatelessWidget {
  final SupabaseClient supabase;
  const LandingPage(this.supabase);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Peliculas en cines"),
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context){
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Container(
          child: Column(
            children: [
              Text("Bienvenido a peliculas \n¿Ya tienes una cuenta?"),
              ElevatedButton(
                onPressed: ()=> iniciar(true, context), 
                child: Text("Iniciar sesion")
              ),
              Text("¿Todavía no tienes cuenta?"),
              ElevatedButton(
                onPressed: ()=> iniciar(false, context), 
                child: Text("Crear cuenta")
              ),
            ],
          ),
        ),
      ),
    );
  }

  iniciar(bool registro, BuildContext context){
    Navigator.pushNamed(context, 'login', arguments: registro);
  }
}