import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:runomusic/Models/playlist.dart';
import 'package:runomusic/freshChanges/popularTodayView.dart';
import 'package:runomusic/freshChanges/popularTodayView2.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final textController = TextEditingController();
  List<Playlist> playlists = [];
  String query = "";
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              "Search",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: textController,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (val) async {
                query = textController.text;
                await searchSongs();
                // if (playlists.isNotEmpty) print("hua");
                setState(() {});
                textController.clear();
                FocusScope.of(context).requestFocus(FocusNode());
              },
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                    size: 30,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none),
                  hintText: "What do you want to listen to?",
                  hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                      fontWeight: FontWeight.w400),
                  filled: true,
                  fillColor: Colors.white),
            ),
            SizedBox(
              height: 20,
            ),
            playlists.length != 0
                ? Text(
                    "Results",
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                : Text(""),
            SizedBox(
              height: 20,
            ),
            Container(
              height: 490,
              width: double.infinity,
              child: ListView.separated(
                  itemCount: playlists.length,
                  separatorBuilder: (ctx, idx) {
                    return SizedBox(
                      height: 20,
                    );
                  },
                  shrinkWrap: true,
                  itemBuilder: (_, idx) {
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx)=>PopularTodayView2(playlists[idx])));
                      },
                      child: ListTile(
                        leading: Image.network(playlists[idx].imageUrl,
                            errorBuilder: (_, exception, stacktree) {
                          return SizedBox(
                            height: 50,
                            width: 85,
                          );
                        }),
                        title: Text(
                          playlists[idx].name,
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text("PLaylist",style: Theme.of(context).textTheme.bodySmall,),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> searchSongs() async {
    final response = await http.get(Uri.parse(
        "https://api.napster.com/v2.2/search?query=${query}?type=playlist&apikey=OTYxNDY3NTItZmM1Zi00MTMzLTllN2UtMDk2ZTBlMzIyYTZm&per_type_limit=5"));
    final data = jsonDecode(response.body)["search"]["data"]["playlists"];
    playlists.clear();
    setState(() {
      data.forEach((item) {
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
