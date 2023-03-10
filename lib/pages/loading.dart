import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runomusic/pages/getStarted.dart';
import 'package:runomusic/provider/trackProvider.dart';
import '../Models/track.dart';
import '../Models/album.dart';
import 'package:http/http.dart' as http;
import '../constants/constants.dart';
import 'dart:convert';
import '../Models/artist.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  List<Track> tracks = [];
  List<Album> albums = [];
  List<ArtistElement> artists = [];
  // int ? a = null;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sendData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SpinKitRing(
            color: widgetColor,
            size: 50.0,
          ),
        ));
  }
  Future<void> fetchArtist() async {
    try {
      final response = await http.get(
          Uri.parse(
              "https://api.napster.com/v2.2/artists/top?limit=7&offset=0"),
          headers: requestHeaders);
      List<ArtistElement> extractedData = artistFromJson(response.body).artists??[];
      artists=extractedData;
      fetchArtistImage();
      // setState(() {
      // });
    } catch (err) {
      print("errloading");
    }
  }

  Future<void> fetchArtistImage() async {
    for(ArtistElement element in artists){
      try {
        final response = await http.get(
            Uri.parse(
                "https://api.napster.com/v2.2/artists/${element.id}/images"),
            headers: requestHeaders);
        final data = jsonDecode(response.body);
        if (data["images"].length != 0) {
          element.imageUrl = data["images"][3]["url"] ?? "";
        }
      } catch (e) {
        element.imageUrl = "";
      }
    }
  }

  void sendData() async {
    //await fetchAlbums();
    await fetchArtist();
 
    Navigator.pushReplacementNamed(context, GetStarted.path, arguments: {
      "artistlist": artists,
    });
  }
}
