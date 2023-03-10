import 'package:flutter/material.dart';
import 'package:runomusic/sevices/albumService.dart';
import '../Models/album.dart';

class AlbumProvider extends ChangeNotifier{
  List<AlbumElement> _albums=[];
  bool isLoading = false;
  List<AlbumElement> get albums =>_albums;
  int _offset=0;
  int get offset => _offset;
  Future<void>getAllAlbums() async {
    isLoading = true;
    notifyListeners();
    final response = await AlbumService(_offset).getAlbums();
    _albums+=response;
    isLoading = false;
    notifyListeners();
  }
  Future<void>getMoreAlbums() async {
    if(_offset<=994){
      _offset+=9;
      notifyListeners();
    }
    final response = await AlbumService(_offset).getAlbums();
    _albums+=response;
    isLoading = false;
    notifyListeners();
  }
}