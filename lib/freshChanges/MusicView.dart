import 'package:flutter/material.dart';

import '../widgets/trackView.dart';
class MusicView extends StatelessWidget {
  final ScrollController scrollControllerH;
  MusicView(this.scrollControllerH);

  @override
  Widget build(BuildContext context) {
    return TrackView(scrollControllerH);
  }
}
