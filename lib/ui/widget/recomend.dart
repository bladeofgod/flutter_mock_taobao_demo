import 'package:flutter/material.dart';
import 'package:flutter_mock_taobao_demo/common/style/gzx_style.dart';


class RecomendListWidget extends StatelessWidget{

  final List<String> items;
  final ValueChanged<String> onItemTap;

  RecomendListWidget(this.items, {this.onItemTap});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var listView = ListView.separated(itemBuilder: null, separatorBuilder: null, itemCount: null)

    return null;
  }

}