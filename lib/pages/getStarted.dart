import 'package:flutter/material.dart';
import 'package:runomusic/constants/constants.dart';
import 'package:runomusic/pages/home_page.dart';
import '../Models/artist.dart';
import '../Models/album.dart';

import '../Models/track.dart';
import 'package:flutter/src/widgets/image.dart' as Img;

// import '../Models/album.dart';
// import '../Models/track.dart';
class GetStarted extends StatelessWidget {
  static const path = "/getStarted";
  Map data = {};

  List<ArtistElement> artistlist=[];

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)?.settings.arguments as Map;
    List<dynamic>artistlist = data["artistlist"];

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Img.Image.asset(
              "assets/firstImg.jpg",
              height: double.infinity,
              width: double.infinity,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                Text(
                  "R",
                  style: TextStyle(color: widgetColor,fontSize: 30,fontWeight: FontWeight.bold),
                ),
                Text("unoMusic",style: TextStyle(color: Colors.white,fontSize:20 ),)
                  ],
                ),
                Column(
                  children: [
                    Center(
                        child: Text(
                      "Create Your Playlist,\nShare It With Other",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Text(
                        "Choose music according to your taste,create your\nown playlist to accompany your day!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, Home_Page.path,
                              arguments: {
                                "artistlist":artistlist,
                              });
                        },
                        child: Container(
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35)),
                              color: widgetColor),
                          child: Center(child: Text("Get Started",style: Theme.of(context).textTheme.bodyMedium,)),
                        ))
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
