import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> list = [];
  List<dynamic> listAds = [];
  List<Widget> ListItems=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    getAds();
  }
  Future<void> getAds() async {
    final response =
    await http.get(Uri.parse('http://localhost:80/myapplication/getads.php'));
    if (response.statusCode == 200) {
      listAds = jsonDecode(response.body);
      setState(() {});
      for(int i=0;i<listAds.length;i++)
      {
        String image=listAds[i]['image'];
        debugPrint('$listAds');
        ListItems.add(
            Container(
              margin: EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage("http://localhost:80/myapplication/images/$image"),
                  fit: BoxFit.cover,
                ),
              ),
            )
        );
      }
    }
  }
  Future<void> getData() async {
    final response =
    await http.get(Uri.parse('http://localhost:80/myapplication/getposts.php'));
    if (response.statusCode == 200) {
      list = jsonDecode(response.body);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('hiiiiiiiii'),
        ),
        body: Column(
          children: [
            Expanded(
              child: CarouselSlider(
                items: ListItems,

                //Slider Container properties
                options: CarouselOptions(
                  height: 180.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    return Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.red,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${list[i]['usename']}'),
                          Text('${list[i]['text']}'),
                          Image.network(
                              "http://localhost:80/myapplication/images/${list[i]['image']}"),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ));
  }
}