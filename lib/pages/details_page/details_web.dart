import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   
    return Provide<DetailsInfoProvide>(
      builder: (context,child,val){
        var isLefe = Provide.value<DetailsInfoProvide>(context).isLefe;
        var goodsDetaisl = Provide.value<DetailsInfoProvide>(context).goodsInfo;
        if(isLefe&&goodsDetaisl!=null){
          return Container(
            child: Html(
              data: goodsDetaisl.data.goodInfo.goodsDetail
            ),
          );
        }else{
          return Text('暂时没有数据');
        }
      
        
      }
    );
    
    
  }
}