import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mock_taobao_demo/common/model/search.dart';
import 'package:flutter_mock_taobao_demo/common/utils/common_utils.dart';


class GZXSearchResultGridViewWidget extends StatelessWidget{

  final SearchResultListModel list;
  final ValueChanged<String> onItemTa;
  final VoidCallback getNextPage;

  BuildContext _context;
  GZXSearchResultGridViewWidget(this.list,{Key key,this.onItemTa,this
      .getNextPage}) : super(key : key);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    _context = context;

    return list.data.length == 0 ? Center(
      child: CircularProgressIndicator(),
    ) : Padding(
      padding: const EdgeInsets.only(left: 8,right: 8),
      child: productGrid(list.data),
    );
  }


  Widget imageStack(String img) => Image.network(img,fit: BoxFit.cover,);

  Widget productGrid(List<SearchResultItemModel> data) => GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(_context).orientation == Orientation
            .portrait ? 2 :3,
    crossAxisSpacing: 8,mainAxisSpacing: 8,
        //宽高比 默认1
        childAspectRatio: 3/4),
    itemCount: list.data.length,
    itemBuilder: (BuildContext context,int index){
      var product = list.data[index];
      if((index + 4) == list.data.length){
        print(
            'SearchResultGridViewWidget.productGrid next page,current data count ${data.length},current index $index');
        getNextPage();
      }
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child:ConstrainedBox(
                    child: CachedNetworkImage(
                      fadeOutDuration: Duration(milliseconds: 0),
                      fadeInDuration: Duration(milliseconds: 0),
                      fit: BoxFit.fill,
                      imageUrl: product.imageUrl,
                    ),
                    constraints: BoxConstraints.expand(),
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8,top: 0,right: 8,
                      bottom: 0),
                  child: Text(
                    product.wareName,
                    maxLines: 2,style: TextStyle(fontSize: 12),
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  children: <Widget>[
                    product.coupon == null ?
                        SizedBox() : Container(
                      margin: const EdgeInsets.only(left: 8,top: 0,right: 0,
                          bottom: 0),
                      child: Text(
                        product.coupon,
                        style: TextStyle(color: Color(0xFFff692d), fontSize: 10),
                      ),
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.all(Radius.circular(3),),
                        border: Border.all(width: 1, color: Color(0xFFff692d))
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 8, top: 0, right: 0, bottom: 0),
                      child: Text(
                        '包邮',
                        style: TextStyle(color: Color(0xFFfebe35), fontSize: 10),
                      ),
//                            padding: EdgeInsets.symmetric(horizontal: 3),
//                            margin: EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3)),
                          border: Border.all(width: 1, color: Color(0xFFffd589))),
                    ),
                  ],
                ),
                SizedBox(
                  height: 18,
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
                      '${CommonUtils.removeDecimalZeroFormat(double.parse(product.price))}',
//                          '27.5',
                      style: TextStyle(fontSize: 16, color: Color(0xFFff5410)),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        '${product.commentcount}人评价',
//                            '23234人评价',
//                          product
                        style: TextStyle(fontSize: 10, color: Color(0xFF979896)),
                      ),
                    ),
                    Icon(
                      Icons.more_horiz,
                      size: 15,
                      color: Color(0xFF979896),
                    ),
                    SizedBox(
                      width: 8,
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                )
              ],
            ),
          ),
        ),
      );
    },
  );

}



















