import 'package:book/ui/book_details.dart';
import 'package:book/data/remote/book_response.dart';
import 'package:book/ui/bookmark/bookmark.dart';
import 'package:book/data/remote/dio_service.dart';
import 'package:book/ui/home.dart';
import 'package:book/auth/login.dart';
import 'package:book/auth/logout.dart';
import 'package:book/ui/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController search = TextEditingController();
  List<BookResponse> searchResults=[];
  final dioService _dioService=dioService();
  final firebaseAuth=FirebaseAuth.instance;



  void updateSearchResults(String query) async{
    if(query.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;

    }
    List<BookResponse>results=await _dioService.fetchBooks(query);
    setState(() {
      searchResults=results;
    });
  }

  int _selectedIndex=0;

  final List<Widget>_pages=[Home(),Bookmark()];

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        actions: [
          SizedBox(
            width: 380,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [

                       SizedBox(
                        width: 290,

                        child: SearchBar(
                          controller: search,
                            leading: Icon(Icons.search),
                            hintText: "Search books..",

                          onChanged: (search) {
                            updateSearchResults(search);

                          },
                          onSubmitted: (search) {
                            updateSearchResults(search) ;                       },
                        ),
                      ),

                    SizedBox(width: 10,),
                    SizedBox(width: 60,
                      child: ElevatedButton(onPressed: (){
                          logout(context);
                      },
                          child: Icon(Icons.logout,semanticLabel:"LogOut"),
                      ),
                    )
                  ],

                            ),
              ),
          ),
        ],
      ),


      body:Column(
        children: [
          if(search.text.isNotEmpty)
            Expanded(child: searchBar()),
          Expanded(child:_pages[_selectedIndex] )
        ],
      )


      ,
    bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
    onTap: _onItemTapped,
    selectedItemColor: Colors.deepPurple,
    unselectedItemColor: Colors.grey,
    items: const[
      BottomNavigationBarItem(
          icon: Icon(Icons.home),label: "Home",),
      BottomNavigationBarItem(
          icon: Icon(Icons.bookmarks),label: "Bookmarks"),

    ]),
    );
  }



Widget searchBar()
{
  return ListView.builder(

        itemCount: searchResults.length,
          itemBuilder: (context,index){
          BookResponse book=searchResults[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>BookDetails(query: book.title!)));
            },
            child: ListTile(

              leading: Image.network(book.imageUrl!,width: 50,height: 60,fit: BoxFit.fill,),
              title: Text(book.title??"No title"),
              subtitle: Text(book.subtitle??"No subtitle"),
            ),
          ),
        );
      }
      );



}

  void logout(BuildContext context) async{
    await firebaseAuth.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LogOut()));

  }
}