import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:runomusic/constants/constants.dart';
import 'package:runomusic/widgets/ArtistView.dart';
import '../Models/album.dart';
import '../Models/playlist.dart';
import '../Models/track.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/audioPlayer.dart';

class PopularTodayView2 extends StatefulWidget {
  static const path = "/albumlayout2";
  final Playlist curr;
  PopularTodayView2(this.curr);

  @override
  State<PopularTodayView2> createState() => _PopularTodayView2State();
}

class _PopularTodayView2State extends State<PopularTodayView2> {
  List<TrackElement> albumSongs = [];
  ScrollController _scrollController = ScrollController();
  double imageSize = 0;
  double initSize = 240;
  double containerheight = 500;
  double containerinitheight = 500;
  double imageeOpacity = 1;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imageSize = initSize;
    fetchTracks();
    _scrollController = ScrollController()
      ..addListener(() {
        imageSize = 240 - _scrollController.offset;
        if (imageSize < 0) imageSize = 0;
        containerheight = containerinitheight - _scrollController.offset;
        if (containerheight < 0) {
          containerheight = 0;
        }
        imageeOpacity = imageSize / initSize;
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widgetColor,
        elevation: 0,
        title: Text(widget.curr.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: containerheight,
              width: MediaQuery.of(context).size.width,
              color: widgetColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Opacity(
                    opacity: imageeOpacity.clamp(0, 1),
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(0, 20),
                            blurRadius: 32,
                            spreadRadius: 16)
                      ]),
                      child: Image(
                        image: NetworkImage(widget.curr.imageUrl),
                        width: imageSize,
                        height: imageSize,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 450,
                    clipBehavior: Clip.none,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(1),
                        ])),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 290,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image(
                                    image: AssetImage("assets/music.png"),
                                    height: 32,
                                    width: 32,
                                  ),
                                  Text(
                                    "R",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "unoMusic",
                                    style: TextStyle(fontSize: 15),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "TrackCount: ${widget.curr.trackCount}",
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[400]),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 16,
                                      ),
                                      Icon(
                                        Icons.more_horiz,
                                        color: Colors.white,
                                      )
                                    ],
                                  ),
                                  Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 54,
                                        width: 54,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ))
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 1030,
                    color: Colors.black,
                    child: ListView.builder(
                        itemCount: albumSongs.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (ctx, idx) {
                          return albumSongs.length != 0
                              ? InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MusicPlayer(albumSongs[idx])));
                                  },
                                  onLongPress: () async {
                                    bool isExist =
                                        await documentExistsInCollection(
                                            "playlist",
                                            albumSongs[idx].name ?? "");
                                    if (isExist) {
                                      final scaffold =
                                          ScaffoldMessenger.of(context);
                                      scaffold.showSnackBar(const SnackBar(
                                        content: Text(
                                            "Already in the playlist!",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.black)),
                                        duration: Duration(milliseconds: 800),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.white,
                                      ));
                                    } else {
                                      creatTrackInstanceForFirebase(
                                          albumSongs[idx]);
                                      final scaffold =
                                          ScaffoldMessenger.of(context);
                                      scaffold.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            "Song added to playlist!",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                          behavior: SnackBarBehavior.floating,
                                          duration: Duration(milliseconds: 800),
                                          backgroundColor: Colors.white,
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: ListTile(
                                        leading: widget.curr.imageUrl == ""
                                            ? SizedBox(
                                                height: 60,
                                                width: 60,
                                              )
                                            : Container(
                                                child: Image.network(
                                                    widget.curr.imageUrl ?? ""),
                                              ),
                                        title: Text(
                                          albumSongs[idx].name ?? "",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        subtitle: Text(
                                          albumSongs[idx].artistName ?? "",
                                          style: (TextStyle(fontSize: 14)),
                                        ),
                                        trailing: Text(
                                          "${(albumSongs[idx].playbackSeconds! / 60).toStringAsFixed(2)} mins",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      )),
                                )
                              : ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/profile.png"),
                                  ),
                                );
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchTracks() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.napster.com/v2.2/playlists/${widget.curr.id}/tracks?apikey=OTYxNDY3NTItZmM1Zi00MTMzLTllN2UtMDk2ZTBlMzIyYTZm&limit=10"));
      final extractData = response.body;
      albumSongs = trackFromJson(extractData).tracks ?? [];
      for (TrackElement it in albumSongs) {
        it.imageUrl = widget.curr.imageUrl;
      }
      setState(() {});
    } catch (e) {
      albumSongs = [];
      print("error");
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
