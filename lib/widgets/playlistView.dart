import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runomusic/constants/constants.dart';
import '../Models/playlist.dart';

class PlaylistView extends StatefulWidget {
  @override
  State<PlaylistView> createState() => _PlaylistViewState();
}

class _PlaylistViewState extends State<PlaylistView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchPlaylist();
  }
  @override
  List<Playlist> playlists = [];
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: playlists.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, idx) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    widgetColor,
                    Colors.black,
                    Colors.black,
                  ]),
              borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                        height: 130,
                        width: 130,
                        child: Image.network(
                          playlists[idx].imageUrl,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Playlist",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: 180,
                            child: Text(
                              playlists[idx].name,
                              style: Theme.of(context).textTheme.bodyMedium,
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                            width: 180,
                            child: Text(playlists[idx].description,
                                style: Theme.of(context).textTheme.bodySmall)),
                      ],
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 25,
                      color: Colors.white,
                    ),
                    Icon(
                      Icons.more_vert,
                      size: 25,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * .4,
                    ),
                    Text(
                      "${playlists[idx].trackCount} songs",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    CircleAvatar(
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                      ),
                      backgroundColor: Colors.white,
                      radius: 15,
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchPlaylist() async {
    final response = await http.get(
        Uri.parse("https://api.napster.com/v2.2/playlists"),
        headers: requestHeaders);
    final extractedData = jsonDecode(response.body)["playlists"];
    setState(() {
      extractedData.forEach((item) {
        playlists.add(Playlist(
          id: item["id"],
            name: item["name"],
            imageUrl: item["images"][0]["url"],
            description:
                item["description"].trim().replaceAll(RegExp(r'(\n){3,}'), ""),
            favCount: item["favoriteCount"],
            playlistUrl: item["href"],
            trackCount: item["trackCount"]));
      });
    });
  }
}
