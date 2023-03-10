import 'package:flutter/material.dart';
import '../Models/track.dart';
class FavouriteProvider extends ChangeNotifier{
  final List<Track> _favTracks=[];
  List<Track> get favTracks =>_favTracks;

  void addFav(Track item){
    final isExist = _favTracks.contains(item);
    if(isExist){
      _favTracks.remove(item);
    }
    else{
      _favTracks.add(item);
    }
    notifyListeners();
  }

  bool isExist(Track item){
    final isExist = _favTracks.contains(item);
    return isExist;
  }
}