import 'package:flutter/material.dart';
import 'package:flutter_mock_taobao_demo/common/data/home.dart';
import 'package:flutter_mock_taobao_demo/common/utils/navigator_utils.dart';
import 'package:flutter_mock_taobao_demo/common/style/gzx_style.dart';


class SearchSuggestPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchSuggestPageState();
  }

}

class SearchSuggestPageState extends State<SearchSuggestPage> {

  bool isHideSearchFind = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: BoxDecoration(
        borderRadius:BorderRadius.only(topLeft: Radius.circular(16),topRight:
        Radius.circular(16)),color: Colors.white
      ),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text('历史搜索',style: TextStyle(fontWeight: FontWeight
                    .bold,fontSize: 12),),
              ),
              Icon(
                Icons.delete_outline,
                color: Colors.grey,
                size: 16,
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
          SizedBox(
            width: 8,
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: searchRecordTexts.map((i)=>GestureDetector(
              onTap: (){
                NavigatorUtils.gotoSearchGoodsResultPage(context, i);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFf7f8f7),
                  borderRadius:BorderRadius.circular(13),
                ),
                padding: EdgeInsets.symmetric(vertical: 8,horizontal: 12),
                child: Text(i,style: TextStyle(color:  Color(0xFF565757),fontSize: 13),),
              ),
            )).toList(),
          ),
          SizedBox(
            height: 30,
          ),
          Row(
            children: <Widget>[
              SizedBox(
                width: 12,
              ),
              Expanded(
                child: Text(
                  '搜索发现',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    isHideSearchFind = ! isHideSearchFind;
                  });
                },
                child: Icon(
                  isHideSearchFind ? GZXIcons.attention_forbid : GZXIcons.attention_light,
                  color: Colors.grey,
                  size: 16,
                ),
              ),
              SizedBox(
                width: 8,
              )
            ],
          ),

          SizedBox(
            height: 16,
          ),
          Offstage(
            offstage: ! isHideSearchFind,
            child: Center(
              child: Text('当前搜索发现已隐藏',style: TextStyle(fontSize: 10,color:
              Colors.grey),),
            ),
          ),
          Expanded(
            child: Offstage(
              offstage: isHideSearchFind,
              child: GridView.count(
                padding: const EdgeInsets.only(left: 12),
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                reverse: false,
                scrollDirection: Axis.vertical,
                controller: ScrollController(
                  initialScrollOffset:0.0
                ),
                childAspectRatio: 12/2,
                physics: BouncingScrollPhysics(),
                primary: false,
                children: List.generate(searchHintTexts.length, (index){
                  return GestureDetector(
                    onTap: (){
                      NavigatorUtils.gotoSearchGoodsResultPage(context,
                          searchHintTexts[index]);
                    },
                    child: Container(
                      child: Text(
                        searchHintTexts[index],
                        style: TextStyle(fontSize: 13,color: Color(0xFF565757)),
                      ),
                    ),
                  );
                },growable: false),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
















