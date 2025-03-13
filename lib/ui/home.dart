import 'dart:async';

import 'package:book/data/remote/book_response.dart';
import 'package:book/data/remote/dio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'book_details.dart';
import 'more.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_Home();
}

class _Home extends State<Home> {
 final dioService _dioService=dioService();

 List<BookResponse> discoverBooks=[];
 List<BookResponse> flutterBooks=[];
 List<BookResponse> popularBooks=[];
 int _currentIndex=0;


 @override
  void initState() {
    fetchAllBooks();
    super.initState();
  }


  Future<void> fetchAllBooks() async{
   discoverBooks=await _dioService.fetchBooks("best seller");
   flutterBooks=await _dioService.fetchBooks("flutter programming");
   popularBooks=await _dioService.fetchBooks("popular books");
   setState(() {

   });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:discoverBooks.isEmpty || flutterBooks.isEmpty || popularBooks.isEmpty?
      Center(child:Lottie.asset('assets/lottie/Animation_loading.json',height: 100,width: 100)):
      Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.blueGrey.shade50,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 11),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Discover",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
              ),
              SizedBox(height: 11),
              Center(
                child: Container(
                  width: 350,
                  height: 350,
                  color: Colors.blueGrey.shade100,
                  child: CarouselSlider.builder(
                    itemCount: 10,
                    itemBuilder: (context, index,realIndex) {
                      BookResponse dBook=discoverBooks[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (context) => BookDetails(query: dBook.title!,)
                                  )
                                  );
                                },
                                child:
                                dBook.imageUrl!=null?Image.network(
                                  dBook.imageUrl!,width:350,height:350,fit:BoxFit.fill ,)
                                    :Image.asset("assets/images/book.jpeg",width:350,height:350,fit:BoxFit.fill))
                            ),

                      );
                    }, options: CarouselOptions(
                    height: 350,
                    viewportFraction: 0.9,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 4),
                    autoPlayAnimationDuration: Duration(milliseconds: 900),
                    enlargeCenterPage: true,
                    onPageChanged: (index,reason){
                      setState(() {
                        _currentIndex=index;
                      });
                    },
                    autoPlayCurve: Curves.easeInOut,
                    enableInfiniteScroll: true,
                    aspectRatio: 16/9


                  ),
                  ),
                ),
              ),
              SizedBox(height: 11),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => More(query: "best seller",)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 300),
                    child: Text("more",
                        style: TextStyle(fontSize: 20, color: Colors.deepPurple)),
                  )),
              SizedBox(height: 11,),


              //FLUTTER
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Flutter",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 11),
              Center(
                child: Container(
                  color: Colors.blueGrey.shade100,
                  height: 250,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      BookResponse fbook=flutterBooks[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => BookDetails(query: fbook.title!,)));
                          },
                          child: Container(
                            width: 150,
                            height: 70,
                            color: Colors.blueGrey.shade100,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            fbook.imageUrl!=null?Image.network(
                              fbook.imageUrl!,width:150,height:180,fit:BoxFit.fill ,)
                                :Image.asset("assets/images/book.jpeg",width:150,height: 180,fit: BoxFit.fill ,),
                                SizedBox(height: 4,),
                                Text(fbook.title??"No title",maxLines: 1,overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 11),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => More(query: "flutter programming",)));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 300),
                    child: Text("more",
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple),),
                  )
              ),
              SizedBox(height: 11,),


              //POPULAR
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text("Popular",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 11),
              Center(
                child: Container(
                  color: Colors.blueGrey.shade100,
                  height: 250,
                  width: double.infinity,
                  child: ListView.builder(
                    itemCount: 10,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      BookResponse pbook=popularBooks[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => BookDetails(query: pbook.title!,)));
                          },
                          child: Container(
                            width: 150,
                            height: 70,
                            color: Colors.blue.shade50,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                            pbook.imageUrl!=null?Image.network(pbook.imageUrl!,width:150,height:180,fit:BoxFit.fill ,):Image.asset("assets/images/book.jpeg",width:150,height: 180,fit: BoxFit.fill ,),
                                SizedBox(height: 4,),
                                Text(pbook.title??"No title",maxLines: 1,overflow: TextOverflow.ellipsis,),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              InkWell(
                  onTap: () {
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => More(query: "popular books")));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 300),
                    child: Text("more",
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple),),
                  )),
              SizedBox(height: 11,),
            ],
          ),
        ),
      ),
    );
  }
}