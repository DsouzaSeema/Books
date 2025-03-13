import 'package:book/ui/book_details.dart';
import 'package:book/data/remote/book_response.dart';
import 'package:book/data/local/bookmarkDao.dart';
import 'package:book/data/local/bookmark_entity.dart';
import 'package:book/data/local/database.dart';
import 'package:book/data/remote/dio_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../util/bookmark_repository.dart';

class Bookmark extends StatefulWidget{
  @override
  State<StatefulWidget> createState() =>_BookmarkState();

}
//
// class _BookmarkState extends State<Bookmark>{
//   List<BookmarkEntity>bookmarks=[];
//   late BookmarkDao bookmarkDao;
//   bool isDatabaseInitialized = false;
//
//   @override
//   void initState() {
//     initializeDatabase();
//     super.initState();
//   }
//
//
//   Future<void> initializeDatabase() async {
//     final database = await $FloorBookmarkDatabase.databaseBuilder('bookmarks.db').build();
//     bookmarkDao = database.bookmarkDao;
//     isDatabaseInitialized = true;
//     loadBookmarks();
//   }
//   Future<void>loadBookmarks()async{
//     if (!isDatabaseInitialized) return;
//     final books = await bookmarkDao.getAllBookmarks();
//     setState(() {
//       bookmarks= books;
//     });
//
//   }
//
//   Future<void>removeBookmark(String title)async{
//     await bookmarkDao.deleteBook(title);
//     loadBookmarks();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: bookmarks.isEmpty?
//       Center(child: Text("No bookmarks")):
//       Container(
//         width: double.infinity,
//         height: double.infinity,
//         color: Colors.blueGrey.shade50,
//         child: GridView.builder(
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 childAspectRatio: 0.66),
//             itemCount: bookmarks.length,
//             itemBuilder: (context,index){
//               final book=bookmarks[index];
//               return InkWell(
//                 onTap: (){
//                   Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(query: book.title,)));
//                 },
//                 child: Card(
//                   color: Colors.blueGrey.shade100,
//                   elevation: 2,
//                   child: Column(
//                     children: [
//                       Image.network(book.imageUrl,width: 200,height:190,fit: BoxFit.fill,),
//                       SizedBox(height: 4,),
//                       Text(book.title,maxLines:1,overflow: TextOverflow.ellipsis,),
//                       IconButton(
//                         icon: Icon(Icons.delete, color: Colors.red.shade400),
//                         onPressed: () => removeBookmark(book.title),
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//
//             }),
//       ),
//     );
//   }
//
//}

class _BookmarkState extends State<Bookmark> {
  List<BookmarkEntity> bookmarks = [];
  late BookmarkDao bookmarkDao;
  late BookmarkRepository bookmarkRepository;
  bool isDatabaseInitialized = false;
  String? userId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    initializeDatabase();
    super.initState();
  }

  Future<void> initializeDatabase() async {
    final database = await $FloorBookmarkDatabase.databaseBuilder('bookmarks.db').build();
    bookmarkDao = database.bookmarkDao;
    bookmarkRepository = BookmarkRepository(bookmarkDao);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userId = user.uid;
      await bookmarkRepository.syncBookmarksFromFirebase();
    }

    isDatabaseInitialized = true;
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
      if (!isDatabaseInitialized || userId == null) return;

      await bookmarkDao.clearAllBooks();

      final snapshot = await firestore
          .collection('bookmarks')
          .doc(userId)
          .collection('userBookmarks')
          .get();

      List<BookmarkEntity> fetchedBookmarks = snapshot.docs.map((doc) {
        return BookmarkEntity(
          title: doc['title'],
          imageUrl: doc['imageUrl'],
          userId: userId!,
        );
      }).toList();

      for (var bookmark in fetchedBookmarks) {
        await bookmarkDao.insertBook(bookmark);
      }

      final books = await bookmarkDao.getAllBookmarks(userId!);
      setState(() {
        bookmarks = books;
      });
    }



  Future<void> removeBookmark(String title) async {
    await bookmarkRepository.removeBookmarkFromFirebase(title);
    loadBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bookmarks.isEmpty
          ? Center(child: Text("No bookmarks"))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.66),
        itemCount: bookmarks.length,
        itemBuilder: (context, index) {
          final book = bookmarks[index];
          return InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetails(query: book.title)));
            },
            child: Card(
              color: Colors.blueGrey.shade100,
              elevation: 2,
              child: Column(
                children: [
                  Image.network(book.imageUrl, width: 200, height: 190, fit: BoxFit.fill),
                  SizedBox(height: 4),
                  Text(book.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade400),
                    onPressed: () => removeBookmark(book.title),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
