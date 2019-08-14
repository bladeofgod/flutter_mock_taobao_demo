import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mock_taobao_demo/common/model/search.dart';
import 'package:flutter_mock_taobao_demo/common/style/gzx_style.dart';
import 'package:flutter_mock_taobao_demo/common/utils/common_utils.dart';
import 'package:flutter_mock_taobao_demo/common/utils/screen_util.dart';


class GZXSearchResultListWidget extends StatelessWidget{

  final SearchResultListModel list;
  final ValueChanged<String> onItemTap;
  final VoidCallback getNextPage;

  GZXSearchResultListWidget(this.list,{this.onItemTap,this.getNextPage});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return list.data.length == 0 ?
            Center(
              child: CircularProgressIndicator(),
            ) : ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 10),
      itemCount:list.data.length ,
      itemExtent:ScreenUtil().L(127) ,
      itemBuilder: (BuildContext context,int i){
        SearchResultItemModel item = list.data[i];
        if((i+3) == list.data.length){
          print('SearchResultListWidget.build next page,current data count ${list.data.length}');
          getNextPage();
        }

        return Container(
          color: GZXColors.searchAppBarBgColor,
          padding: EdgeInsets.only(top: ScreenUtil().L(5),right: ScreenUtil().L(10)),
          child: Row(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: CachedNetworkImage(
                  fadeInDuration: Duration(milliseconds: 0),
                  fadeOutDuration: Duration(milliseconds: 0),
                  fit: BoxFit.fill,
                  imageUrl: item.imageUrl,
                  width: ScreenUtil().L(120),
                  height: ScreenUtil().L(120),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border:Border(bottom: BorderSide(width: 1,color:
                    GZXColors.divideLineColor)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        item.wareName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        children: <Widget>[
                          item.coupon == null ?
                              SizedBox() : Container(
                            margin: const EdgeInsets.only(left: 8,top: 0,
                                right: 0,bottom: 0),
                            child: Text(
                              item.coupon,style: TextStyle(color: Color(0xFFff692d), fontSize: 10),
                            ),
                            decoration: BoxDecoration(
                              borderRadius:BorderRadius.all(Radius.circular(3)),
                              border:Border.all(width: 1,color: Color(0xFFff692d))
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 8,top: 0,
                                right: 0,bottom: 0),
                            child: Text(
                              '包邮',style: TextStyle(color: Color(0xFFfebe35), fontSize: 10),
                            ),
                            decoration: BoxDecoration(borderRadius:
                            BorderRadius.all(Radius.circular(3)),
                            border: Border.all(width: 1, color: Color(0xFFffd589))),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '￥',
                            style: TextStyle(fontSize: 10, color: Color(0xFFff5410)),
                          ),
                          Text(
                            '${CommonUtils.removeDecimalZeroFormat(double.parse(item.price))}',
//                          '27.5',
                            style: TextStyle(fontSize: 16, color: Color(0xFFff5410)),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              '${item.commentcount}人评价',
//                            '23234人评价',
//                          product
                              style: TextStyle(fontSize: 10, color: Color(0xFF979896)),
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          )
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Row(
                              children: <Widget>[
                                Flexible(
                                  child: Text(
                                    '${item.shopName}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: GZXConstant.searchResultItemCommentCountStyle,
                                  ),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text('进店', style: TextStyle(fontSize: 12)),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Icon(
                                    Icons.chevron_left,size: 18,color: Colors
                                      .grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Icon(Icons.more_horiz,size: 15,color: Color(0xFF979896),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

}














