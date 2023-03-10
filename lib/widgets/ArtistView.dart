import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:runomusic/constants/constants.dart';
import 'package:runomusic/pages/albumLayout.dart';
import 'package:runomusic/tops/categories.dart';
import '../Models/artist.dart';
import 'package:http/http.dart' as http;
import '../Models/album.dart';

class ArtistView extends StatefulWidget {
  static const path = "/artistview";
  final String artistUrl;

  ArtistView(this.artistUrl);

  @override
  State<ArtistView> createState() => _ArtistViewState();
}

class _ArtistViewState extends State<ArtistView> {
  ArtistElement artistBio = ArtistElement(
      imageUrl: "",
      href: "",
      albumGroups: AlbumGroups(
          main: [], compilations: [], singlesAndEPs: [], others: []),
      amg: "",
      bios: [Bio(bio: "", author: "", publishDate: "", title: "")],
      blurbs: [],
      id: "",
      name: "");
  int returnedIndex = 0;
  Map<int, dynamic> mp = {};
  Map<int, List<AlbumElement>> mp2 = {};
  List<AlbumElement> main = [];
  List<AlbumElement> single = [];
  List<AlbumElement> compilation = [];
  List<AlbumElement> others = [];
  String bio = "";

  @override
  void initState() {
    // TODO: implement initState  Map<int, dynamic> mp = {};

    super.initState();
    waiting();
  }

  void _returndeValFromchild(int x) {
    setState(() {
      returnedIndex = x;
    });
  }

  bool show = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
                children: [
                  Container(
                child: artistBio.imageUrl != ""
                    ? Image.network(
                        artistBio.imageUrl,
                        width: MediaQuery.of(context).size.width,
                        height: 280,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 250,
                        width: 250,
                        child: Image.asset("assets/profile.png")),
              ),
              Positioned(
                top: 10,
                left: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black45,
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ]),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "About",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: show
                              ? Column(
                                  children: [
                                    Text(
                                      bio,
                                      maxLines: 3,
                                      textAlign: TextAlign.justify,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            show = !show;
                                          });
                                        },
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: Colors.white,
                                        ))
                                  ],
                                )
                              : Column(
                                  children: [
                                    Text(
                                      bio,
                                      textAlign: TextAlign.justify,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          show = !show;
                                        });
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Category(
                      ["Main", "Singles & Eps", "Compilations", "Others"],
                      _returndeValFromchild),
                  SizedBox(
                    height: 10,
                  ),
                  main.length > 0
                      ? SizedBox(
                          width: 500,
                          height: 500,
                          child: ListView.separated(
                              physics: NeverScrollableScrollPhysics(),
                              separatorBuilder: (ctx, i) {
                                return SizedBox(
                                  height: 5,
                                );
                              },
                              shrinkWrap: true,
                              itemCount: mp2[returnedIndex]!.length,
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AlbumLayout(
                                                mp2[returnedIndex]![i])));
                                  },
                                  child: ListTile(
                                    leading: mp2[returnedIndex]![i]
                                                .imageUrl !=
                                            ""
                                        ? Image.network(
                                            mp2[returnedIndex]![i].imageUrl ??
                                                "",
                                            errorBuilder:
                                                (ctx, exception, stack) {
                                              return Image.asset(
                                                  "assets/profile.png");
                                            },
                                          )
                                        : CircleAvatar(
                                            backgroundImage: AssetImage(
                                                "assets/profile.png"),
                                            backgroundColor: Colors.grey[800],
                                            radius: 30,
                                          ),
                                    title: Text(
                                      mp2[returnedIndex]![i].name ?? "",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }),
                        )
                      : Container(
                          height: 200,
                          child: Center(
                            child: SpinKitRing(
                              color: widgetColor,
                              size: 50.0,
                            ),
                          ),
                        )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchData() async {
    try {
      var responses = await Future.wait([
        http.get(Uri.parse(widget.artistUrl), headers: requestHeaders),
        http.get(Uri.parse("${widget.artistUrl}/images"),
            headers: requestHeaders),
      ]);
      final data = artistFromJson(responses[0].body);
      final data2 = jsonDecode(responses[1].body);
      //print(data2["images"][3]["url"]);
      artistBio = data.artists![0];
      if (artistBio.bios == null || artistBio.bios?.length == 0) {
        bio = "No Data Found";
      } else {
        bio = artistBio.bios![0].bio ?? "No Data Found";
      }
      if (data2["images"].length != 0) {
        artistBio.imageUrl = data2["images"][3]["url"];
      } else {
        artistBio.imageUrl = "";
      }
      mp = {
        0: artistBio.albumGroups?.main ?? [],
        1: artistBio.albumGroups?.singlesAndEPs ?? [],
        2: artistBio.albumGroups?.compilations ?? [],
        3: artistBio.albumGroups?.others ?? [],
      };
      _getAlbumMainData();
      _getAlbumSinglesData();
      _getAlbumcompilationsData();
      _getAlbumOtherData();
      mp2 = {0: main, 1: single, 2: compilation, 3: others};
      setState(() {});
    } catch (e) {
      print("mee");
      mp = {
        0: [],
        1: [],
        2: [],
        3: [],
      };
    }
  }

  void _getAlbumMainData() async {
    if (mp[0].length > 0) {
      List<dynamic> albumIds = mp[0];
      for (dynamic id in albumIds) {
        if (main.length > 6) break;
        final response = await http.get(
            Uri.parse("https://api.napster.com/v2.2/albums/${id}"),
            headers: requestHeaders);
        final extractData = jsonDecode(response.body)['albums'][0];
        main.add(AlbumElement.fromJson(extractData));
        //main  = albumFromJson(response.body).albums as List<AlbumElement>;
        _getAlbumMainDataImage(main[main.length - 1]);
      }
    }
  }

  void _getAlbumMainDataImage(AlbumElement instance) async {
    try {
      final response = await http.get(Uri.parse("${instance.href}/images"),
          headers: requestHeaders);
      final extractedImage = jsonDecode(response.body)["images"][1]["url"];
      instance.imageUrl = extractedImage;
      setState(() {});
    } catch (err) {
      instance.imageUrl = "";
    }
  }

  void _getAlbumSinglesData() async {
    if (mp[1].length > 0) {
      List<dynamic> albumIds = mp[1];
      for (dynamic id in albumIds) {
        if (single.length > 6) break;
        final response = await http.get(
            Uri.parse("https://api.napster.com/v2.2/albums/${id}"),
            headers: requestHeaders);
        final extractData = jsonDecode(response.body)['albums'][0];
        single.add(AlbumElement.fromJson(extractData));
        _getAlbumSinglesDataImage(single[single.length - 1]);
      }
    }
  }

  void _getAlbumSinglesDataImage(AlbumElement instance) async {
    try {
      final response = await http.get(Uri.parse("${instance.href}/images"),
          headers: requestHeaders);
      final extractedImage = jsonDecode(response.body)["images"][1]["url"];
      instance.imageUrl = extractedImage;
      setState(() {});
    } catch (err) {
      instance.imageUrl = "";
    }
  }

  void _getAlbumcompilationsData() async {
    if (mp[2].length > 0) {
      List<dynamic> albumIds = mp[2];
      for (dynamic id in albumIds) {
        if (compilation.length > 6) break;
        final response = await http.get(
            Uri.parse("https://api.napster.com/v2.2/albums/${id}"),
            headers: requestHeaders);
        // final extractData = jsonDecode(response.body)['albums'][0];
        // compilation = albumFromJson(extractData).albums??[];
        final extractData = jsonDecode(response.body)['albums'][0];
        compilation.add(AlbumElement.fromJson(extractData));
        _getAlbumcompilationsDataImage(compilation[compilation.length - 1]);
      }
    }
  }

  void _getAlbumcompilationsDataImage(AlbumElement instance) async {
    try {
      final response = await http.get(Uri.parse("${instance.href}/images"),
          headers: requestHeaders);
      final extractedImage = jsonDecode(response.body)["images"][1]["url"];
      instance.imageUrl = extractedImage;
      setState(() {});
    } catch (err) {
      instance.imageUrl = "";
    }
  }

  void _getAlbumOtherData() async {
    if (mp[3].length > 0) {
      List<dynamic> albumIds = mp[3];
      for (dynamic id in albumIds) {
        if (others.length > 6) break;
        final response = await http.get(
            Uri.parse("https://api.napster.com/v2.2/albums/${id}"),
            headers: requestHeaders);
        // final extractData = jsonDecode(response.body)['albums'][0];
        // others = albumFromJson(extractData).albums??[];
        // others = albumFromJson(response.body).albums as List<AlbumElement>;
        final extractData = jsonDecode(response.body)['albums'][0];
        others.add(AlbumElement.fromJson(extractData));
        _getAlbumOtherDataImage(others[others.length - 1]);
      }
    }
  }

  void _getAlbumOtherDataImage(AlbumElement instance) async {
    try {
      final response = await http.get(Uri.parse("${instance.href}/images"),
          headers: requestHeaders);
      final extractedImage = jsonDecode(response.body)["images"][1]["url"];
      instance.imageUrl = extractedImage;
      setState(() {});
    } catch (err) {
      instance.imageUrl = "";
    }
  }

  void waiting() async {
    await fetchData();
  }
}
