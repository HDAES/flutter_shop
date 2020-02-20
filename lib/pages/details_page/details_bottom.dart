import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../../provide/cart.dart';
import '../../provide/details_info.dart';
import '../../provide/currentIndex.dart';

class DetailsBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context,child,val){
        var goodsId = val.goodsInfo.data.goodInfo.goodsId;
        var goodsName = val.goodsInfo.data.goodInfo.goodsName;
        var count = 1;
        var price = val.goodsInfo.data.goodInfo.presentPrice;
        var images = val.goodsInfo.data.goodInfo.image1;
        print('>>>>>>>$val>>>>>>>>>>');
          return  Container(
            width: ScreenUtil().setWidth(750),
            height: ScreenUtil().setHeight(100),
            color: Colors.white,
            child: Row(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    InkWell(
                      onTap: (){
                        Provide.value<CurrentIndexProvide>(context).changeIndex(2);
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: ScreenUtil().setWidth(110),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.shopping_cart,
                          size: 35,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    Provide<CartProvide>(
                      builder: (context,child,val){
                        int goodsCount = Provide.value<CartProvide>(context).allGoodsCount;
                        return Positioned(
                          top: 0,
                          right: 10,
                          child: Container(
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              border: Border.all(width: 2,color: Colors.white),
                              borderRadius: BorderRadius.circular(12.0)
                            ),
                            child: Text(
                              '$goodsCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(22)
                              ),
                            ),
                          ),
                          
                        );
                      }
                    )
                  ],
                ),
                InkWell(
                  onTap: () async{
                    await Provide.value<CartProvide>(context).save(goodsId, goodsName, count, price, images);
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(320),
                    height: ScreenUtil().setHeight(100),
                    alignment: Alignment.center,
                    color: Colors.green,
                    child: Text(
                      '加入购物车',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(28)
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async{
                    await Provide.value<CartProvide>(context).remove();
                  },
                  child: Container(
                    width: ScreenUtil().setWidth(320),
                    height: ScreenUtil().setHeight(100),
                    alignment: Alignment.center,
                    color: Colors.red,
                    child: Text(
                      '立即购买',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: ScreenUtil().setSp(28)
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        }
      
      );
    
    
  }
}