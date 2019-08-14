import 'dart:math' as Math;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class DiffScaleText extends StatefulWidget{

  final String text;
  final TextStyle textStyle;


  const DiffScaleText({Key key,this.text,this.textStyle}) : assert
  (text!=null),super(key : key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DiffScaleTextState();
  }

}

class DiffScaleTextState extends State<DiffScaleText> with
    TickerProviderStateMixin<DiffScaleText>{

  AnimationController _animationController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(vsync: this,duration: Duration
      (milliseconds: 400));
    _animationController.addStatusListener((status){});
  }

  @override
  void didUpdateWidget(DiffScaleText oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(oldWidget.text != widget.text){
      if(!_animationController.isAnimating){
        _animationController.value = 0;
        _animationController.forward();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    TextStyle textStyle = widget.textStyle == null
        ? TextStyle(
      fontSize: 20,
      color: Colors.white,
    )
        : widget.textStyle;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget child){
        //当widget 重绘时，会逐层向上遍历父节点（因为子节点的变动可能会影响父节点，进而需要重辉）
        //当遍历抵达 RepaintBoundary()时，表明 它的重绘不会导致父节点的重绘
        return RepaintBoundary(
          child: CustomPaint(
            child: Text(
              widget.text,
              style: textStyle.merge(TextStyle(color: Color(0x00000000))),
              maxLines: 1,
              textDirection: TextDirection.ltr,
            ),
            foregroundPainter: _DiffText(),
          ),
        );
      },
    );
  }
}


class _DiffText extends CustomPainter{

  final String text;
  final TextStyle textStyle;
  final double progress;
  String _oldText;
  List<_TextLayoutInfo> _textLayoutInfo = [];
  List<_TextLayoutInfo> _oldTextLayoutInfo = [];

  Alignment alignment;

  _DiffText({
    this.text,this.textStyle,this.progress = 1,this.alignment = Alignment.center
}) : assert(text != null),assert(textStyle != null);



  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint

    double percent = Math.max(0, Math.min(1, progress));
    if(_textLayoutInfo.length == 0){
      calculateLayoutInfo(text,_textLayoutInfo);
    }
    canvas.save();
    if(_oldTextLayoutInfo != null && _oldTextLayoutInfo.length > 0 ){
      for(_TextLayoutInfo _oldTextLayoutInfo in _oldTextLayoutInfo){
        if(_oldTextLayoutInfo.needMove){
          double p = percent * 2;
          p = p > 1 ? 1 : p;
          drawText(
            canvas,
              _oldTextLayoutInfo.text,
            1,1,
              Offset(_oldTextLayoutInfo.offsetX - (_oldTextLayoutInfo.offsetX
                  - _oldTextLayoutInfo.toX) * p,_oldTextLayoutInfo.offsetY),
            _oldTextLayoutInfo
          );
        }else{
          drawText(
            canvas,
            _oldTextLayoutInfo.text,
            1-percent,
            percent,
            Offset(_oldTextLayoutInfo.offsetX, _oldTextLayoutInfo.offsetY),
            _oldTextLayoutInfo
          );
        }
      }
    }else{
      percent = 1;
    }
    for(_TextLayoutInfo _textLayoutInfo in _textLayoutInfo){

      if(!_textLayoutInfo.needMove){
        drawText(
          canvas,
          _textLayoutInfo.text,
          percent,
          percent,
          Offset(_textLayoutInfo.offsetX, _textLayoutInfo.offsetY),
          _textLayoutInfo
        );
      }

    }
    canvas.restore();

  }


  void drawText(Canvas canvas,String text,double textScaleFactor,double
  alphaFactor,Offset offset,_TextLayoutInfo textLayoutInfo){
    var textPaint = Paint();
    if(alphaFactor == 1){
      textPaint.color = textStyle.color;
    }else{
      textPaint.color = textPaint.color.withAlpha((textStyle.color.alpha *
          alphaFactor).floor());
    }

    var textPainter = TextPainter(
      text:TextSpan(
        text: text,
        style:textStyle.merge(TextStyle(color: null,
              foreground: textPaint,textBaseline: TextBaseline.ideographic))
      ),
      textDirection:TextDirection.ltr
    );
    textPainter.textAlign = TextAlign.center;
    textPainter.textScaleFactor = textScaleFactor;
    textPainter.textDirection = TextDirection.ltr;
    textPainter.layout();
    textPainter.paint(canvas, Offset(offset.dx, offset.dy + (textLayoutInfo
        .height -  textLayoutInfo.height) / 2));

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    if(oldDelegate is _DiffText){
      String oldFrameText = oldDelegate.text;
      if(oldFrameText == text){
        this._oldText = oldDelegate._oldText;
        this._oldTextLayoutInfo = oldDelegate._oldTextLayoutInfo;
        this._textLayoutInfo = oldDelegate._textLayoutInfo;
        if(this.progress == oldDelegate.progress){
          return false;
        }
      }else{
        this._oldText = oldDelegate.text;
        calculateLayoutInfo(text,_textLayoutInfo);
        calculateLayoutInfo(_oldText,_oldTextLayoutInfo);
        calculateMove();
      }
    }
    return true;
  }

  void calculateLayoutInfo(String text,List<_TextLayoutInfo> list){
    list.clear();
    TextPainter textPainter = TextPainter(
      text:TextSpan(text: text,style: textStyle),
      textDirection:TextDirection.ltr,
      maxLines: 1
    );
    textPainter.layout();
    for(int i=0; i <text.length ; i++){
      var forCaret = textPainter.getOffsetForCaret(TextPosition(offset: i), Rect.zero);
      var offsetX = forCaret.dx;
      if(i>0 && offsetX == 0){
        break;
      }

      var textLayoutInfo = _TextLayoutInfo();
      textLayoutInfo.text = text.substring(i,i+1);
      textLayoutInfo.offsetX = offsetX;
      textLayoutInfo.offsetY = forCaret.dy;
      textLayoutInfo.width = 0;
      textLayoutInfo.height = textPainter.height;
      textLayoutInfo.baseline = textPainter.computeDistanceToActualBaseline
        (TextBaseline.ideographic);
      list.add(textLayoutInfo);
    }
  }

  void calculateMove(){
    if (_oldTextLayoutInfo == null || _oldTextLayoutInfo.length == 0) {
      return;
    }
    if (_textLayoutInfo == null || _textLayoutInfo.length == 0) {
      return;
    }

    for (_TextLayoutInfo oldText in _oldTextLayoutInfo) {
      for (_TextLayoutInfo text in _textLayoutInfo) {
        if (!text.needMove && !oldText.needMove && text.text == oldText.text) {
          text.fromX = oldText.offsetX;
          oldText.toX = text.offsetX;
          text.needMove = true;
          oldText.needMove = true;
        }
      }
    }

  }

}



class _TextLayoutInfo {
  String text;
  double offsetX;
  double offsetY;
  double baseline;
  double width;
  double height;
  double fromX = 0;
  double toX = 0;
  bool needMove = false;
}



















