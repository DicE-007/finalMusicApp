import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runomusic/pages/getStarted.dart';
import 'package:runomusic/pages/loading.dart';
import 'package:runomusic/provider/fav_provider.dart';
import 'package:runomusic/provider/trackProvider.dart';
import './pages/home_page.dart';
import './constants/constants.dart';
import './provider/albumProvider.dart';
import 'package:firebase_core/firebase_core.dart';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavouriteProvider()),
        ChangeNotifierProvider(create: (context) => TrackProvider()),
        ChangeNotifierProvider(create: (context)=> AlbumProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: "/",
        routes: {
          "/": (context) => Loading(),
          GetStarted.path: (context) => GetStarted(),
          Home_Page.path: (context) => Home_Page(),
        },
        theme: ThemeData(
            fontFamily: "Rubik",
            scaffoldBackgroundColor: Colors.black,
            primaryColor: widgetColor,
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: 20, color: Colors.white),
              bodyMedium: TextStyle(fontSize: 16, color: Colors.white),
              bodySmall: TextStyle(fontSize: 14, color: Colors.grey),
            )),
      ),
    );
  }
}
