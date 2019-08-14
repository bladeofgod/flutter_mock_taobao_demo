import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/animation/diff_scale_text.dart';
import 'package:flutter_mock_taobao_demo/common/data/home.dart';


class AnimationHeadlinesWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AnimationHeadlinesWidgetState();
  }

}

class AnimationHeadlinesWidgetState extends State<AnimationHeadlinesWidget> {

  int _diffScaleNext = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer _countDownTimer = new Timer.periodic(new Duration(seconds:3 ), (timer)
    {
        if(mounted){
          setState(() {
            _diffScaleNext++;
          });
        }
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: <Widget>[
        SizedBox(
          width: 8,
        ),
        Text(
          '淘宝头条',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          width: 8,
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: Container(
            color: Color(0xFFfef2f2),
            child: Text(
              '精华',
              style: TextStyle(
                fontSize: 10,
                color: Colors.red[500],
              ),
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: GestureDetector(
            onTap: (){},
            child: Container(
              child: DiffScaleText(
                text: headlines[_diffScaleNext %headlines.length],
                textStyle: TextStyle(fontSize: 12,color: Colors.black),
              ),
              height: 30,
              alignment: Alignment.centerLeft,
            ),
          ),
        ),
      ],
    );
  }
}



















