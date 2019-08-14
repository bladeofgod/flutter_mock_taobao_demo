class SearchResultItemModel{


  String shopName;
  String wareName;
  String price;
  String coupon;
  String imageUrl;
  String commentcount;
  String good; //好评率
  String shopId;
  String disCount;

  SearchResultItemModel(
      {this.shopId,
        this.shopName,
        this.commentcount,
        this.coupon,
        this.price,
        this.good,
        this.disCount,
        this.imageUrl,
        this.wareName});


  factory SearchResultItemModel.fromJson(dynamic json){
    String picurl = 'http://img10.360buyimg.com/mobilecms/s270x270_' + json['Content']['imageurl'];
    String coupon;
    if(json['coupon'] != null){
      if(json['coupon']['m'] != '0'){
        coupon = "满${json['coupon']['m']}减${json['coupon']['j']}";
      }
    }
    String disCount;
    if(json['pfdt']!=null){
      if(json['pfdt']['m'] != ''){
        disCount = '${json['pfdt']['m']}件${json['pfdt']['j']}折';
      }
    }

    return SearchResultItemModel(
      shopId:json['shop_id'],
      shopName:json['shop_name'],
      imageUrl:picurl,
      good:json['good'],
      commentcount:json['commentcount'],
      price: json['dredisprice'],
      coupon: coupon,
      disCount: disCount,
      wareName:json['Content']['wareName']
    );


  }

}

class SearchResultListModel{
  List<SearchResultItemModel> data;
  SearchResultListModel(this.data);
  factory SearchResultListModel.fromJson(List json){
    return SearchResultListModel(json.map((i)=>SearchResultItemModel.fromJson
      (i)).toList());
  }
}

















