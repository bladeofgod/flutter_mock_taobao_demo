import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mock_taobao_demo/common/model/product.dart';
import 'package:flutter_mock_taobao_demo/common/utils/common_utils.dart';


class RecommendFloor extends StatelessWidget{

  final ProductListModel data;
  RecommendFloor(this.data);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      child: _build(deviceWidth),
    );
  }

  Widget _build(double deviceWidth){
    List<ProductItemModel> items = data.items;

    deviceWidth -= 28;
    double itemWidth = deviceWidth / 4;
    double imageWidth = deviceWidth / 4;

    List<Widget> listWidgets = items.map((i){
      var bgColor = CommonUtils.string2Color(i.bgColor);
      Color titleColor = CommonUtils.string2Color(i.titleColor);
      Color subtitleColor = CommonUtils.string2Color(i.subtitleColor);
      return Container(
        width: itemWidth,
        padding: EdgeInsets.only(top: 8,left: 3,bottom: 7,right: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 25,
              child: Text(
                i.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,
                    color: titleColor),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Container(
                color: bgColor,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      i.subtitle,
                      maxLines: 1,
                      style: TextStyle(color: subtitleColor,fontWeight:
                      FontWeight.w500,fontSize: 12),
                    ),
                    Container(
                      alignment: Alignment(0, 0),
                      margin: EdgeInsets.only(top: 5),
                      child: CachedNetworkImage(
                        imageUrl: i.picurl,
                        width: imageWidth,
                        height: imageWidth+20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
    return Column(
      children: <Widget>[
        Wrap(
          spacing: 0,
          children: listWidgets,
        ),
      ],
    );
  }

}


















