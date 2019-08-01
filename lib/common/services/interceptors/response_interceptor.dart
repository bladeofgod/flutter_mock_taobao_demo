import 'package:dio/dio.dart';

import '../code.dart';
import '../result_data.dart';

/**
 * Token拦截器
 */

class ResponseInterceptors extends InterceptorsWrapper{


  @override
  onResponse(Response response) {
    // TODO: implement onResponse
    RequestOptions options = response.request;

    try{
      if(options.contentType != null && options.contentType.primaryType == "t"
          "ext"){
        return new ResultData(response.data, true, Code.SUCCESS);
      }
      if(response.statusCode == 200 || response.statusCode == 201){
        return new ResultData(response.data, true, Code.SUCCESS,headers:
        response.headers);
      }
    }catch(e){
      print(e.toString() + options.path);
      return new ResultData(response.data, false, response.statusCode,
          headers: response.headers);
    }
  }

}












