import 'package:flutter/material.dart';
import 'package:mi_aplicacion/pages/inicioSesion.dart';
import 'package:mi_aplicacion/pages/registrarupage.dart';
import 'package:mi_aplicacion/pages/userlistpage.dart';
import 'package:mi_aplicacion/pages/optionPage.dart';
import 'package:mi_aplicacion/pages/registrarCerdosPage.dart';
import 'package:mi_aplicacion/pages/perfilCerdoPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Aplicación',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      supportedLocales: [
        const Locale('en', ''), // Inglés
        const Locale('es', ''), // Español
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: '/splash',
      // Rutas estáticas (las que no necesitan parámetros)
      routes: {
        '/splash': (context) => SplashScreen(),
        '/inicioSesion': (context) => InicioSesion(),
        '/registrarupage': (context) => RegisterPage(),
        '/userlistpage': (context) => UserListPage(),
        '/optionPage': (context) => OptionPage(),
        '/registrarCerdosPage': (context) => RegistrarCerdo(),
      },
      // Rutas dinámicas (las que necesitan parámetros)
      onGenerateRoute: (settings) {
        if (settings.name == '/perfilCerdoPage') {
          final args = settings.arguments as int; // Obtén el ID del cerdo
          return MaterialPageRoute(
            builder: (context) => PerfilCerdo(cerdoId: args),
          );
        }
        return null; // Manejar rutas no encontradas si es necesario
      },
    );
  }
}


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/inicioSesion');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}







