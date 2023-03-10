import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runomusic/freshChanges/musicOptionPage.dart';
import 'package:runomusic/widgets/audioPlayer.dart';
import '../Models/track.dart';
import '../constants/constants.dart';
import '../provider/trackProvider.dart';

class TrackView extends StatefulWidget {
  final ScrollController scrollControllerH;
  TrackView(this.scrollControllerH);

  @override
  State<TrackView> createState() => _TrackViewState();
}

class _TrackViewState extends State<TrackView> {
  List<TrackElement> newTrackList = [];
  bool isLoading = false;
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted)
        Provider.of<TrackProvider>(context, listen: false).getAllTracks();
    });
    if (mounted) widget.scrollControllerH.addListener(scrollListner);
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<TrackProvider>(
      builder: (context, value, child) {
        newTrackList = value.tracks;
        return ListView.builder(
          itemCount: isLoading == false
              ? newTrackList.length + 1
              : newTrackList.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, idx) {
            if (idx < newTrackList.length) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MusicPlayer(newTrackList[idx])));
                },
                onLongPress: () async {
                  bool isExist = await documentExistsInCollection(
                      "playlist", newTrackList[idx].name ?? "");
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
                    creatTrackInstanceForFirebase(newTrackList[idx]);
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
                  leading: newTrackList[idx].imageUrl == ""
                      ? CircleAvatar(
                          backgroundImage: AssetImage("assets/music.png"),
                          radius: 30,
                          backgroundColor: Colors.grey[800],
                        )
                      : CircleAvatar(
                          backgroundImage: NetworkImage(
                            newTrackList[idx].imageUrl ?? "",
                          ),
                          backgroundColor: Colors.grey[800],
                          radius: 30,
                        ),
                  title: Text(
                    newTrackList[idx].name ?? "",
                    style: Theme.of(context).textTheme.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    newTrackList[idx].albumName ?? "",
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // temp?Icon(Icons.favorite,color: widgetColor,):Icon(Icons.add),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MusicOption(newTrackList[idx])));
                          },
                          child: Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          )),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(color: widgetColor),
              );
            }
          },
        );
      },
    );
  }

  void scrollListner() async {
    if (widget.scrollControllerH.position.pixels ==
        widget.scrollControllerH.position.maxScrollExtent) {
      if (mounted)
        setState(() {
          isLoading = true;
        });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (mounted)
          Provider.of<TrackProvider>(context, listen: false).getMoreTracks();
      });
      if (mounted)
        setState(() {
          isLoading = false;
        });
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
