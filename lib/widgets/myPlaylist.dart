import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runomusic/constants/constants.dart';
import 'package:runomusic/pages/home_page.dart';
import 'package:runomusic/widgets/audioPlayer.dart';
import '../Models/track.dart';
import '../provider/fav_provider.dart';

class MyPlaylist extends StatelessWidget {
  static const path = "/myplaylist";
  @override
  Widget build(BuildContext context) {
    //final provider = Provider.of<FavouriteProvider>(context);
    //final favTracks = provider.favTracks;
    // Stream<List<TrackElement>> favTracks = readPlaylist();
    print(ModalRoute.of(context)?.settings.name);
    return Scaffold(
        appBar: AppBar(
            title: Text("MyPlaylist"),
            centerTitle: true,
            backgroundColor: Colors.black),
        body:
            StreamBuilder<List<TrackElement>>(
                stream: readPlaylist(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final favTracks = snapshot.data!;
                    return favTracks.length != 0
                        ? ListView.builder(
                            itemCount: favTracks.length,
                            shrinkWrap: true,
                            itemBuilder: (context, idx) {
                              return Dismissible(
                                key: ValueKey(favTracks[idx]),
                                direction: DismissDirection.endToStart,
                                onDismissed: (direction){
                                  final docuser = FirebaseFirestore.instance
                                      .collection("playlist")
                                      .doc(favTracks[idx].name ?? "");
                                  docuser.delete();
                                },
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MusicPlayer(favTracks[idx])));
                                  },
                                  child: ListTile(
                                    leading: favTracks[idx].imageUrl == ""
                                        ? CircleAvatar(
                                            backgroundImage:
                                                AssetImage("assets/music.png"),
                                            radius: 30,
                                            backgroundColor: Colors.grey[800],
                                          )
                                        : CircleAvatar(
                                            backgroundImage: NetworkImage(
                                              favTracks[idx].imageUrl ?? "",
                                            ),
                                            backgroundColor: Colors.grey[800],
                                            radius: 30,
                                          ),
                                    title: Text(
                                      favTracks[idx].name!.length < 30
                                          ? favTracks[idx].name ?? ""
                                          : favTracks[idx]
                                                  .name!
                                                  .substring(0, 27) +
                                              "...",
                                      style:
                                          Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    subtitle: Text(
                                      favTracks[idx].albumName!.length < 40
                                          ? favTracks[idx].albumName ?? ""
                                          : favTracks[idx]
                                                  .albumName!
                                                  .substring(0, 35) +
                                              "...",
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        //provider.addFav(favTracks[idx]);
                                        final docuser = FirebaseFirestore.instance
                                            .collection("playlist")
                                            .doc(favTracks[idx].name ?? "");
                                        docuser.delete();
                                      },
                                      child: Icon(
                                        Icons.remove_circle_outline,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            })
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  "Lets start building your playlist",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 240,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50)),
                                child: TextButton(
                                    onPressed: () {
                                      if(ModalRoute.of(context)?.settings.name == null)
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Add to this playlist",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    )),
                              )
                            ],
                          );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      color: widgetColor,
                    ));
                  }
                }));
  }

  static TrackElement fromjson(Map<String, dynamic> json) => TrackElement(
      albumName: json["album"] ?? "",
      albumId: json["albumid"] ?? "",
      artistName: json["artist"] ?? "",
      artistId: json["artistid"] ?? "",
      imageUrl: json["image"] ?? "",
      name: json["name"] ?? "",
      playbackSeconds: json["playbackSec"] ?? 0,
      href: json["trackimg"] ?? "",
      previewUrl: json["trackurl"] ?? "");
  Stream<List<TrackElement>> readPlaylist() => FirebaseFirestore.instance
      .collection("playlist")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => fromjson(doc.data())).toList());
}
