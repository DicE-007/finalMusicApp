import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runomusic/Models/track.dart';
import 'package:http/http.dart' as http;

import '../Models/album.dart';
import '../constants/constants.dart';
import '../pages/albumLayout2.dart';
import '../widgets/ArtistView.dart';
class MusicOption extends StatefulWidget {
  final TrackElement instance;
  MusicOption(this.instance);

  @override
  State<MusicOption> createState() => _MusicOptionState();
}

class _MusicOptionState extends State<MusicOption> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAlbum();
  }
  AlbumElement albuminstance = AlbumElement();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image(
                  image: NetworkImage(widget.instance.imageUrl ?? ""),
                  height: 300,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Center(
                  child: Text(
                widget.instance.name?.toUpperCase() ?? "",
                style: Theme.of(context).textTheme.bodyLarge,
              )),
              SizedBox(
                height: 16,
              ),
              Center(
                child: Text(
                  widget.instance.albumName ?? "",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              ListTile(
                leading: Icon(Icons.favorite_border,color: Colors.grey[700],),
                title: Text("Like",style: Theme.of(context).textTheme.bodyMedium,),
              ),
              ListTile(
                leading: Icon(Icons.remove_circle_outline,color: Colors.grey[700],),
                title: Text("Hide this song",style: Theme.of(context).textTheme.bodyMedium,),
              ),
              ListTile(
                onTap: ()async{
                  bool isExist = await documentExistsInCollection(
                      "playlist", widget.instance.name??"");
                  if (isExist) {
                    final scaffold = ScaffoldMessenger.of(context);
                    scaffold.showSnackBar(const SnackBar(
                      content: Text("Already in the playlist!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black)),
                      duration: Duration(milliseconds: 800),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.white,
                    ));
                  } else {
                    creatTrackInstanceForFirebase(widget.instance);
                    final scaffold = ScaffoldMessenger.of(context);
                    scaffold.showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Song added to playlist!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.black),
                        ),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(milliseconds: 800),
                        backgroundColor: Colors.white,
                      ),
                    );
                  }
                  Navigator.pop(context);
                },
                leading: Icon(Icons.playlist_add,color: Colors.grey[700],),
                title: Text("Add to Playlist",style: Theme.of(context).textTheme.bodyMedium,),
              ),
              ListTile(
                leading: Icon(Icons.queue_music,color: Colors.grey[700],),
                title: Text("Add to Queue",style: Theme.of(context).textTheme.bodyMedium,),
              ),
              ListTile(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AlbumLayout2(albuminstance)));
                },
                leading: Icon(Icons.album,color: Colors.grey[700],),
                title: Text("View Album",style: Theme.of(context).textTheme.bodyMedium,),
              ),
              ListTile(
                onTap: (){
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ArtistView(
                              "https://api.napster.com/v2.2/artists/${widget.instance.artistId}")));
                },
                leading: Icon(Icons.person,color: Colors.grey[700],),
                title: Text("View Artist",style: Theme.of(context).textTheme.bodyMedium,),
              ),
              ListTile(
                leading: Icon(Icons.share,color: Colors.grey[700],),
                title: Text("Share",style: Theme.of(context).textTheme.bodyMedium,),
              ),
              ListTile(
                leading: Icon(Icons.radio,color: Colors.grey[700],),
                title: Text("Go To Song Radio",style: Theme.of(context).textTheme.bodyMedium,),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future creatTrackInstanceForFirebase(TrackElement item) async {
    final docUser =
    FirebaseFirestore.instance.collection("playlist").doc(item.name);
    final json = {
      "name": item.name,
      "artist": item.artistName,
      "image": item.imageUrl,
      "trackurl": item.href,
      "album": item.albumName,
      // "trackimg": item.trackImg,
      "playbackSec": item.playbackSeconds,
      "artistid": item.artistId,
      "albumid": item.albumId
    };
    await docUser.set(json);
  }

  Future<bool> documentExistsInCollection(
      String collectionName, String docId) async {
    try {
      var doc = await FirebaseFirestore.instance
          .collection(collectionName)
          .doc(docId)
          .get();
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAlbum() async {
    try {
      var responses = await Future.wait([
        http.get(
            Uri.parse(
                "https://api.napster.com/v2.2/albums/${widget.instance.albumId}/images"),
            headers: requestHeaders),
        http.get(
            Uri.parse(
                "https://api.napster.com/v2.2/albums/${widget.instance.albumId}"),
            headers: requestHeaders)
      ]);
      List<AlbumElement> extractedData = albumFromJson(responses[1].body).albums??[];
      albuminstance = extractedData[0];
      final image = jsonDecode(responses[0].body);
      albuminstance.imageUrl = image["images"][3]["url"] ?? "";
    } catch (e) {
      print("error");
      print("audioplayer");
    }
  }
}
