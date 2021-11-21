import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  final SupabaseClient supabase;
  LoginPage(this.supabase);

  @override
  _LoginPageState createState() => _LoginPageState(supabase);
}

class _LoginPageState extends State<LoginPage> {
  final SupabaseClient supabase;
  _LoginPageState(this.supabase);

  @override
  Widget build(BuildContext context) {
    final registro = ModalRoute.of(context).settings.arguments as bool;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(!registro? "Crear cuenta" : "Iniciar sesion"),
      ),
      body: body(registro, context),
    );
  }

  Widget body(bool reg, BuildContext context){
    TextEditingController controllerMail=new TextEditingController();
    TextEditingController controllerPass=new TextEditingController();
    TextEditingController controllerPass2=new TextEditingController();
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(decoration: InputDecoration(
                hintText: "Correo"
              ),
              controller: controllerMail,
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: "Contraseña"
              ),
              controller: controllerPass,
            ),
            contrasenaDos(reg, controllerPass2),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()=>registro(controllerMail, controllerPass, controllerPass2 ,reg, context), 
              child: Text(!reg? "Crear cuenta" : "Iniciar sesion")
            ),
          ],
        ),
      ),
    );
  }

  registro(TextEditingController controllerMail, TextEditingController controllerPass, 
    TextEditingController controllerPass2, bool reg, BuildContext context) async{
    String mail=controllerMail.text;
    String pass=controllerPass.text;
    String pass2=controllerPass2.text;
    if(!reg){ //Nueva cuenta
      if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail)){
        if(pass!='' && pass.length>5 && pass==pass2){
          final res = await supabase.auth.signUp(mail, pass);
          final error = res.error;
          if(error==null){
            mostrarDialogo("Exito", "Se ha registrado correctamente, comprube su bandeja de entrada para validar su email. Despues podrá iniciar sesion", context);
            Navigator.pushNamed(context, 'login', arguments: true);
          }else{
            mostrarDialogo("Error", "Se ha pruducido un error interno, intentelo de nuevo mas tarde.", context);
          }
        }else{
          mostrarDialogo("Error", "Las contraseñas no coinciden o están vacías.\nLa longitud minima son 6 caracteres.", context);
        }
      }else{
        mostrarDialogo("Error", "El email no tiene un formato correcto", context);
      }
    }else{//Inicio sesion
      if(RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(mail)){
        if(pass!='' && pass.length>5){
          final res = await supabase.auth.signIn(email: mail, password: pass);
          final user = res.data?.user;
          final error = res.error;
          print(user);
          print(error);
          if(error==null){
            Navigator.pushNamed(context, '/');
          }else{
            mostrarDialogo("Error", "Se ha pruducido un error: '${error.message}'", context);
          }
        }else{
          mostrarDialogo("Error", "Las contraseñas no coinciden o están vacías.\nLa longitud minima son 6 caracteres.", context);
        }
      }else{
        mostrarDialogo("Error", "El email no tiene un formato correcto", context);
      }
    }
  }

  void mostrarDialogo(String titulo, String contenido, BuildContext context){
    Widget dialog= AlertDialog(
      title: Text(titulo),
      content: Text(contenido),
      actions: [
        TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Ok")),
      ],
      elevation: 24.0,
    );
    showDialog(context: context, builder: (_)=> dialog);
  }

  Widget contrasenaDos(bool reg, TextEditingController controllerPass2){
    if(!reg){
      return TextField(
              decoration: InputDecoration(
                hintText: "Repite la contraseña"
              ),
              controller: controllerPass2,
            );
    }
    return Container();
  }


}