import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runomusic/freshChanges/popularTodayView.dart';
import 'package:runomusic/freshChanges/popularTodayView2.dart';

import '../Models/playlist.dart';
import '../constants/constants.dart';

class PopularToday extends StatefulWidget {
  const PopularToday({Key? key}) : super(key: key);

  @override
  State<PopularToday> createState() => _PopularTodayState();
}

class _PopularTodayState extends State<PopularToday> {
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
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, idx) {
          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (ctx)=>PopularTodayView2(playlists[idx])));
            },
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: playlists[idx].imageUrl == ""
                        ? SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/profile.png"),
                          )
                        : Image.network(
                            playlists[idx].imageUrl,
                            fit: BoxFit.cover,
                            height: 160,
                            width: 150,
                          ),
                  ),
                  Text(playlists[idx].name,
                      overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          );
        });
  }

  Future<void> fetchPlaylist() async {
    final response = await http.get(
        Uri.parse("https://api.napster.com/v2.2/playlists"),
        headers: requestHeaders);
    final extractedData = jsonDecode(response.body)["playlists"];

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
    setState(() {});
  }
}
