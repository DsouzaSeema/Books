import 'package:book/ui/book_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../data/remote/book_response.dart';
import '../data/remote/dio_service.dart';

class More extends StatefulWidget{
  final String query;
  More({required this.query});
  @override
  State<StatefulWidget> createState()
  {
    return _MoreState(query: query);}

}

class _MoreState extends State<More>{
  final String query;
  _MoreState({required this.query});
  final dioService _dioService=dioService();
  List<BookResponse> Books=[];


  @override
  void initState() {
    fetchAllBooks();
    super.initState();
  }

  Future<void> fetchAllBooks() async{
    Books=await _dioService.fetchBooks(query);

    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More"),
        backgroundColor: Colors.blue,
      ),
      body:
      Books.isEmpty?Center(child:CircularProgressIndicator()):
      Container(
        height: double.infinity,
        width: double.infinity,
        child: GridView.builder(
          itemBuilder: (context,index){
            BookResponse books=Books[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(query:books.title!)));
                },

                  child:  Card(
                       color: Colors.blue.shade50,
                      child: Center(
                        child: Column(
                          children: [
                            books.imageUrl!=null?
                            Image.network(books.imageUrl!,height: 200,width: 200,fit: BoxFit.fill,)
                                :Center(child: Image.asset("assets/images/book.jpeg",width: 200,height: 200,fit:BoxFit.fill)),
                            SizedBox(height: 4,),
                            Text(books.title??"No title",overflow: TextOverflow.ellipsis,)
                          ],
                        ),
                      ),
                    ),
                  ),


            );
          },
          itemCount: 10,
          gridDelegate:SliverGridDelegateWithFixedCrossAxisCount
            (
              crossAxisCount: 2,
          mainAxisSpacing: 11,
          crossAxisSpacing: 11,
          childAspectRatio: 0.7
          ) ,


        ),
      )
    );

  }

}