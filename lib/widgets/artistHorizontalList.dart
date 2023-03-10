import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/constants.dart';
import '../Models/artist.dart';
import '../widgets/ArtistView.dart';

class ArtistList extends StatefulWidget {
  List<ArtistElement> artistlist;
  ArtistList(this.artistlist);


  @override
  State<ArtistList> createState() => _ArtistListState();
}

class _ArtistListState extends State<ArtistList> {
  List<ArtistElement>newArtistList=[];
  final scrollcontrollerA = ScrollController();
  bool isLoading = false;
  int curOffA = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollcontrollerA.addListener(_scrollListner);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: isLoading
          ? widget.artistlist.length + 1
          : widget.artistlist.length + 1,
      scrollDirection: Axis.horizontal,
      controller: scrollcontrollerA,
      shrinkWrap: true,
      separatorBuilder: (context, index) {
        return SizedBox(
          width: 15,
        );
      },
      itemBuilder: ((context, index) {
        if (index < widget.artistlist.length) {
          return InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ArtistView(widget.artistlist[index].href??"")));
            },
            child: Column(
              children: [
                widget.artistlist[index].imageUrl != ""
                    ? CircleAvatar(
                        backgroundImage:
                            NetworkImage(widget.artistlist[index].imageUrl),
                        radius: 30,
                        backgroundColor: Colors.grey[800],
                      )
                    : CircleAvatar(
                        backgroundImage: AssetImage("assets/profile.png"),
                        backgroundColor: Colors.grey[800],
                        radius: 30,
                      ),
                SizedBox(height: 10,),
                SizedBox(
                  width: 60,
                  child: Text(
                    widget.artistlist[index].name??"",
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              ],
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(color: widgetColor),
          );
        }
      }),
    );
  }

  Future<void> fetchTrackImage() async {
    print(newArtistList);
    newArtistList.forEach((element) async {
      try {
        final response = await http.get(
            Uri.parse(
                "https://api.napster.com/v2.2/artists/${element.id}/images"),
            headers: requestHeaders);
        final data = jsonDecode(response.body);
        if (data["images"].length != 0) {
          setState(() {
           element.imageUrl = data["images"][3]["url"] ?? "";
          });
        }
      } catch (e) {
        element.imageUrl = "";
      }
    });
  }

  Future<void> fetchArtist() async {
    try {
      newArtistList.clear();
      final response = await http.get(
          Uri.parse(
              "https://api.napster.com/v2.2/artists/top?limit=7&offset=$curOffA"),
          headers: requestHeaders);
      List<ArtistElement> extractedData = artistFromJson(response.body).artists??[];
      newArtistList=extractedData;
      await fetchTrackImage();
      setState(() {
        widget.artistlist=widget.artistlist+newArtistList;
      });
    } catch (err) {
      print("errr");
    }
  }

  void _scrollListner() async {
    if (scrollcontrollerA.position.pixels ==
        scrollcontrollerA.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      curOffA += 8;
      await fetchArtist();
      await fetchTrackImage();
      setState(() {
        isLoading = false;
      });
    }
  }
}
