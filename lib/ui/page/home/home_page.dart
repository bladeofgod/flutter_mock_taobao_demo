import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mock_taobao_demo/common/model/kingkong.dart';
import 'package:flutter_mock_taobao_demo/common/model/tab.dart';



class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {

  List<KingKongItem> kingKongItems;
  List<TabModel> _tabModels = [];

  List _hotWords = [];

  AnimationController _animationController;
  TabController _controller;
  int currentIndex=  0;

  Timer _countdownTimer;
  Size _sizeRed;

  String get hourString{
    Duration duration = _animationController.duration * _animationController
        .value;
    return '${(duration.inHours)..toString().padLeft(2,'0')}';
  }

  String get minuteString{
    Duration duration = _animationController.duration * _animationController
        .value;
    return '${(duration.inMinutes %60).toString().padLeft(2,"0")}';
  }

  String get secondString{
    Duration duration = _animationController.duration * _animationController
        .value;
    return '${(duration.inSeconds%60).toString().padLeft(2,"0")}';
  }

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollViewController = ScrollController();
  GlobalKey _keyFilter = GlobalKey();

  void initData()async{
    List querys = await getHotSugs();
    setState(() {
      _hotWords = querys;
    });
  }

  _afterLayout(){
    _getPositions('_keyFilter', _keyFilter);
    _getSizes('_keyFilter', _keyFilter);
  }

  _getPositions(log,GlobalKey globalKey){
    RenderBox renderBoxRed = globalKey.currentContext.findRenderObject();
    var positionRed = renderBoxRed.localToGlobal(Offset.zero);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }

  @override
  // TODO: implement wantKeepAlive

  bool get wantKeepAlive => true;











}









