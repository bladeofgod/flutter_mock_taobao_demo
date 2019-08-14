import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mock_taobao_demo/common/model/kingkong.dart';
import 'package:flutter_mock_taobao_demo/common/model/tab.dart';
import 'package:flutter_mock_taobao_demo/common/dao/app_dao.dart';
import 'package:flutter_mock_taobao_demo/common/data/home.dart';
import 'package:flutter_mock_taobao_demo/common/style/gzx_style.dart';
import 'package:flutter_mock_taobao_demo/common/utils/screen_util.dart';
import 'package:flutter_mock_taobao_demo/common/utils/navigator_utils.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/gzx_tabbar.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/gzx_topbar.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_mock_taobao_demo/ui/tools/arc_clipper.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/menue.dart';
import 'package:flutter_mock_taobao_demo/ui/page/home/searchlist_page.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/recommend.dart';
import 'package:flutter_mock_taobao_demo/common/model/product.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/animation/diff_scale_text.dart';
import 'package:flutter_mock_taobao_demo/ui/widget/animation_headlines.dart';
import 'package:flutter_mock_taobao_demo/common/services/search.dart';



class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> with TickerProviderStateMixin,AutomaticKeepAliveClientMixin {

  List<KingKongItem> kingKongItems;
  List<TabModel> _tabModels = [];

  List _hotWords = [];

  AnimationController _animationController;
  TabController _controller;
  int currentIndex=  0;

  Timer _countdownTimer;
  Size _sizeRed;

  String get hourString{
    Duration duration = _animationController.duration * _animationController
        .value;
    return '${(duration.inHours)..toString().padLeft(2,'0')}';
  }

  String get minuteString{
    Duration duration = _animationController.duration * _animationController
        .value;
    return '${(duration.inMinutes %60).toString().padLeft(2,"0")}';
  }

  String get secondString{
    Duration duration = _animationController.duration * _animationController
        .value;
    return '${(duration.inSeconds%60).toString().padLeft(2,"0")}';
  }

  ScrollController _scrollController = ScrollController();
  ScrollController _scrollViewController = ScrollController();
  GlobalKey _keyFilter = GlobalKey();

  void initData()async{
    List querys = await getHotSugs();
    setState(() {
      _hotWords = querys;
    });
  }

  _afterLayout(_){
    _getPositions('_keyFilter', _keyFilter);
    _getSizes('_keyFilter', _keyFilter);
  }

  _getPositions(log,GlobalKey globalKey){
    RenderBox renderBoxRed = globalKey.currentContext.findRenderObject();
    var positionRed = renderBoxRed.localToGlobal(Offset.zero);
  }

  _getSizes(log,GlobalKey globalKey){
    RenderBox renderBoxRed = globalKey.currentContext.findRenderObject();
    _sizeRed = renderBoxRed.size;
    setState(() {

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //当前frame 执行不完毕后，会执行callback 回调中的方法
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);

    AppDao.getNewVersion(context, false);

    kingKongItems = KingKongList.fromJson(menueDataJson['items']).items;

    _tabModels.add(TabModel(title: '全部',subtitle: '猜你喜欢'));
    _tabModels.add(TabModel(title: '直播',subtitle: '网红推荐'));
    _tabModels.add(TabModel(title: '便宜好货', subtitle: '低价抢购'));
    _tabModels.add(TabModel(title: '买家秀', subtitle: '购后分享'));
    _tabModels.add(TabModel(title: '全球', subtitle: '进口好货'));
    _tabModels.add(TabModel(title: '生活', subtitle: '享受生活'));
    _tabModels.add(TabModel(title: '母婴', subtitle: '母婴大赏'));
    _tabModels.add(TabModel(title: '时尚', subtitle: '时尚好货'));

    //倒计时
    _animationController = AnimationController(vsync: this,duration: Duration
      (hours: 10,minutes: 30,seconds: 0));
    _animationController.reverse(from: _animationController.value == 0.0 ? 1.0 :
    _animationController);

    initData();

    _controller = TabController(length: 8, vsync: this);
    _controller.addListener(_handleTabSelection);
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);


  }

  @override
  void dispose() {
    // TODO: implement dispose
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _scrollViewController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    var v = Column(
      children: <Widget>[
        _buildHotSearchWidget(),
        _buildSwiperImageWidget(),
        _buildSwiperButtonWidget(),
        _buildRecommandedCard(),
        _buildAdvertisingWidget(),
      ],
    );

    var body= NestedScrollView(
      controller: _scrollViewController,
      headerSliverBuilder: (BuildContext context, bool boxIsScrolled){
        return <Widget>[
          SliverAppBar(
            pinned: true,
            floating: true,
            forceElevated: boxIsScrolled,
            backgroundColor: GZXColors.mainBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[v],
              ),
            ),
            expandedHeight: (_sizeRed == null ?ScreenUtil.screenHeight :
            _sizeRed.height) + 50,
            bottom: PreferredSize(child: GZXTabBarWidget(
              tabController: _controller,
              tabModels: _tabModels,
              currentIndex: currentIndex,
            ) , preferredSize: Size(double
                .infinity, 46)),
          ),
        ];
      },
      body: _hotWords.length == 0
            ? Center(
        child: CircularProgressIndicator(),
      ) : TabBarView(controller: _controller,children: _searchResultListPages
        (),),
    );

    return Scaffold(
      backgroundColor: GZXColors.mainBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          brightness: Brightness.dark,
          elevation: 0,
        ),
      ),
      body: Column(
        children: <Widget>[
          Offstage(
            offstage: true,
            child: Container(
              child: v,
              key: _keyFilter,
            ),
          ),
          GZXTopBar(
            searchHintTexts: searchHintTexts,
          ),
          Expanded(child: body,)
        ],
      ),
    );
  }


  Widget _buildHotSearchWidget(){
    return Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Text(
            '热搜',
            style: TextStyle(color: Colors.white,fontSize: 13),
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Row(
                children: searchHintTexts.map((String item){
                  return GestureDetector(
                    onTap: (){
                      NavigatorUtils.gotoSearchGoodsResultPage(context, item);
                    },
                    child: Container(
                      margin: EdgeInsets.all(4),
                      height: 20,
                      child: new Material(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color(0xFFfe8524),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8,right: 8),
                          child: Center(
                            child: Text(
                              item,style: TextStyle(color: Colors.white,
                                fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildSwiperImageWidget(){
    return Container(
      height: 150.0,
      //banner likely
      child: Swiper(
        /// 初始的时候下标位置
        index: 0,

        /// 无限轮播模式开关
        loop: true,
        itemBuilder: (context,index){
          return GestureDetector(
            onTap: (){},
            child: Container(
              height: 150,
              child: ClipPath(
                //圆弧
                clipper: new ArcClipper(),
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 150,
                      child: CachedNetworkImage(
                        fadeOutDuration: const Duration(milliseconds: 300),
                        fadeInDuration: const Duration(milliseconds:  700),
                        fit: BoxFit.fill,
                        imageUrl: banner_images[index],
                        errorWidget: (context,url,error) => new Icon(Icons.error),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
        itemCount: banner_images.length,
        /// 设置 new SwiperPagination() 展示默认分页指示器
        pagination: SwiperPagination(),
        autoplay: true,
        duration: 300,
        onTap: (index){
          print("you click $index");
        },
        scrollDirection: Axis.horizontal,
      ),
    );
  }


  Widget _buildSwiperButtonWidget(){
    return Container(
      height: ScreenUtil().L(80)*2+15,
      child: Swiper(
        index: 0,
        loop: true,
        itemBuilder: (context,index){
          List data = [];
          for(var i = (index * 2) * 5; i < (index * 2) *5+5;++i){
            if(i >= kingKongItems.length){
              break;
            }
            data.add(kingKongItems[i]);
          }
          List data1 = [];
          for(var i = (index * 2 +1)*5;i<(index * 2+1)*5+5;++i){
            if(i>=kingKongItems.length){
              break;
            }
            data1.add(kingKongItems[i]);
          }
          return Column(
            children: <Widget>[
              HomeKingKongWidget(
                data: data,
                fontColor: (menueDataJson['config'] as dynamic)['color'],
                bgurl: (menueDataJson['config'] as dynamic)['pic_url'],
              ),
              HomeKingKongWidget(
                data: data1,
                fontColor: (menueDataJson['config'] as dynamic)['color'],
                bgurl: (menueDataJson['config'] as dynamic)['color'],
              )
            ],
          );
        },
        itemCount: (kingKongItems.length / 10).toInt() + (kingKongItems
            .length%10) >=0 ? 1: 0,
        /// 设置 new SwiperPagination() 展示默认分页指示器
        pagination: new SwiperPagination(
          alignment:Alignment.bottomCenter,
          builder:RectSwiperPaginationBuilder(
            color:Color(0xFFd3d7de),
            activeColor:Theme.of(context).primaryColor,
            size:Size(18, 3),
            activeSize:Size(18, 3),
            space: 0
          ),
        ),
        autoplay: false,duration: 300,onTap: (index){
          print('you just click $index');
      },
        scrollDirection: Axis.horizontal,
      ),
    );
  }


  Widget _buildAdvertisingWidget(){
    return Container(
      margin: EdgeInsets.only(left: 8,top: 0,right: 8,bottom: 10),
      height: 80,
      child: ConstrainedBox(child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset('static/images/618.png',fit: BoxFit.fill,),
      ),constraints: new BoxConstraints.expand(),),
    );
  }


  _handleTabSelection(){

    setState(() {
      currentIndex = _controller.index;
    });
  }


  List<Widget> _searchResultListPages(){
    List<Widget> pages = [];
    for(var i=0;i<8 ;++i){
      var page = SearchResultListPage(
        _hotWords[i],onNotification: _onScroll,
        isRecommended: true,
        isList: false,
      );
      pages.add(page);
    }
    return pages;
  }

  double _lastScrollPixels = 0;

  bool _onScroll(ScrollNotification scroll) {
    return false;
  }

  Widget _buildRecommandedCard(){
    Positioned unReadMsgCountText = Positioned(
      child: Container(
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (_,Widget child){
            return Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    color: Colors.red,
                    child: Text(
                      hourString,style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(color: Colors.red),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    color: Colors.red,
                    child: Text(
                      minuteString,style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Text(
                  ':',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(3),
                  child: Container(
                    color: Colors.red,
                    child: Text(
                      secondString,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
      left: 55,
      top: 10,
    );
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius:BorderRadius.all(Radius.circular(16.0))
        ),
        //对Widget截取的行为，比如这里 Clip.antiAlias 指抗锯齿
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  RecommendFloor(ProductListModel.fromJson(recommendJson)),
                  unReadMsgCountText,
                ],
              ),
              Container(
                width: ScreenUtil.screenWidth,height: 0.7,color: GZXColors.mainBackgroundColor,
              ),
              AnimationHeadlinesWidget(),
            ],
          ),
        ),
      ),
    );
  }



  @override
  // TODO: implement wantKeepAlive

  bool get wantKeepAlive => true;











}









