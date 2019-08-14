

import 'package:flutter/material.dart';
import 'package:flutter_mock_taobao_demo/common/model/tab.dart';


class GZXTabBarWidget extends StatefulWidget implements PreferredSizeWidget{

  final List<TabModel> tabModels;
  final TabController tabController;
  final int currentIndex;
  const GZXTabBarWidget({Key key,this.tabModels,this.tabController,this
      .currentIndex}):super(key : key);


  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return GZXTabBarWidgetState();
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(30);

}

class GZXTabBarWidgetState extends State<GZXTabBarWidget> {

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: widget.tabController,
        indicatorColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        isScrollable: true,
        labelColor: Color(0xFFfe5100),
        unselectedLabelColor: Colors.black,
        labelPadding: EdgeInsets.only(right: 5.0,left: 5.0),
        onTap: (i){
          _selectedIndex = i;
        },
        tabs: widget.tabModels.map((i){
          return Container(
            padding: const EdgeInsets.all(0),
            height:  44.0,
            child: new Tab(child: Row(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    SizedBox(
                      height: 3,
                    ),
                    Text(i.title),
                    SizedBox(
                      height: 3,
                    ),
                    widget.tabModels.indexOf(i) == widget.currentIndex ?
                        ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            color: Color(0xFFfe5100),
                            child: Text(
                              i.subtitle,style: TextStyle(fontSize: 9,color:
                            Colors.white),
                            ),
                          ),
                        ) : Expanded(
                      child: Text(i.subtitle,style: TextStyle(fontSize: 9,color: Color(0xFFb5b6b5)),),
                    )
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: 1,
                  height: 30,
                  color: Color(0xFFc9c9ca),
                ),
              ],
            ),),
          );
        }).toList(),
      ),
    );
  }
}



















