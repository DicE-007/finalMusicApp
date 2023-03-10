import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:runomusic/constants/constants.dart';
import 'package:runomusic/widgets/ArtistView.dart';
import '../Models/album.dart';
import '../Models/track.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../widgets/audioPlayer.dart';

class AlbumLayout extends StatefulWidget {
  static const path = "/albumlayout";
  final AlbumElement albumInstance;

  AlbumLayout(this.albumInstance);
  @override
  State<AlbumLayout> createState() => _AlbumLayoutState();
}

class _AlbumLayoutState extends State<AlbumLayout> {
  List<TrackElement> albumSongs = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTracks();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.albumInstance.imageUrl);
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(backgroundColor: Colors.black,),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: albumSongs.length!=0?Container(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: widget.albumInstance.imageUrl != ""
                          ? Image.network(widget.albumInstance.imageUrl??"",
                              width: 300,
                              height: 300,
                              alignment: Alignment.topRight,fit: BoxFit.cover,)
                          : Image.asset(
                            "assets/profile.png",
                            height: 300,
                            width: 300,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Center(
                        child: Text("${widget.albumInstance.name} Songs",
                            style: Theme.of(context).textTheme.bodyLarge,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InkWell(
                              onTap: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ArtistView(
                                            widget.albumInstance.links?.artists?.href??"")),
                                    (route)=>route.isFirst);
                              },
                              child: Text(
                                "# ${widget.albumInstance.artistName}",
                                style: Theme.of(context).textTheme.bodySmall,
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Album Track Count : ${widget.albumInstance.trackCount}",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Text(
                        "Songs",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ListView.builder(
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
                                  child: Padding(
                                      padding: EdgeInsets.only(top: 5),
                                      child: ListTile(
                                        leading: widget.albumInstance.imageUrl == ""
                                            ? SizedBox(
                                                height: 60,
                                                width: 60,
                                              )
                                            : Container(
                                                child: Image.network(
                                                    widget.albumInstance.imageUrl??""),
                                              ),
                                        title: Text(
                                          albumSongs[idx].name??"",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        subtitle: Text(albumSongs[idx].artistName??"",style: (
                                        TextStyle(
                                          fontSize: 14
                                        )
                                        ),),
                                        trailing: Text(
                                          "${(albumSongs[idx].playbackSeconds !/ 60).toStringAsFixed(2)} mins",
                                          style:
                                              Theme.of(context).textTheme.bodySmall,
                                        ),
                                      )),
                                )
                              : ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        AssetImage("assets/profile.png"),
                                  ),
                                );
                        })
                  ],
                ),
              ),
            ):Container(
              height: 600,
              child: Center(
                child: SpinKitRing(
                  color: widgetColor,
                  size: 50.0,
                ),
              ),
            ),
          ),
        ),
    );
  }

  Future<void> fetchTracks() async {
    try {
      final response = await http.get(
          Uri.parse("${widget.albumInstance.href}/tracks"),
          headers: requestHeaders);
      final extractData = response.body;
      albumSongs = trackFromJson(extractData).tracks??[];
      for(TrackElement it in albumSongs){
        it.imageUrl = widget.albumInstance.imageUrl;
      }
      setState(() {});
    } catch (e) {
      albumSongs = [];
      print("error");
    }
  }
}
