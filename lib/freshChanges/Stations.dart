import 'package:flutter/material.dart';
import '../Models/station.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/widgets/image.dart' as img;
class Stations extends StatefulWidget {
  const Stations({Key? key}) : super(key: key);

  @override
  State<Stations> createState() => _StationsState();
}

class _StationsState extends State<Stations> {
  List<StationElement>arr=[];
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchStation();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: arr.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (_,idx){
          return Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: arr[idx].links?.largeImage?.href == ""
                      ? SizedBox(
                    height: 150,
                    width: 150,
                    child: img.Image.asset("assets/profile.png"),
                  )
                      : img.Image.network(
                    arr[idx].links?.largeImage?.href??"",
                    fit: BoxFit.cover,
                    height: 160,
                    width: 150,
                  ),
                ),
                Text(arr[idx].name??"",
                    overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        });
  }

  Future<void> fetchStation() async {
    try {
      final response = await http.get(Uri.parse(
          "https://api.napster.com/v2.2/stations?apikey=OTYxNDY3NTItZmM1Zi00MTMzLTllN2UtMDk2ZTBlMzIyYTZm"));
      final extractedData = stationFromJson(response.body).stations;
      arr=extractedData!;
      setState(() {});
    } catch (e) {
      print(e);
    }
  }
}
