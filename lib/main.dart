import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'common/utils/shared_preferences.dart';
import 'common/utils/provider.dart';
import 'dart:io';
import 'common/style/gzx_style.dart';



SpUtil sp;
var db;

void main()async{
  final provider = new Provider();

  await provider.init(true);
  sp = await SpUtil.getInstance();
  db = Provider.db;

  if(Platform.isAndroid){
    // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，
    // 覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。

    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle
      (statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  
  runApp(MyApp());

}


class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    double i = 84.99998982747397;

    print(i.toInt());

    // TODO: implement build
    return MaterialApp(
      title: 'MOCK TAOBAO DEMO',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch:GZXColors.primarySwatch,
      ),

      home: GZXBottomNavigationBar(),
    );
  }

}



















