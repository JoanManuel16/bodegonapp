import 'package:bodegonapp/frames/mainFrma.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  

  if (isFirstTime) {
    await prefs.setBool('isFirstTime', false);
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        
        buttonTheme: ButtonThemeData(buttonColor: Colors.deepPurple),
        appBarTheme: const AppBarTheme(
          color: Colors.deepPurple
        ),
        primarySwatch: Colors.deepPurple,
      ),
      debugShowCheckedModeBanner: false,
      title: "Romberg",
      initialRoute: "/",
      routes: {
        "/": (context) => const MainFrame(),
      },
    );
  }
}
