import 'dart:async';

import 'package:book/data/remote/book_response.dart';
import 'package:book/data/remote/dio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'book_details.dart';
import 'more.dart';

class Home extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_Home();

}
class _Home extends State<Home> {
 final dioService _dioService=dioService();
 final ScrollController _scrollController=ScrollController();
 List<BookResponse> discoverBooks=[];
 List<BookResponse> flutterBooks=[];
 List<BookResponse> popularBooks=[];
int _currentIndex=0;
late Timer _timer;

 @override
  void initState() {
    fetchAllBooks();
    _startAutoScroll();
    super.initState();
  }

  void _startAutoScroll(){
   _timer=Timer.periodic(Duration(seconds: 3),(timer){
     if(_scrollController.hasClients){
       double nextOffset=(_currentIndex+1)*370;
       if(nextOffset>=_scrollController.position.maxScrollExtent){
         _scrollController.animateTo(0, duration: Duration(seconds: 1), curve: Curves.easeInOut);
         _currentIndex=0;
       }else{
         _scrollController.animateTo(nextOffset, duration: Duration(seconds: 1), curve: Curves.easeInOut,);
         _currentIndex++;
       }
     }
   }
   );
  }

  @override
  void dispose(){
   _timer.cancel();
   _scrollController.dispose();
   super.dispose();
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
      body:discoverBooks.isEmpty || flutterBooks.isEmpty || popularBooks.isEmpty? Center(child: Text("Loading...",style: TextStyle(
        fontSize: 30,fontWeight: FontWeight.w400
      ),)):
      SingleChildScrollView(
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
                color: Colors.blue.shade50,
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    BookResponse dBook=discoverBooks[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => BookDetails(query: dBook.title!,)));
                              },
                              child:
                              dBook.imageUrl!=null?Image.network(
                                dBook.imageUrl!,width:350,height:350,fit:BoxFit.fill ,)
                                  :Icon(Icons.book,size: 350,))
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
                color: Colors.blue.shade50,
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
                          color: Colors.blue.shade50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          fbook.imageUrl!=null?Image.network(
                            fbook.imageUrl!,width:150,height:180,fit:BoxFit.fill ,)
                              :Icon(Icons.book,size: 100,),
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
                )),
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
                color: Colors.blue.shade50,
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
                          pbook.imageUrl!=null?Image.network(pbook.imageUrl!,width:150,height:180,fit:BoxFit.fill ,):Icon(Icons.book,size: 100,),
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
    );
  }
}