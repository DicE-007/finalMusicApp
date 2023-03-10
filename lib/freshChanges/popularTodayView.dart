import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:runomusic/Models/playlist.dart';
import 'package:runomusic/Models/track.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../widgets/audioPlayer.dart';

class PopularTodayView extends StatefulWidget {
  final Playlist curr;
  PopularTodayView(this.curr);

  @override
  State<PopularTodayView> createState() => _PopularTodayViewState();
}

class _PopularTodayViewState extends State<PopularTodayView> {
  @override
  List<TrackElement> tracks = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTracks();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black),
      body: tracks.length != 0
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  ClipRRect(
                    child: Image.network(
                      widget.curr.imageUrl,
                      fit: BoxFit.fill,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.curr.name,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(widget.curr.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Trackcount: ${widget.curr.trackCount}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      Text("Favkcount: ${widget.curr.favCount}",
                          style: Theme.of(context).textTheme.bodySmall)
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 444,
                    child: ListView.builder(
                      itemCount: tracks.length,
                      shrinkWrap: true,
                      itemBuilder: (context, idx) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MusicPlayer(tracks[idx])));
                          },
                          onLongPress: () async {
                            bool isExist = await documentExistsInCollection(
                                "playlist", tracks[idx].name ?? "");
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
                              creatTrackInstanceForFirebase(tracks[idx]);
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
                          },
                          child: ListTile(
                            leading: tracks[idx].imageUrl == ""
                                ? CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/music.png"),
                                    radius: 30,
                                    backgroundColor: Colors.grey[800],
                                  )
                                : CircleAvatar(
                                    backgroundImage: NetworkImage(
                                      tracks[idx].imageUrl ?? "",
                                    ),
                                    backgroundColor: Colors.grey[800],
                                    radius: 30,
                                  ),
                            title: Text(
                              tracks[idx].name ?? "",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              tracks[idx].albumName ?? "",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            )
          : Container(
              height: 800,
              child: Center(
                child: SpinKitRing(
                  color: widgetColor,
                  size: 50.0,
                ),
              ),
            ),
    );
  }

  Future<void> fetchTracks() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.napster.com/v2.2/playlists/${widget.curr.id}/tracks?apikey=OTYxNDY3NTItZmM1Zi00MTMzLTllN2UtMDk2ZTBlMzIyYTZm&limit=10"));
      final data = trackFromJson(response.body).tracks;
      tracks = data!;
      for (TrackElement element in tracks) {
        final r2 = await http.get(
            Uri.parse("${element.links?.artists?.href}/images"),
            headers: requestHeaders);
        try {
          final data = await jsonDecode(r2.body);
          if (data["images"]?.length != null && data["images"].length > 0) {
            element.imageUrl = data["images"][3]["url"];
          } else {
            element.imageUrl = "";
          }
        } catch (err) {
          element.imageUrl = "";
        }
        if (mounted) setState(() {});
      }
      ;
    } catch (err) {
      print("err");
    }
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
}
