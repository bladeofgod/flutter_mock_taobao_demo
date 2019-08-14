

import 'package:flutter_mock_taobao_demo/common/config/config.dart';
import 'package:flutter_mock_taobao_demo/common/model/Release.dart';
import 'package:flutter_mock_taobao_demo/common/services/api.dart';
import 'package:flutter_mock_taobao_demo/common/services/address.dart';
import 'package:flutter_mock_taobao_demo/common/services/api.dart';
import 'package:flutter_mock_taobao_demo/common/utils/common_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:package_info/package_info.dart';
import 'dao_result.dart';


class AppDao{

  /**
   * 获取仓库的release列表
   */


  static getRepositoryReleaseDao(userName,reposeName,page,{needHtml = true,
    release = true})async{
    String url = release ? Address.getReposRelease(userName, reposeName) + 
        Address.getPageParams("?", page)
        : Address.getReposTag(userName, reposeName) + Address.getPageParams
      ("?", page);

    var res = await httpManager.netFetch(url, null,
        {"Accept":(needHtml ? 'application/vnd.github.html,application/vnd'
            '.github.VERSION.raw' : "")}, null);
    if(res != null && res.result && res.data.length > 0){
      List<Release> list = List();
      var dataList = res.data;
      if(dataList == null || dataList.length == 0){
        return new DataResult(null, false);
      }
      for(int i = 0 ; i<dataList.length ; i++){
        var data = dataList[i];
        list.add(Release.fromJson(data));
      }
      return new DataResult(list, true);
    }else{
      return new DataResult(null, false);
    }

  }

/**
 * 版本更新
 */


  static getNewVersion(context,  showTip)async{

    var res = await getRepositoryReleaseDao("GanZhiXiong", 'GZXTaoBaoAppFlutt'
        'er', 1,needHtml: false);
    if(res != null && res.result && res.data.length > 0){
        Release release = res.data[0];
        String versionName = release.name;
        if(versionName != null){
          if(Config.DEBUG){
            print("versionname : $versionName");
          }

          PackageInfo packageInfo = await PackageInfo.fromPlatform();
          var appVersion = packageInfo.version;

          if(Config.DEBUG){
            print("app version $appVersion");
          }

          Version versionNameNum = Version.parse(versionName);
          Version currentNum = Version.parse(appVersion);
          int result = versionNameNum.compareTo(currentNum);

          if(Config.DEBUG){
            print("version name num ${versionNameNum.toString()} current num "
                "${currentNum.toString()}");
          }
          if(Config.DEBUG){
            print("news had ${result.toString()}");
          }

          if(result > 0){
            CommonUtils.showUpdateDialog(context, "v ${release.name} \n "
                "${release.body}");
          }else{
            if(showTip) Fluttertoast.showToast(msg: "当前没有新版本");
          }


        }
    }
  }


}






























