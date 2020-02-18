import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_easyrefresh/phoenix_header.dart';
import 'package:flutter_easyrefresh/phoenix_footer.dart';
import 'dart:convert';
import '../service/service_method.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  int page = 1;
  List<Map> hotGoodsList=[]; 

  bool _enableRefresh = true;
  @override
  bool get wantKeepAlive =>true;
  Widget moreData = Text('上拉加载更多');
  @override
  void initState() {
    _getHotGoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar:AppBar(title: Text('百姓生活+'),),
        body: FutureBuilder(
          future: request('homePageContext',formData:{'lon':'115.02932','lat':'35.76189'}),
          builder: (context,snapshot){
            if(snapshot.hasData){
              var data = json.decode(snapshot.data.toString());
              List<Map> swiper= (data['data']['slides'] as List).cast();
              List<Map> navigatorList= (data['data']['category'] as List).cast();
              String adPicture= data['data']['advertesPicture']['PICTURE_ADDRESS'];
              String  leaderImage= data['data']['shopInfo']['leaderImage'];  //店长图片
              String  leaderPhone = data['data']['shopInfo']['leaderPhone']; //店长电话 
              List<Map> recommendList = (data['data']['recommend'] as List).cast(); // 商品推荐
              String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];//楼层1的标题图片
              String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];//楼层2的标题图片
              String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];//楼层3的标题图片
              List<Map> floor1 = (data['data']['floor1'] as List).cast(); //楼层1商品和图片 
              List<Map> floor2 = (data['data']['floor2'] as List).cast(); //楼层1商品和图片 
              List<Map> floor3 = (data['data']['floor3'] as List).cast(); //楼层1商品和图片 


              return EasyRefresh(
                header: PhoenixHeader(),
                footer: PhoenixFooter(),
                child: ListView(
                  children: <Widget>[
                    MySwiper(swiperDataList:swiper),
                    TopNavigator(navigatorList: navigatorList),
                    AdBanner(adPicture: adPicture),
                    LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone,),
                    Recommend(recommendList: recommendList,),
                    FloorTitle(imageUrl: floor1Title,),
                    FloorContent(floorGoodsList: floor1,),
                    FloorTitle(imageUrl: floor2Title,),
                    FloorContent(floorGoodsList: floor2,),
                    FloorTitle(imageUrl: floor3Title,),
                    FloorContent(floorGoodsList: floor3,),
                    _hotGoods()
                  ],
                ),
                onRefresh: () async{
                  print('下拉刷新');
                },
                onLoad:_enableRefresh ? () async{
                  print('开始加载更多..');
                  var formPage = { 'page' : page };
                  request('homePageBelowConten',formData: formPage).then((val){
                    var data = json.decode(val.toString());
                    print(data);
                    if(data['data']!=null){
                      List<Map> newGoodsList = (data['data'] as List).cast();
                      setState(() {
                        hotGoodsList.addAll(newGoodsList);
                        page++;
                      });
                    }else{
                      setState(() {
                        _enableRefresh = false;
                        moreData = Text('没有更多数据了');
                      });
                    }
                  });
                }:null,
              );
              
                
              
              
            }else{
              return Center(
                child: Text('loading....')
              );
            }
          },
        ),
      ),
    );
  } 

  void _getHotGoods(){
    var formPage = { 'page' : page };
    request('homePageBelowConten',formData: formPage).then((val){
      var data = json.decode(val.toString());
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }


  Widget hotTitle = Container(
    margin: EdgeInsets.only(top:10.0),
    alignment: Alignment.center,
    color: Colors.transparent,
    padding: EdgeInsets.all(5.0),
    child: Text('火爆专区'),
  );

  Widget _wrapList(){
    if(hotGoodsList.length !=0){
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, "/detail?id=${val['goodsId']}");

          },
          child: Container(
            width:ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom:3.0),
            child: Column(
              children : <Widget>[
                  Image.network(val['image'],width: ScreenUtil().setWidth(375),),
                  Text(
                    val['name'],
                    maxLines: 1,
                    overflow:TextOverflow.ellipsis ,
                    style: TextStyle(color:Colors.pink,fontSize: ScreenUtil().setSp(26)),
                  ),
                  Row(
                    children: <Widget>[
                      Text('￥${val['mallPrice']}'),
                      Text(
                        '￥${val['price']}',
                        style: TextStyle(color:Colors.black26,decoration: TextDecoration.lineThrough),

                      )
                    ],
                  )
              ]
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    }else{
      return Text('暂时没有数据');
    }
  }

  Widget _hotGoods(){
    return Container(
      child: Column(
        children:<Widget>[
          hotTitle,
          _wrapList(),
          moreData
        ]
      ),
    );
  }
}

//首页轮播组件
class MySwiper extends StatelessWidget {
  final List swiperDataList;
  MySwiper({this.swiperDataList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext content, int index){
          return Image.network("${swiperDataList[index]['image']}",
            fit: BoxFit.fill,
          );
        },
        itemCount: swiperDataList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

class TopNavigator extends StatelessWidget {

  final List navigatorList;
  TopNavigator({this.navigatorList});

  Widget _gridViewItemUI(BuildContext context, item){
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'],width:ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: ScreenUtil().setHeight(320),
        padding: EdgeInsets.all(3.0),
        child: GridView.count(
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 5,
          padding: EdgeInsets.all(5.0),
          children: navigatorList.map((item){
            return _gridViewItemUI(context, item);
          }).toList()
        ),
    );
  }
}

class AdBanner extends StatelessWidget {
  final String adPicture;
  AdBanner({this.adPicture});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

class LeaderPhone  extends StatelessWidget {
  final String leaderImage; //店长图片
  final String leaderPhone; //店长电话

  LeaderPhone({this.leaderImage,this.leaderPhone});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
         onTap:_launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async{
     String url = 'tel:'+leaderPhone;
    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw '不能 $url';
    }
  }
}

//商城推荐
class Recommend extends StatelessWidget {
  final List recommendList;
  Recommend({this.recommendList});

  //标题
  Widget _titleWidget(){
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5,color: Colors.black12)
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink)
      ),
    );
  }

  //商品 item
  Widget _item(index){
    return InkWell(
      onTap: (){},
      child: Container(
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color:Colors.white,
          border:Border(
            left: BorderSide(width:0.5,color:Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                fontSize: 12,
                color:Colors.grey
              ),
            )
          ],
        ),
      ),
    );
  }
  
  //商品 list
  Widget _list(){
    return Container(
      height: ScreenUtil().setHeight(330),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context,index){
            return _item(index);
          },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(400),
      margin: EdgeInsets.only(top:10.0),
      child: Column(
        children : <Widget>[
          _titleWidget(),
          _list( )
        ]
      ),
    );
  }
}

//楼层标题
class FloorTitle extends StatelessWidget {
  final String imageUrl;
  FloorTitle({this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(imageUrl),
    );
  }
}

//楼层商品list
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  FloorContent({this.floorGoodsList});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
         children: <Widget>[
           _firstRow(),
           _otherGoods()
         ]
      ),
    );
  }

  Widget _firstRow(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(floorGoodsList[1]),
            _goodsItem(floorGoodsList[2]),
          ]
        )
      ],
    );
  }

  Widget _otherGoods(){
    return Row(
      children: <Widget>[
        _goodsItem(floorGoodsList[3]),
        _goodsItem(floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      child: InkWell(
        onTap: (){ print('点击楼层');},
        child: Image.network(goods['image'])
      ),
    );
  }
}



