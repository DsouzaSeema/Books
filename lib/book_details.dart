import 'package:book/data/remote/book_response.dart';
import 'package:book/data/local/bookmarkDao.dart';
import 'package:book/data/local/bookmark_entity.dart';
import 'package:book/data/local/database.dart';
import 'package:book/data/remote/dio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookDetails extends StatefulWidget{
  final String query;
  BookDetails({required this.query});
  @override
  State<StatefulWidget> createState() =>_BookDetails(query:query);

}

class _BookDetails extends State<BookDetails>{
  final String query;
  _BookDetails({required this.query});
  late BookmarkDao bookmarkDao;
  bool isBookmarked=false;
  bool isDatabaseInitialized=false;


  BookResponse bookDetails = BookResponse(title: "Loading...", imageUrl: "", subtitle: "",description: "");
  List<BookResponse> similarBooks=[];
  final dioService _dioService=dioService();

  @override
  void initState() {
    fetchBook();
initializeDatabase();
super.initState();
  }

  Future<void>initializeDatabase() async{
    final database = await $FloorBookmarkDatabase.databaseBuilder('bookmarks.db').build();
    bookmarkDao = database.bookmarkDao;
    isDatabaseInitialized = true;
    checkIfBookmarked();
  }

  Future<void> fetchBook() async {
    try {
      List<BookResponse> books = await _dioService.fetchBooks(query);

      if (books.isNotEmpty) {
        setState(() {
          bookDetails = books.first; // Assign first book to bookDetails
          similarBooks = books.skip(1).toList(); // Remaining books are similar books
        });
      } else {
        setState(() {
          bookDetails = BookResponse(
              title: "Not Found",
              imageUrl: "",
              subtitle: "",
              description: "No details available.");
        });
      }
    } catch (e) {
      setState(() {
        bookDetails = BookResponse(
            title: "Error",
            imageUrl: "",
            subtitle: "",
            description: "Failed to load book details.");
      });
      print("Error fetching book details: $e");
    }
  }

  Future<void> checkIfBookmarked()async{
    if (!isDatabaseInitialized) return;
    final existingBookmark = await bookmarkDao.isBookmarked(widget.query);
    setState(() {
      isBookmarked = existingBookmark!=null;
    });
  }

  Future<void>toggleBookmark()async{
    if (!isDatabaseInitialized) return;

    if (isBookmarked) {
      await bookmarkDao.deleteBook(widget.query);
      print("Book removed from bookmarks");
    } else {
      await bookmarkDao.insertBook(BookmarkEntity(title: widget.query, imageUrl: bookDetails.imageUrl!));
      print("Book added to bookmarks");
    }

    setState(() {
      isBookmarked = !isBookmarked;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book Details",style: TextStyle(fontSize: 21),),
        backgroundColor: Colors.blueGrey.shade100,
      ),
      body:
      similarBooks.isEmpty?Center(child: CircularProgressIndicator(),):
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Container(
                  height: 300,
                    width: 300,
                    color: Colors.grey,
                    child:bookDetails.imageUrl != null
                        ? Image.network(
                      bookDetails.imageUrl!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.fill,
                    )
                        : Icon(Icons.book),
                ),
            ),
            ),
            SizedBox(height: 11,),
            Center(child: Text(bookDetails.title??"No title",style: TextStyle(fontSize: 26,fontWeight: FontWeight.w700),)),
            SizedBox(height: 6,),
            Center(child: Text(bookDetails.subtitle??"No subtitle",style:TextStyle(fontSize: 21) ,)),
            SizedBox(height: 11,),
            Center(child: IconButton(
                iconSize:30,onPressed: (){
                  toggleBookmark();
            },
                icon: isBookmarked?Icon(Icons.bookmark):Icon(Icons.bookmark_border))),
            SizedBox(height: 11,),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text("Description",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 11,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(bookDetails.description??"No description",style: TextStyle(fontSize: 16,color: Colors.black54),)),
            ),
            SizedBox(height: 11,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text("Similar Books",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 11,),
            Container(
              height: 250,
              width: double.infinity,
              color: Colors.deepPurple.shade50,
              child:ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                  itemBuilder: (context,index){
                  BookResponse books=similarBooks[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(query: books.title!,)));
                        },
                        child: Container(
                          width: 150,
                          height: 250,
                          color: Colors.deepPurple.shade50,
                          child: Column(
                            children: [
                              Image.network(books.imageUrl!,width: 150,height:180 ,fit: BoxFit.fill,),
                              SizedBox(height: 4,),
                              Text(books.title??"No title",maxLines: 1,overflow: TextOverflow.ellipsis,),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
                SizedBox(height: 2,)
          ],
        ),
      ),
    );
  }

}