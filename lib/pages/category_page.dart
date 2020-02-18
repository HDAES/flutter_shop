import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import '../service/service_method.dart';
import '../model/category.dart';
import '../model/categroryGoodsList.dart';
import 'dart:convert';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Row(
        children : <Widget>[
          LeftCategoryNav(),
          Column(
             children : <Widget>[
               RighrCategory(),
               GoodList()
             ]
          )
           
        ]
      ),
    );
  }

 

}

// 左侧大类导航
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];

  var listIndex=0;

  @override
  void initState() {
    _getCategory();
    _getGoodList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border:Border(
          right: BorderSide(
            width:1,
            color:Colors.black12
          )
        )
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context,index){
          return _leftInkWell(index);
        },
      ),
    );
  }


  Widget _leftInkWell(int index){
    bool isChick = false;
    isChick=(index==listIndex)?true:false;
    return InkWell(
      onTap: (){
        var childList = list[index].bxMallSubDto;
        var categoryId= list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList,categoryId);
        _getGoodList(categoryId:categoryId);
        setState(() {
          listIndex=index;
        });
      },
      child: Container(
        height:ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10,top: 20),
        decoration: BoxDecoration(
          color:isChick?Color.fromRGBO(236, 236, 236, 1.0):Colors.white,
          border:Border(
            bottom:BorderSide(
              width:1,
              color:Colors.black12,
            )
          )
        ),
        child: Text(list[index].mallCategoryName,style: TextStyle(fontSize:ScreenUtil().setSp(28)),),
      ),
    );
  }

  void _getCategory() async{
    await request('getCategory').then((val){
      var data = json.decode(val.toString());
      CategoryBigModel category = CategoryBigModel.fromJson(data);
      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto,list[0].mallCategoryId);
    });
  }

  void _getGoodList({String categoryId}) async {
    var data={
      'categoryId':categoryId==null?'2c9f6c946cd22d7b016cd74220b70040':categoryId,
      'categorySubId':"",
      'page':1
    };
    await request('getMallGoods',formData:data ).then((val){
        var  data = json.decode(val.toString());
        CategroryGoodsListModel goodsList=  CategroryGoodsListModel.fromJson(data);
        Provide.value<CategroryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }

}

//二级导航
class RighrCategory extends StatefulWidget {
  @override
  _RighrCategoryState createState() => _RighrCategoryState();
}

class _RighrCategoryState extends State<RighrCategory> {

  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context,child,childCategoryList){
        return Container(
          height:ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          padding: EdgeInsets.only(right:10),
          decoration: BoxDecoration(
            color:Colors.white,
            border:Border(
              bottom: BorderSide(width: 1,color: Colors.black12)
            )
          ),
          child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: childCategoryList.childCategoryList.length,
          itemBuilder: (context, index){
            return _rightInkWell(index,childCategoryList.childCategoryList[index]);
          }
        ) ,
        );
        }
      ); 
  }

  void _getGoodList(String categorySubId,) async {
    var data={
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':categorySubId,
      'page':1
    };
    await request('getMallGoods',formData:data ).then((val){
        var  data = json.decode(val.toString());
        CategroryGoodsListModel goodsList=  CategroryGoodsListModel.fromJson(data);
        if(goodsList.data==null){
          Provide.value<CategroryGoodsListProvide>(context).getGoodsList([]);
        }else{ 
          Provide.value<CategroryGoodsListProvide>(context).getGoodsList(goodsList.data);
        }
    });
  }


  Widget _rightInkWell(int index,BxMallSubDto item){
    bool isClick = false;
    isClick  = (index==Provide.value<ChildCategory>(context).childIndex)?true:false;
    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildIndex(index,item.mallSubId);
        if(index ==0){
          _getGoodList('');
        }else{
          _getGoodList(item.mallSubId);
        }
        
      },
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 10),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize:ScreenUtil().setSp(28),
            color:isClick?Colors.pink:Colors.black,
          )
        )
      ),
    );
  }
}

// 商品列表

class GoodList extends StatefulWidget {
  @override
  _GoodListState createState() => _GoodListState();
}

class _GoodListState extends State<GoodList> {
  
  var scrollController = new ScrollController();

  @override
  Widget build(BuildContext context) { 
    return Provide<CategroryGoodsListProvide>(
          builder: (context,child,data){
            try{
              if(Provide.value<ChildCategory>(context).page ==1){
                // 回到顶部
                scrollController.jumpTo(0.0);
              }
            }catch(e){
              print('进入页面第一次初始化：$e');
            }
            

            if(data.goodsList.length>0){
              return Expanded(
                child: Container(
                  width: ScreenUtil().setWidth(570),
                  child: EasyRefresh(
                    header: PhoenixHeader(),
                    footer: PhoenixFooter(),
                    onLoad:() async{
                      _getGoodList();
                    },
                    child: ListView.builder(
                    controller: scrollController,
                    itemCount: data.goodsList.length,
                    itemBuilder: (context,index){
                      return _goodsItem(data.goodsList,index);
                    }
                    ),
                  ),
                   
                )
              );
            }else{
              return Text('暂时没有数据');
            }
            
          }
        );
     
  }




  Widget _goodsImage(list,index){
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(list[index].image),
    );
  }

  Widget _goodsName(list,index){
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        list[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize:ScreenUtil().setSp(28)),
      ),
    );
  }

  Widget _goodsPrice(list,index){
    return Container(
      width: ScreenUtil().setWidth(370),
      margin: EdgeInsets.only(top:20),
      child: Row(
        children: <Widget>[
          Text(
            '价格 ￥${list[index].presentPrice}',
            style: TextStyle(color:Colors.pink,fontSize:ScreenUtil().setSp(30)),
          ),
          Text('￥ ${list[index].oriPrice}',
            style: TextStyle(color:Colors.black26,fontSize:ScreenUtil().setSp(24),decoration: TextDecoration.lineThrough),
          ),
        ]
      ),
    );
  }

  Widget _goodsItem(list,index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.fromLTRB(0.0, 5.0, 0, 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width:1.0,color:Colors.black12)
          )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(list,index),
            Column(
              children: <Widget>[
                _goodsName(list,index),
                _goodsPrice(list,index)
              ]
            )
          ],
        ),
      ),
    );
  }

  void _getGoodList() async {
    
    Provide.value<ChildCategory>(context).addPage();
    var data={
      'categoryId':Provide.value<ChildCategory>(context).categoryId,
      'categorySubId':Provide.value<ChildCategory>(context).subId,
      'page':Provide.value<ChildCategory>(context).page
    };
    await request('getMallGoods',formData:data ).then((val){
        var  data = json.decode(val.toString());
        CategroryGoodsListModel goodsList=  CategroryGoodsListModel.fromJson(data);
        if(goodsList.data==null){
          Fluttertoast.showToast(
            msg: '没有更多数据了',
            toastLength:Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.pink,
            textColor: Colors.white,
            fontSize:16.0
          );
          Provide.value<ChildCategory>(context).changeNoMore('没有更多数据了');
        }else{ 
          Provide.value<CategroryGoodsListProvide>(context).getMoreList(goodsList.data);
        }
    });
  }
  
}