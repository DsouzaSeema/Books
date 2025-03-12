import 'package:book/ui/book_details.dart';
import 'package:book/data/remote/book_response.dart';
import 'package:book/data/local/bookmarkDao.dart';
import 'package:book/data/local/bookmark_entity.dart';
import 'package:book/data/local/database.dart';
import 'package:book/data/remote/dio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Bookmark extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_BookmarkState();

}
class _BookmarkState extends State<Bookmark>{
   List<BookmarkEntity>bookmarks=[];
   late BookmarkDao bookmarkDao;
   bool isDatabaseInitialized = false;

  @override
  void initState() {
    initializeDatabase();
    super.initState();
  }


   Future<void> initializeDatabase() async {
     final database = await $FloorBookmarkDatabase.databaseBuilder('bookmarks.db').build();
     bookmarkDao = database.bookmarkDao;
     isDatabaseInitialized = true;
     loadBookmarks();
   }
Future<void>loadBookmarks()async{
  if (!isDatabaseInitialized) return;
  final books = await bookmarkDao.getAllBookmarks();
  setState(() {
    bookmarks= books;
  });

}

Future<void>removeBookmark(String title)async{
    await bookmarkDao.deleteBook(title);
    loadBookmarks();
}
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     body: bookmarks.isEmpty?
     Center(child: Text("No bookmarks")):
     Container(
       width: double.infinity,
       height: double.infinity,
       child: GridView.builder(
           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
               crossAxisCount: 2,
           childAspectRatio: 0.66),
           itemCount: bookmarks.length,
           itemBuilder: (context,index){
             final book=bookmarks[index];
             return InkWell(
               onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(query: book.title,)));
               },
               child: Card(
                 elevation: 2,
                 child: Column(
                   children: [
                     Image.network(book.imageUrl,width: 200,height:190,fit: BoxFit.fill,),
                     SizedBox(height: 4,),
                     Text(book.title,maxLines:1,overflow: TextOverflow.ellipsis,),
                     IconButton(
                       icon: Icon(Icons.delete, color: Colors.red),
                       onPressed: () => removeBookmark(book.title),
                     ),
                   ],
                 ),
               ),
             );

           }),
     ),
   );
  }

}