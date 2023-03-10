// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:runomusic/sevices/track_service.dart';

import '../Models/track.dart';

class TrackProvider extends ChangeNotifier{
  List<TrackElement> _tracks=[];
  bool isLoading = false;
  List<TrackElement> get tracks =>_tracks;
  int _offset=0;
  int get offset => _offset;
  Future<void>getAllTracks() async {
    isLoading = true;
    notifyListeners();
    final response = await TrackService(_offset).getTracks();
    _tracks+=response;
    isLoading = false;
    notifyListeners();
  }
  Future<void>getMoreTracks() async {
    if(_offset<=991){
      _offset+=10;
      notifyListeners();
    }
    final response = await TrackService(_offset).getTracks();
    _tracks+=response;
    isLoading = false;
    notifyListeners();
  }
}