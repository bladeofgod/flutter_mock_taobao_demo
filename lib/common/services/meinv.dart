import 'package:http/http.dart' as http;
import 'dart:convert';



Future<List> getGirlList(String key)async{
  String url = 'https://m.image.so.com/j?src=imageonebox&q=$key&obx_type=360pic_meinv&pn=9&sn=0&kn=0&gn=0&cn=0';
  var res = await http.get(url);
  if(res.statusCode == 200){
    List items = jsonDecode(res.body)['list'] as List;
    return items;
  }else{
    return [];
  }
}