import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = [];
  int childIndex = 0; //子类高亮索引
  String categoryId = '2c9f6c946cd22d7b016cd74220b70040'; //大类ID
  String subId = ''; // 之类ID
  int page = 1; //列表页数
  String noMoreText = ''; // 显示没有数据

  getChildCategory(List<BxMallSubDto> list ,String id){
    //清空
    childIndex = 0;
    page = 1;
    noMoreText ='';
    categoryId = id;


    BxMallSubDto all=BxMallSubDto();
    all.mallSubId = '00';
    all.mallCategoryId = '00';
    all.mallSubName = '全部';
    all.comments = 'null';

    childCategoryList = [all];

    childCategoryList.addAll(list);
    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex(index,String id){
    page = 1;
    noMoreText ='';
    subId = id;
    childIndex = index;
    notifyListeners();
  }

  //增加page 的方法
  addPage(){
    page++;
  }

  changeNoMore(String text){
    noMoreText = text;
    notifyListeners();
  }
}