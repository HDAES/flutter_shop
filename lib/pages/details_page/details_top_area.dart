import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/details_info.dart';

class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Provide<DetailsInfoProvide>(
        builder: (context,child,val){
          var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo;
          if(goodsInfo!=null){
            return Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  _goodsImage(goodsInfo.data.goodInfo.image1),
                  _goodsName(goodsInfo.data.goodInfo.goodsName),
                  _goodsNumber(goodsInfo.data.goodInfo.amount),
                  _goodsPrice(goodsInfo.data.goodInfo.oriPrice,goodsInfo.data.goodInfo.presentPrice)
                ],
              ),
            );
          }else{
            return Text('正在加载中');
          }
          
        }
      );
  }

  // 商品图片
  Widget _goodsImage(String url){
    return Image.network(
      url,
      width: ScreenUtil().setWidth(750),
    );
  }

  // 商品名称
  Widget _goodsName(String name){
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.only(left: 15.0),
      child: Text(
        name,
        style: TextStyle(
          fontSize: ScreenUtil().setSp(30)
        ),
      ),
    );
  }
  // 商品编号
  Widget _goodsNumber(num){
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.only(top:8.0),
      child: Text(
        '编号$num',
        style: TextStyle(
          color: Colors.black12
        ),
      ),
    );
  }

  // 商品价格
  Widget _goodsPrice(oriPrice,presentPrice){
    return Container(
      width: ScreenUtil().setWidth(750),
      padding: EdgeInsets.only(left: 15.0),
      margin: EdgeInsets.fromLTRB(0.0, 8.0, 0, 10.0),
      child: Row(
        children: <Widget>[
          Container(
            child: Text(
              '￥$presentPrice',
              style: TextStyle(
                color: Colors.pink,
                fontSize: ScreenUtil().setSp(30)
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              '市场价￥$oriPrice',
              style: TextStyle(
                color: Colors.black38,
                fontSize: ScreenUtil().setSp(25),
                decoration:TextDecoration.lineThrough
              ),
            ),
          ),
        ],
      ),
    );
  }
}