

import 'package:flutter/material.dart';
import 'package:flutter_mock_taobao_demo/common/style/gzx_style.dart';
import 'package:flutter_mock_taobao_demo/common/services/search.dart';

import 'package:flutter_mock_taobao_demo/common/utils/navigator_utils.dart';
import 'package:flutter_mock_taobao_demo/ui/page/home/search_suggest_page.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/gzx_search_card.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/recomend.dart';


class SearchGoodsPage extends StatefulWidget{

  final String keywords;

  const SearchGoodsPage({Key key,this.keywords}) : super(key :key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return SearchGoodsPageState();
  }

}

class SearchGoodsPageState extends State<SearchGoodsPage> {

  List _tabsTitle = ['全部', '天猫', '店铺'];
  List<String> recomendWords = [];

  TextEditingController _keywordsEditingController =TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _keywordsEditingController.text = widget.keywords;
    if(widget.keywords != null){
      searchTxtChanged(widget.keywords);
    }

  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: GZXColors.mainBackgroundColor,
      appBar: PreferredSize(
          child: AppBar(
            brightness: Brightness.light,
            backgroundColor: GZXColors.mainBackgroundColor,
            elevation: 0,
          ),
          preferredSize: Size.fromHeight(0)),
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 1,
                child: GZXSearchCardWidget(
                  elevation: 0,
                  autofocus: true,
                  textEditingController: _keywordsEditingController,
                  isShowLeading: false,
                  onSubmitted: (value){
                    NavigatorUtils.gotoSearchGoodsResultPage(context, value);
                  },
                  onChanged: (value){
                    searchTxtChanged(value);
                  },
                ),
              ),
              GestureDetector(
                child: Text(
                  '取消',style: TextStyle(fontSize: 13),
                ),
                onTap: (){
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 8,
              ),
            ],
          ),
          Expanded(
            child: (
            recomendWords.length == 0 ? _buildContentWidget()
                : RecomendListWidget(recomendWords,onItemTap: (value){
                  NavigatorUtils.gotoSearchGoodsResultPage(context, value);
            },)
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContentWidget(){
    return Column(
      children: <Widget>[
        SizedBox(
          height: 8,
        ),
        TabBar(
          indicatorColor: Color(0xFFfe5100),
          indicatorSize: TabBarIndicatorSize.label,
          isScrollable: true,
          labelColor: Color(0xFFfe5100),
          unselectedLabelColor: Colors.black,
          labelPadding: EdgeInsets.only(left: 40,right: 40),
          labelStyle: TextStyle(fontSize: 12),
          onTap: (i){},
          tabs: _tabsTitle.map((i){
            return Text(i,style: TextStyle(fontSize: 15),);
          }).toList(),
        ),
        SizedBox(height: 8,),
        Expanded(
          child: TabBarView(
            children: <Widget>[
              SearchSuggestPage(),
              SearchSuggestPage(),
              SearchSuggestPage(),
            ],
          ),
        )
      ],
    );
  }


  void searchTxtChanged(String q)async{
    var result = await getSuggest(q) as List;
    recomendWords = result.map((dynamic i){
      List item = i as List;
      return item[0] as String;
    }).toList();
    setState(() {

    });
  }









}























