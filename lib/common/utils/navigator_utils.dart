import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter_mock_taobao_demo/ui/page/home/search_goods_page.dart';
import 'package:flutter_mock_taobao_demo/ui/page/home/search_goods_result_page.dart';
import 'package:flutter_mock_taobao_demo/ui/page/message/gzx_chat_page.dart';


class NavigatorUtils{

  static gotoSearchGoodsPage(BuildContext context,{String keywords}){
    return Navigator.of(context).push(new MyCupertinoPageRote(SearchGoodsPage
      (keywords)));
  }

  static gotoSearchGoodsResultPage(BuildContext context,String keyWords){
    NavigatorRouter(context, new SearchGoodsResultPage(keywords: ,));

  }

  static Future gotoGZXChatPage(BuildContext context, conversation){
    return NavigatorRouter(context, new GZXChatPage(conversation: conversation,));
  }

  static NavigatorRouter(BuildContext context,Widget widget){
    return Navigator.push(context,new CupertinoPageRoute(builder: (context)
    =>widget));
  }


  static Future<T> showGSYDialog<T>({
    @required BuildContext context,bool barrierDismissible = true,
    WidgetBuilder builder,
  }){
    return showDialog(context: context,barrierDismissible:
    barrierDismissible,builder: (context){
      return MediaQuery(
        ///不受系统字体缩放影响
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: new SafeArea(child: builder(context)),
      );
    });
  }

}



class MyCupertinoPageRote extends CupertinoPageRoute{
  Widget widget;

  MyCupertinoPageRote(this.widget):super(builder:(BuildContext context)
  =>widget);

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return new FadeTransition(opacity: animation,child: widget,);
    return super.buildPage(context, animation, secondaryAnimation);
  }

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(seconds: 0);

}
























