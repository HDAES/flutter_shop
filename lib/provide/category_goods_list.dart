import 'package:flutter/material.dart';
import '../model/categroryGoodsList.dart';

class CategroryGoodsListProvide  with ChangeNotifier{
  List<CategroryListData> goodsList  = [];

  //点击大类更换商品列表
  getGoodsList(List<CategroryListData> list){
    goodsList = list ;
    notifyListeners();
  }

  getMoreList(List<CategroryListData> list){
    goodsList.addAll(list) ;
    notifyListeners();
  }
}


