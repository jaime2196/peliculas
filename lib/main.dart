import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/home_page.dart';
import 'package:peliculas/src/pages/landing_page.dart';
import 'package:peliculas/src/pages/login_page.dart';
import 'package:peliculas/src/pages/pelicula_detalle_page.dart';
import 'package:peliculas/src/pages/people_page.dart';
import 'package:peliculas/src/widgets/GradientHelper.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 
Future<void> main() async{
  final supabase = SupabaseClient('https://hyhitvdhbyxmxhwzqtfg.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJyb2xlIjoiYW5vbiIsImlhdCI6MTYzNzQzNDUwMCwiZXhwIjoxOTUzMDEwNTAwfQ.tyofFHYiNN3miyGtr_qPYvudBXhhPyQmLSmTu5QQPo4');
  runApp(MyApp(supabase));
} 
 
class MyApp extends StatelessWidget {
  final SupabaseClient supabase;
  MyApp(this.supabase);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=> GradientHelper(),
      //builder: (context)=> GradientHelper(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        initialRoute: this.supabase.auth.user()==null?'landing':'/',
        routes: {
          '/': (BuildContext context) => HomePage(),
          'detalle' : (BuildContext context) => PeliculaDetalle(),
          'people':(BuildContext context) => PeoplePage(),
          'login':(BuildContext context)=> LoginPage(supabase),
          'landing':(BuildContext context)=> LandingPage(supabase),
        },
      ),
    );
  }

}