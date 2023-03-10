import 'package:flutter/material.dart';
import 'package:runomusic/pages/albumLayout.dart';
import 'package:runomusic/pages/albumLayout2.dart';
import '../Models/album.dart';
import '../constants/constants.dart';
import 'package:provider/provider.dart';
import '../provider/albumProvider.dart';

class AlbumView extends StatefulWidget {
  @override
  State<AlbumView> createState() => _AlbumViewState();
}

class _AlbumViewState extends State<AlbumView> {
  List<AlbumElement>newAlbumList=[];
  int currOffA = 0;
  final scrollcontrollerA = ScrollController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(mounted)
        Provider.of<AlbumProvider>(context, listen: false).getAllAlbums();
    });
    if(mounted)
    scrollcontrollerA.addListener(_scrollListner);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AlbumProvider>(builder: (context,value,child){
      newAlbumList = value.albums;
      return ListView.separated(
          itemCount:
          isLoading?newAlbumList.length : newAlbumList.length+1,
          scrollDirection: Axis.horizontal,
          controller: scrollcontrollerA,
          shrinkWrap: true,
          separatorBuilder: (ctx, index) {
            return SizedBox(
              width: 10,
            );
          },
          itemBuilder: (ctx, idx) {
            if (idx < newAlbumList.length) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AlbumLayout2(newAlbumList[idx])));
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: newAlbumList[idx].imageUrl == ""
                              ? SizedBox(
                            height: 150,
                            width: 150,
                            child: Image.asset("assets/profile.png"),
                          )
                              : Image.network(
                            newAlbumList[idx].imageUrl??"",
                            height: 150,
                            width: 150,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 8, bottom: 8),
                          alignment: Alignment.bottomLeft,
                          height: 150,
                          width: 150,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.black45,
                            child: Icon(Icons.play_arrow_rounded,color: Colors.white,),
                          ),
                        )
                      ]),
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          newAlbumList[idx].name!.length > 16
                              ? newAlbumList[idx].name!.substring(0, 13) + "..."
                              : newAlbumList[idx].name??"",
                          style: Theme.of(context).textTheme.bodyMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        newAlbumList[idx].artistName!.length > 16
                            ? newAlbumList[idx].artistName
                            !.substring(0, 12) +
                            "..."
                            : newAlbumList[idx].artistName??"",
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(color: widgetColor),
              );
            }
          });
    });
  }
  void _scrollListner() async {
    if (scrollcontrollerA.position.pixels ==
        scrollcontrollerA.position.maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {if(mounted)
        Provider.of<AlbumProvider>(context, listen: false).getMoreAlbums();
      });

      setState(() {
        isLoading = false;
      });
    }
  }
}
