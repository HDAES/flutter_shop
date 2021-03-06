import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/cartInfo.dart';
import 'dart:convert';

class CartProvide with ChangeNotifier{

  String cartString = '[]';
  List<CartInfoModel> cartList = [];
  double allPrice = 0;//总价格
  int allGoodsCount = 0;//商品总数量

  bool isAllCheck = true; //是否全选中


  save(goodsId,goodsName,count,price,images) async {
    print('添加的ID：>>>>>>$goodsId');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    var temp = cartString ==null?[]:json.decode(cartString.toString());
    List<Map> tempList = (temp as List).cast();
    bool isHave = false;
    int ival =0;
    allGoodsCount=0;
    allPrice = 0;
    tempList.forEach((item){
      if(item['goodsId'] == goodsId){
        tempList[ival]['count'] = item['count']+1;
        cartList[ival].count++;
        isHave = true;
      }
      if(item['isCheck']){
        allPrice +=(cartList[ival].price*cartList[ival].count);
        allGoodsCount+=cartList[ival].count;
      }
      ival++;
    });

    if(!isHave){
      Map<String, dynamic> newGoods = {
        'goodsId':goodsId,
        'goodsName':goodsName,
        'count':count,
        'price':price,
        'images':images,
        'isCheck':true,
      };
      tempList.add(newGoods);
      cartList.add(CartInfoModel.fromJson(newGoods));
      
      allPrice += count*price;
      allGoodsCount+=count;
    }

    cartString = json.encode(tempList).toString();
    print('字符串 >>>>>$cartString');
    print('数据模型 >>>>$cartList');


    prefs.setString('cartInfo', cartString);
    
    notifyListeners();
  }

  remove() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();  
    prefs.remove('cartInfo');
    cartList = [];
    print('清空完成>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
    notifyListeners();
  }

  getCartInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance(); 
    cartString = prefs.getString('cartInfo');
    cartList = [];
    if(cartString==null){
      cartList = [];
    }else{
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck = true;
      tempList.forEach((item){
        cartList.add(CartInfoModel.fromJson(item));
        if(item['isCheck']){
          allPrice += item['count'] * item['price'];
          allGoodsCount +=item['count'];
        }else{
          isAllCheck=false;
        }
      });
      notifyListeners();
    }
  }

  //删除单个购物车商品
  deleteOneGoods(String goodsId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');

    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex=0;
    int delIndex=0;

    tempList.forEach((item){
      if(item['goodsId']==goodsId){
        delIndex=tempIndex;
      }
      tempIndex++;
    });

    tempList.removeAt(delIndex);

    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);

    await getCartInfo();

  }

  changeCheckState(CartInfoModel cartItem) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');

    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex=0;
    int chanegIndex=0;

    tempList.forEach((item){
      if(item['goodsId']==cartItem.goodsId){
        chanegIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList[chanegIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  //点击全选操作
  changeAllCheckBtnState(bool isCheck) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');

    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList=[];
    for(var item in tempList){
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }

    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  //商品数量加减
  addOrReduceAction(CartInfoModel cartItem,String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex=0;
    int chanegIndex=0;

    tempList.forEach((item){
      if(item['goodsId']==cartItem.goodsId){
        chanegIndex = tempIndex;
      }
      tempIndex++;
    });

    if(todo == 'add'){
      cartItem.count++;
    }else if(cartItem.count>1){
      cartItem.count--;
    }

    tempList[chanegIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();

  }
}