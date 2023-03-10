import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:runomusic/Models/artist.dart';
import 'package:runomusic/freshChanges/MusicView.dart';
import 'package:runomusic/freshChanges/Stations.dart';
import 'package:runomusic/freshChanges/popularToday.dart';
import 'package:runomusic/freshChanges/searchPage.dart';
import 'package:runomusic/tops/categories.dart';
import 'package:runomusic/widgets/albumView.dart';
import 'package:runomusic/widgets/artistHorizontalList.dart';
import 'package:runomusic/widgets/myPlaylist.dart';
import 'package:runomusic/widgets/playlistView.dart';
import 'package:runomusic/widgets/trackView.dart';
import '../constants/constants.dart';
import '../provider/trackProvider.dart';

class Home_Page extends StatefulWidget {
  static const path = "/home_page";
  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  int selectedIndex=0;
  void indexChanger(int idx){
    setState(() {
      selectedIndex=idx;
    });
  }
  int returnedIndex = 0;

  List<Widget>widgets=[
    HomePage2(),
    SearchPage(),
    MyPlaylist(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(9),
          child: widgets[selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: indexChanger,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.black,
          selectedItemColor: widgetColor,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home,size: 30,),label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search,size: 30,),label: "Search"),
            BottomNavigationBarItem(icon: Icon(Icons.reorder_rounded,size: 30,),label: "Your Playlist",),
          ],
        ),
      ),
    );
  }
}

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  State<HomePage2> createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  Map<dynamic, dynamic> data = {};

  final scrollControllerH = ScrollController();
  int returnedIndex = 0;
  void _returndeValFromchild(int x) {
    setState(() {
      returnedIndex = x;
    });
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty
        ? data
        : ModalRoute.of(context)?.settings.arguments as Map;
    List<ArtistElement> artistlist = data["artistlist"];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              morning,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MyPlaylist()));
              },
              child: Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            )
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Category(["Home", "Music"], _returndeValFromchild),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              controller: scrollControllerH,
              child: returnedIndex==0?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "ALBUMS",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                    height: 200,
                    child: AlbumView(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "ARTISTS",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  Container(
                    height: 90,
                    padding: const EdgeInsets.only(left: 8),
                    child: ArtistList(artistlist),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "POPULAR TODAY",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                      height: 200,
                      child: PopularToday()),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "STATIONS",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Container(
                      height: 200,
                      child: Stations()),
                ],
              ):
                  TrackView(scrollControllerH)
            )
                // : PlaylistView(),
          ),
        )
      ],
    );
  }
}

