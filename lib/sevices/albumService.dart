import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Models/album.dart';
import 'package:runomusic/constants/constants.dart';
class AlbumService {
  int offset;
  AlbumService(this.offset);
  Future<dynamic> getAlbums() async {
    final response = await http.get(
        Uri.parse(
            "https://api.napster.com/v2.2/albums/top?limit=8&offset=${offset}"),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      final albumsData = response.body;
      final albums = albumFromJson(albumsData).albums??[];

        for(AlbumElement element in albums){
          final r2 = await http.get(Uri.parse("${element.href}/images"),
              headers: requestHeaders);
         try{
           final data = await jsonDecode(r2.body);
           if (data["images"]?.length!=null && data["images"].length>0) {
             element.imageUrl = data["images"][3]["url"];
           } else {
             element.imageUrl = "";
           }
         }catch(err){
           element.imageUrl = "";
         }
        };

      return albums;
    } else {
      return [];
    }
  }
}
