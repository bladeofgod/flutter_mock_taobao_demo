import 'package:flutter/material.dart';
import 'package:flutter_mock_taobao_demo/common/style/gzx_style.dart';
import 'package:flutter_mock_taobao_demo/common/utils/screen_util.dart';


class GZXBottomNavigationBar extends StatefulWidget{

  static final String sName = "home";


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GZXBottomNavigationBarState();
  }


}

class GZXBottomNavigationBarState extends State<GZXBottomNavigationBar> {

  final PageController topPageController = PageController();
  Color foreColor = GZXColors.tabBarDefaultForeColor;

  List tabItemForeColor = List();

  final _bottomNavigationColor =Color(0xFF585858);

  Color _bottomNavigationActiveColor = Colors.blueAccent;

  int _currentIndex = 0;
  var _controller = PageController(initialPage: 0,);


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _bottomNavigationActiveColor = Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 360)..init(context);
    // TODO: implement build
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: <Widget>[
          HomePage(),
          WeiTaoPage(),
          MessagePage(),
          ShoppingCarPage(),
          MyPage(),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index){
          _controller.jumpToPage(index);
          setState(() {
            _currentIndex =  index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              GZXIcons.home,
              color: _currentIndex == 0 ? _bottomNavigationActiveColor : _bottomNavigationColor,
            ),
            activeIcon:Icon(
              GZXIcons.home_active,
              color: _currentIndex == 0 ? _bottomNavigationActiveColor : _bottomNavigationColor,
            ),
            title:_currentIndex ==0 ? Container: _buildBarItemTitle('首页',0),
          ),
          BottomNavigationBarItem(
              icon: Icon(
                GZXIcons.we_tao,
//                Icons.message,
                color: _currentIndex == 1 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              activeIcon: Icon(
                GZXIcons.we_tao_fill,
                color: _currentIndex == 1 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              title: _buildBarItemTitle('微淘', 1)),
          BottomNavigationBarItem(
              icon: Icon(
                GZXIcons.message,
//                Icons.message,
                color: _currentIndex == 2 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              activeIcon: Icon(
                GZXIcons.message_fill,
                color: _currentIndex == 2 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              title: _buildBarItemTitle('消息', 2)),
          BottomNavigationBarItem(
              icon: Icon(
                GZXIcons.cart,
//                Icons.message,
                color: _currentIndex == 3 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              activeIcon: Icon(
                GZXIcons.cart_fill,
                color: _currentIndex == 3 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              title: _buildBarItemTitle('购物车', 3)),
          BottomNavigationBarItem(
              icon: Icon(
                GZXIcons.my,
//                Icons.message,
                color: _currentIndex == 4 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              activeIcon: Icon(
                GZXIcons.my_fill,
                color: _currentIndex == 4 ? _bottomNavigationActiveColor : _bottomNavigationColor,
              ),
              title: _buildBarItemTitle('我的淘宝', 4)),
        ],
      ),
    );
  }

  Widget _buildBarItemTitle(String title,int index){
    return Text(
      title,
      style: TextStyle(color: _currentIndex == index ?
      _bottomNavigationActiveColor : _bottomNavigationColor),
    );
  }











}

















