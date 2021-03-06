import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:fluro/fluro.dart';
import './pages/index_page.dart';
import './provide/counter.dart';
import './provide/child_category.dart';
import './provide/category_goods_list.dart';
import './provide/details_info.dart';
import './provide/cart.dart';
import './provide/currentIndex.dart';
import './routers/routes.dart';
import './routers/application.dart';

void main(){
  
  var counter =Counter();
  var childCategory = ChildCategory();
  var categroryGoodsList = CategroryGoodsListProvide();
  var goodsdetails = DetailsInfoProvide();
  var cartProvide = CartProvide();
  var currentIndexProvide = CurrentIndexProvide();
  var providers  =Providers();
  providers
    ..provide(Provider<Counter>.value(counter))
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<DetailsInfoProvide>.value(goodsdetails))
    ..provide(Provider<CartProvide>.value(cartProvide))
    ..provide(Provider<CurrentIndexProvide>.value(currentIndexProvide))
    ..provide(Provider<CategroryGoodsListProvide>.value(categroryGoodsList));
    
  runApp(ProviderNode(child:MyApp(),providers:providers));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final router = Router();
    Routes.configRoutes(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title:'百姓生活+',
        onGenerateRoute: Application.router.generator,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor:Colors.pink
        ),
        home:IndexPage(),
      ),
    );
  }
}