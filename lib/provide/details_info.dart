import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier{
  DetailsModel goodsInfo;

  bool isLefe = true;
  bool isRight = false;

  //从后台获取数据
  getGooodsInfo(String id) async{

    isLefe = true;
    isRight = false;

    var formData = { 'goodId': id };
    request('getGoodDetailById',formData: formData).then((val){
      var responseData = json.decode(val.toString());
      print(responseData);
      goodsInfo = DetailsModel.fromJson(responseData);
      notifyListeners();
    });
  }

  // tabbar 切换方法
  changeLeftOrRight(String changeState){
    if(changeState=='left'){
      isLefe = true;
      isRight = false;
    }else{
       isLefe = false;
      isRight = true;
    }

    notifyListeners();
  }
}