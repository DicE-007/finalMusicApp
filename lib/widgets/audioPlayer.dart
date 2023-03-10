import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:runomusic/Models/track.dart';
import 'package:runomusic/widgets/ArtistView.dart';
import '../constants/constants.dart';
import 'dart:math' as math;
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Models/album.dart';
import '../pages/albumLayout.dart';
import 'package:perfect_volume_control/perfect_volume_control.dart';
import 'package:runomusic/provider/fav_provider.dart';
import 'package:provider/provider.dart';

import '../pages/albumLayout2.dart';

class MusicPlayer extends StatefulWidget {
  final TrackElement currentSong;
  MusicPlayer(this.currentSong);
  int x = 0;
  Duration newDuration = Duration.zero;
  @override
  State<MusicPlayer> createState() => _MusicPlayerState();
}

class _MusicPlayerState extends State<MusicPlayer> {
  final audioPlayer = AudioPlayer();
  double currentvol = 0.5;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  void converter(x) {
    x = widget.currentSong.playbackSeconds;
    widget.newDuration = Duration(seconds: x);
  }

  int id = 1;
  AlbumElement albuminstance = AlbumElement();
  bool xd = false;
  @override
  void fuu()async{
     xd = await documentExistsInCollection("playlist", widget.currentSong.name??"");
     setState(() {
     });
  }
  void initState() {
    // TODO: implement initState
    super.initState();
    fuu();
    fetchAlbum();
    Future.delayed(Duration.zero, () async {
      currentvol = await PerfectVolumeControl.getVolume();
      setState(() {
        //refresh UI
      });
    });
    if (mounted) {
      PerfectVolumeControl.stream.listen((volume) {
        if (this.mounted)
          setState(() {
            currentvol = volume;
          });
      });
    }
    audioPlayer.onPlayerStateChanged.listen((state) {
      if (this.mounted)
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
    });

    audioPlayer.onDurationChanged.listen((x) {
      if (this.mounted)
        setState(() {
          duration = x;
        });
    });
    audioPlayer.onPositionChanged.listen((newPos) {
      if (this.mounted)
        setState(() {
          position = newPos;
        });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  String formatTime(Duration duration) {
    String twoDigets(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigets(duration.inHours);
    final minutes = twoDigets(duration.inMinutes.remainder(60));
    final seconds = twoDigets(duration.inSeconds.remainder(60));
    return [if (duration.inHours > 0) hours, minutes, seconds].join(":");
  }
  Widget build(BuildContext context) {
    // final provider = Provider.of<FavouriteProvider>(context);
    // print("https://api.napster.com/v2.2/artists/${widget.currentSong.artistId}");
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1,
              ),
              InkWell(
                  onTap: () async {
                    await audioPlayer.pause();
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    child:
                        Icon(Icons.notifications_rounded, color: Colors.white),
                    backgroundColor: widgetBackground,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  AlbumLayout2(albuminstance)));
                    },
                    child: Center(
                      child: widget.currentSong.albumName!.length > 30
                          ? Text(widget.currentSong.albumName!.substring(0, 25) +
                              "...")
                          : Text(
                              widget.currentSong.albumName??"",
                              style: Theme.of(context).textTheme.bodyLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      //provider.addFav(widget.currentSong);
                      bool isExist = await documentExistsInCollection(
                          "playlist", widget.currentSong.name??"");
                      if (isExist) {
                        final docUser = FirebaseFirestore.instance
                            .collection("playlist")
                            .doc(widget.currentSong.name??"");
                        docUser.delete();
                        setState(() {
                          xd=false;
                        });
                        // isExist = false;
                      } else {
                        creatTrackInstanceForFirebase(widget.currentSong);
                        setState(() {
                          xd=true;
                        });
                        // isExist = true;
                      }

                    },
                    child: CircleAvatar(
                      child: //provider.isExist(widget.currentSong)
                          xd
                              ? Icon(
                                  Icons.favorite_rounded,
                                  color: Colors.white,
                                )
                              : Icon(
                                  Icons.favorite_border_rounded,
                                  color: Colors.white,
                                ),
                      backgroundColor: widgetBackground,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Stack(
                children: [
                  Center(
                    child: widget.currentSong.imageUrl != ""
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(30),
                            child: Image.network(widget.currentSong.imageUrl??"",
                                fit: BoxFit.fitHeight, width: 350, height: 390),
                          )
                        : Container(
                            height: 250,
                            width: 250,
                            child: Image.asset("assets/profile.png")),
                  ),
                  Positioned(
                    left: 15,
                    top: 20,
                    bottom: 20,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: Slider(
                        activeColor: widgetColor,
                        inactiveColor: Colors.grey[800],
                        thumbColor: Colors.deepPurpleAccent,
                        value: currentvol,
                        onChanged: (newvol) {
                          currentvol = newvol;
                          PerfectVolumeControl.setVolume(
                              newvol); //set new volume
                          setState(() {});
                        },
                        min: 0, //
                        max: 1,
                        divisions: 100,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    widget.currentSong.name??"",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ArtistView(
                                "https://api.napster.com/v2.2/artists/${widget.currentSong.artistId}")));
                  },
                  child: Center(
                    child: Text(
                      widget.currentSong.artistName??"",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Icon(
                    Icons.first_page_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(math.pi),
                    child: Icon(
                      Icons.forward_10_rounded,
                      color: Colors.grey[700],
                      size: 35,
                    ),
                  ),
                  Center(
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 35,
                      child: IconButton(
                        icon: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        iconSize: 40,
                        color: Colors.black,
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                          } else {
                            String url = widget.currentSong.previewUrl??"";
                            await audioPlayer.play(UrlSource(url));
                          }
                        },
                      ),
                    ),
                  ),
                  Icon(
                    Icons.forward_10_rounded,
                    color: Colors.grey[700],
                    size: 35,
                  ),
                  Icon(
                    Icons.last_page_rounded,
                    color: Colors.white,
                    size: 35,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              Slider(
                  activeColor: widgetColor,
                  inactiveColor: Colors.grey[800],
                  thumbColor: Colors.deepPurpleAccent,
                  min: 0,
                  max: duration.inSeconds.toDouble(),
                  value: position.inSeconds.toDouble(),
                  onChanged: (val) async {
                    final position = Duration(seconds: val.toInt());
                    await audioPlayer.seek(position);
                    await audioPlayer.resume();
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      formatTime(position),
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      formatTime(duration - position),
                      style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> fetchAlbum() async {
    print(0);
    try {
      var responses = await Future.wait([
        http.get(
            Uri.parse(
                "https://api.napster.com/v2.2/albums/${widget.currentSong.albumId}/images"),
            headers: requestHeaders),
        http.get(
            Uri.parse(
                "https://api.napster.com/v2.2/albums/${widget.currentSong.albumId}"),
            headers: requestHeaders)
      ]);
      List<AlbumElement> extractedData = albumFromJson(responses[1].body).albums??[];
      albuminstance = extractedData[0];
      final image = jsonDecode(responses[0].body);
      albuminstance.imageUrl = image["images"][3]["url"] ?? "";
      setState(() {});
    } catch (e) {
      print("error");
      print("audioplayer");
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
      //"trackimg": item.trackImg,
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
