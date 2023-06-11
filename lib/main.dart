import 'package:flutter/material.dart';
import 'package:geo_locator_app/screen/home.dart';
import 'package:geo_locator_app/screen/login.dart';
import 'package:geo_locator_app/utility/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  //await SharedPrefs.init();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Pointer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            SharedPreferences? prefs = snapshot.data;
            bool isLogged =
                prefs!.getBool(SharedKeyConstant.LOGIN_KEY) ?? false;
            if (isLogged) {
              return const HomeScreen();
            } else {
              prefs.setBool(SharedKeyConstant.LOGIN_KEY, false);
              return const LoginScreen();
            }
          }
          return const CircularProgressIndicator(
            color: Colors.blue,
          );
        },
      ),
    );
  }
}
