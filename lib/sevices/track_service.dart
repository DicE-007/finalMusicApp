import 'dart:convert';
// import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:runomusic/Models/track.dart';
import 'package:runomusic/constants/constants.dart';
class TrackService {
  int offset;
  TrackService(this.offset);
  Future<List<TrackElement>> getTracks() async {
    final response = await http.get(
        Uri.parse(
            "https://api.napster.com/v2.2/tracks/top?limit=10&offset=${offset}"),
        headers: requestHeaders);
    if (response.statusCode == 200) {
      final tracksData = response.body;
      final tracks = trackFromJson(tracksData).tracks??[];
       for(TrackElement element in tracks){
         final r2 = await http.get(Uri.parse("${element.links?.artists?.href}/images"),
             headers: requestHeaders);
         try{
           final data = await jsonDecode(r2.body);
           if (data["images"]?.length != null && data["images"].length>0) {
             element.imageUrl = data["images"][3]["url"];
           } else {
             element.imageUrl = "";
           }
         }catch(err){
           element.imageUrl = "";
         }

       };

      return tracks;
    } else {
      return [];
    }
  }
}
