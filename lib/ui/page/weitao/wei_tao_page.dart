import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mock_taobao_demo/common/model/image.dart';
import 'package:flutter_mock_taobao_demo/common/model/post.dart';
import 'package:flutter_mock_taobao_demo/common/model/search.dart';
import 'package:flutter_mock_taobao_demo/common/services/meinv.dart';
import 'package:flutter_mock_taobao_demo/common/services/search.dart';
import 'package:flutter_mock_taobao_demo/common/style/gzx_style.dart';
import 'package:flutter_mock_taobao_demo/common/utils/screen_util.dart';
import 'package:flutter_mock_taobao_demo/ui/page/weitao/weitao_list_page.dart';




class WeiTaoPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return WeiTaoPageState();
  }

}

class WeiTaoPageState extends State<WeiTaoPage> with
    TickerProviderStateMixin,AutomaticKeepAliveClientMixin {

  List<PostModel> _postModels = [];

  Widget profileColumn(BuildContext context,PostModel post) =>Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      CircleAvatar(
        backgroundImage: NetworkImage(post.logoImage),
      ),
      Expanded(
        child: Padding(
          padding: const  EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                post.name,
//                  style: Theme.of(context).textTheme.body1.apply(fontWeightDelta: 100),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
              SizedBox(
                height: 4.0,
              ),
              Text(
                post.postTime,
                style: Theme.of(context).textTheme.caption.apply(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    ],
  );

  Widget actionColumn(PostModel post){
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            '${post.readCout}万阅读',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        GestureDetector(
          onTap: (){
            setState(() {
              post.isLike = !post.isLike;
              if(post.isLike){
                  post.likesCount++;
              }else{
                post.likesCount--;
              }
            });
          },
          child: Row(
            children: <Widget>[
              Icon(
                post.isLike ? GZXIcons.appreciate_fill_light : GZXIcons.appreciate_light,
                color: post.isLike ? Colors.red : Colors.black,
              ),
              Text(
                post.likesCount.toString(),
                style: TextStyle(color: post.isLike ? Colors.red : Colors.black),
              )
            ],
          ),
        ),
        SizedBox(
          width: 25,
        ),

        GestureDetector(
          onTap: (){},
          child: Row(
            children: <Widget>[
              Icon(
                GZXIcons.message,
                color: Colors.black,
              ),
              Text(
                post.commentsCount.toString(),
                style: TextStyle(color: Colors.black),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPhotoWidget(PostModel post){
    return GridView.count(
      padding: const EdgeInsets.all(0),
      primary: false,
      shrinkWrap: true,
      crossAxisCount: 3,
      mainAxisSpacing: 6,
      crossAxisSpacing: 6,
      children: post.photos.map((item){
        return CachedNetworkImage(
          fadeOutDuration: Duration(milliseconds: 0),
          fadeInDuration: Duration(milliseconds: 0),
          imageUrl: item,
          fit: BoxFit.fill,
        );
      }).toList(),
    );
  }

  Widget postCard(BuildContext context,PostModel post){
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:BorderRadius.all(Radius.circular(16))
      ),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16,top: 16,right: 16,bottom:
            0),
            child: profileColumn(context, post),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16,top: 16,right: 16,bottom:
            0),
            child: Text(
              post.message,
              style: TextStyle(
                fontWeight:FontWeight.normal,
                color: Colors.black
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16,top: 16,right: 16,bottom:
            0),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.all(Radius.circular(8))
                  ),
                  child: ClipRRect(borderRadius: BorderRadius.circular(10),
                    child: _buildPhotoWidget(post),),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: actionColumn(post),
          ),
        ],
      ),
    );
  }


  Widget bottomBar() => PreferredSize(
    preferredSize: Size(double.infinity, 50),
    child: Container(
      color: Colors.black,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "All Posts",
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
              ),
              Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
    ),
  );

  Widget appBar() => SliverAppBar(
    backgroundColor: Colors.black,
    elevation: 2.0,
    centerTitle: false,
    title: Text("Feed"),
    forceElevated: true,
    pinned: true,
    floating: true,
//        snap: false,
    bottom: bottomBar(),
  );


  Widget bodyList(List<PostModel> posts) =>SliverList(
    delegate: SliverChildBuilderDelegate((context,index){
      if(index +3  == posts.length){
        _getDynamic();
      }

      return Padding(
        padding: const EdgeInsets.all(8),
        child: postCard(context, posts[index]),
      );
    },childCount: posts.length),
  );
  final postController = StreamController<List<PostModel>>();

  Stream<List<PostModel>> get postItems => postController.stream;

  List _imageCounts = [3, 6, 9];
  List _tabsTitle = ['关注', '上新', '新势力', '精选', '晒单', '时尚', '美食', '潮sir', '生活', '明星', '品牌'];
  List _topBackgroundImages = [
    '',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558082136524&di=feacbe2ef8a99d19665e04c4b72d2842&imgtype=0&src=http%3A%2F%2Fi1.17173cdn.com%2F2fhnvk%2FYWxqaGBf%2Foutcms%2FmCkIBAbjpEyscFv.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083021447&di=b4d0e0cf24df095303532b2156f995bf&imgtype=0&src=http%3A%2F%2Fp3.pstatp.com%2Flarge%2F109000019f50509ab65',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083021447&di=d7a90850b12b9fe07a4024be742c9dbc&imgtype=0&src=http%3A%2F%2Fb-ssl.duitang.com%2Fuploads%2Fitem%2F201603%2F13%2F20160313134239_5WNxA.png',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083412736&di=8fcd16ece63f60c53231e34d7d707564&imgtype=0&src=http%3A%2F%2Fs14.sinaimg.cn%2Fmw690%2F002Y7b5tgy6PyTRlDOZbd%26690',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083463426&di=7f4563d244f278746a8b52b712af1c19&imgtype=0&src=http%3A%2F%2Fs6.sinaimg.cn%2Fmiddle%2F97478a17hc9637acee3c5%26690',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083503297&di=10680297f182bdaa5c5039a0b8693626&imgtype=0&src=http%3A%2F%2Fs1.sinaimg.cn%2Fmw690%2F001LVQHHty6OK05256E70%26690',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083515575&di=d0399c0e4cce6b34e87b1ec2afdcf0e8&imgtype=0&src=http%3A%2F%2Fs6.sinaimg.cn%2Fmw690%2F00330iyazy7cdZAuidD85%26690',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b10000_10000&sec=1558073507&di=1e791bf6640d622d8dd26a0f2bba9529&src=http://s16.sinaimg.cn/mw690/4a6e5f25tx6C9p5o4i31f&690',
    'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=1611177969,3782045888&fm=26&gp=0.jpg',
    'https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1558083648898&di=ce8d7033d1b0ea161fe96ce5ff8b0dac&imgtype=0&src=http%3A%2F%2Fs4.sinaimg.cn%2Fmw600%2F002BHBRBzy6QSpE2Oxlab%26690'
  ];

  static double _topBarDefaultTop = ScreenUtil.statusBarHeight;

  double _topBarHeight = 48;
  double _topBarTop = _topBarDefaultTop;
  static double _tabControllerDefaultTop = ScreenUtil.statusBarHeight + 48;
  double _tabControllerTop = _tabControllerDefaultTop;
  double _tabBarHeight = 48;
  double _topBackgroundHeight = ScreenUtil.screenHeight / 4;
  static double _topBackgroundDefaultTop = 0;
  double _topBackgroundTop = _topBackgroundDefaultTop;
  int _selectedTabBarIndex = 0;
  TabController _tabController;

  Widget bodySliverList(){
    return StreamBuilder<List<PostModel>>(
      stream: postItems,
      builder: (context,snapshot){
        return snapshot.hasData ?
            CustomScrollView(
              slivers: <Widget>[
                bodyList(snapshot.data),
              ],
            ): Center(child: CircularProgressIndicator(),);
      },
    );
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: _tabsTitle.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _getDynamic();
  }


  void _getDynamic()async{

    List querys = await getHotSugs();
    for(var value in querys){
      PostModel postModel = PostModel(
          name: value,
//          personName: _postModels.length.toString(),
          logoImage:
          'https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2094939883,1219286755&fm=179&app=42&f=PNG?w=121&h=140',
          address: '999万粉丝',
//          message:
//              '  华为P30，是华为公司旗下一款手机。手机搭载海思Kirin 980处理器，屏幕为6.1英寸，分辨率2340*1080像素。 摄像头最大30倍数码变焦。\n  2019年3月26日晚21时，华为P30系列在法国巴黎会议中心发布。2019年4月11日，HUAWEI P30系列在上海东方体育中心正式发布。',
          message: '',
          messageImage:
          'https://gss1.bdstatic.com/9vo3dSag_xI4khGkpoWK1HF6hhy/baike/s%3D220/sign=a70945e5c51349547a1eef66664f92dd/fd039245d688d43f7e426c96731ed21b0ff43bef.jpg',
          readCout: _randomCount(),
          isLike: false,
          likesCount: _randomCount(),
          commentsCount: _randomCount(),
//          postTime: '2019-05-15 22:05:04',
//          postTime: CommonUtils.getDateStr(DateTime.parse('2019-05-15 22:05:04')),
          postTime: '${_randomCount()}粉丝',
          photos: []
//          photos: [
//            'https://res.vmallres.com/pimages/detailImg/2019/04/25/201904251619334564748.jpg',
//            'https://res.vmallres.com/pimages/detailImg/2019/04/25/201904251619332724625.jpg',
//            'https://img.alicdn.com/imgextra/i2/2838892713/O1CN01JEnTCE1Vub3R5VKEf_!!2838892713.jpg_430x430q90.jpg',
//            'https://res.vmallres.com/pimages/detailImg/2019/04/25/201904251619275641818.jpg',
//            'https://img.alicdn.com/imgextra/i1/1800399917/O1CN01axz7y82N82JEg8d5s_!!1800399917.jpg_430x430q90.jpg',
//            'https://img.alicdn.com/bao/uploaded/i1/1800399917/O1CN01jVzHTv2N82I1APvGb_!!0-item_pic.jpg_120x120.jpg',
//            'https://img.alicdn.com/bao/uploaded/i1/1800399917/O1CN01Juk4172N82JQvqM2f_!!0-item_pic.jpg_120x120.jpg',
//            'https://img.alicdn.com/bao/uploaded/i4/1800399917/O1CN01rvMy702N82Ira2AUp_!!0-item_pic.jpg_120x120.jpg',
//            'https://img.alicdn.com/bao/uploaded/i2/1800399917/O1CN01ILu0X62N82JOT6WQb_!!0-item_pic.jpg_120x120.jpg'
//          ]
      );

      _postModels.add(postModel);

      _getMessage(value.toString()).then((value){
        setState(() {
          postModel.message = value.wareName;
          postModel.logoImage = value.imageUrl;
        });
      });


      _getPhotos(value.toString()).then((value){
        setState(() {
          postModel.photos = value.map((item) => item.thumb).toList();
        });
      });
      postController.add(_postModels);

    }

  }

  Future<List<ImageModel>> _getPhotos( keyword)async{
    var data = await getGirlList(keyword);
    List images = data.map((i) => ImageModel.fromJSON(i)).toList();
    return images.take(_imageCounts[Random().nextInt(_imageCounts.length)])
        .toList();
  }

  Future<SearchResultItemModel> _getMessage(String keyword)async{
    var data = await getSearchResult(keyword,0);
    SearchResultListModel list = SearchResultListModel.fromJson(data);
    return list.data.first;
  }

  int _randomCount(){
    return Random().nextInt(1000);
  }
  void dispose(){
    postController?.close();
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    var firstTopBackgroundWidget = Container(
      decoration: BoxDecoration(
        gradient:const LinearGradient(colors: [Colors.orange,Colors.deepOrange])
      ),
      width: ScreenUtil.screenWidth,
      height: ScreenUtil.screenHeight /4,
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            left: 0,
            top: _topBackgroundTop,
            child: _topBackgroundImages[_selectedTabBarIndex].toString()
                .length == 0 ? firstTopBackgroundWidget :
                        CachedNetworkImage(
                          fadeInDuration: Duration(milliseconds: 0),
                          fadeOutDuration: Duration(milliseconds: 0),
                          placeholder: (context,url){
                            return _selectedTabBarIndex == 1 ?
                                firstTopBackgroundWidget : CachedNetworkImage(
                              fadeOutDuration: Duration(milliseconds: 0),
                              fadeInDuration: Duration(milliseconds: 0),
                              imageUrl:
                              _topBackgroundImages[_selectedTabBarIndex - 1],
                              width: ScreenUtil.screenWidth,
                              height:  ScreenUtil.screenHeight / 4,
                              fit: BoxFit.fill,
                            );
                          },
                          imageUrl: _topBackgroundImages[_selectedTabBarIndex],
                          width: ScreenUtil.screenWidth,
                          height: ScreenUtil.screenHeight / 4,
                          fit: BoxFit.fill,
                        ),
          ),

          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            left: 0,
            top: _topBarTop,
            width: ScreenUtil.screenWidth,
            child: Container(
              height: _topBarHeight,
              child: _buildTopBar(),
            ),
          ),
          AnimatedPositioned(
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            top: _tabControllerTop,
            left: 0,
            width: ScreenUtil.screenWidth,
            height: ScreenUtil.screenHeight -  (ScreenUtil.screenHeight / 4)
                / 2,
            child: Container(
              child: DefaultTabController(length: _tabsTitle.length, child:
              _buildContentWidget()),
            ),
          ),

        ],
      ),
    );
  }


  Widget _buildContentWidget(){
    return Column(
      children: <Widget>[
        Container(
          height: _tabBarHeight,
          padding: const EdgeInsets.only(top: 8,bottom: 8),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            isScrollable: true,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            labelStyle: TextStyle(fontSize: 14),
            onTap: (i){},
            tabs: _tabsTitle.map((i)=>Text(i)).toList(),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabsTitle.map((value){
              return WeiTaoListPage(
                onNotification: _onScroll,
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  _handleTabSelection() {
//    if (!_controller.indexIsChanging) {
//      return;
//    }
    print('_handleTabSelection:${_tabController.index}');
    if (_selectedTabBarIndex == _tabController.index) {
      return;
    }
//return;
    setState(() {
      _selectedTabBarIndex = _tabController.index;
    });
  }

  double _lastScrollPixels = 0;


  bool _onScroll(ScrollNotification scroll){
    if(scroll.metrics.axisDirection == AxisDirection.down){

    }else if(scroll.metrics.axisDirection == AxisDirection.up){}

    // 当前滑动距离
    double currentExtent = scroll.metrics.pixels;
    double maxExtent = scroll.metrics.maxScrollExtent;

//    print('当前滑动距离 ${currentExtent} ${currentExtent - _lastScrollPixels}');

    //向下滚动
    if (currentExtent - _lastScrollPixels > 0 && _topBarTop > 0 && currentExtent > 0) {
      print('hide');
      setState(() {
        _topBarTop = -_topBarHeight;
        _tabControllerTop = _topBarDefaultTop;
        _topBackgroundTop = -(_topBackgroundHeight - _tabBarHeight - _tabControllerTop);
      });
    }

    //向上滚动
    if (currentExtent - _lastScrollPixels < 0 && _topBarTop < 0 && currentExtent.toInt() <= 0) {
      print('show');
      setState(() {
        _topBackgroundTop = 0;
        _topBarTop = _topBarDefaultTop;
        _tabControllerTop = _tabControllerDefaultTop;
      });
    }

    _lastScrollPixels = currentExtent;

//    if (maxExtent - currentExtent > widget.startLoadMoreOffset) {
//      // 开始加载更多
//
//    }

    // 返回false，继续向上传递,返回true则不再向上传递
    return false;

  }

  Widget _buildTopBar(){
    return Row(
      children: <Widget>[
        SizedBox(
          width: 8,
        ),
        Expanded(
          child: Text(
            '微淘',
            style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,color:
            Colors.white),
          ),
        ),
        GestureDetector(
          child: Icon(
            GZXIcons.search_light,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 16,
        ),
        GestureDetector(
          child: Icon(GZXIcons.people_list_light,color: Colors.white,),
        ),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }


  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}


















