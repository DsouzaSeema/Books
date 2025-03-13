import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/local/bookmarkDao.dart';
import '../data/local/bookmark_entity.dart';

class BookmarkRepository {
  final BookmarkDao bookmarkDao;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  BookmarkRepository(this.bookmarkDao);

  // Sync Firebase bookmarks to Floor on login
  Future<void> syncBookmarksFromFirebase() async {
    final user = auth.currentUser;
    if (user == null) return;

    final snapshot = await firestore.collection('bookmarks').doc(user.uid).collection('userBookmarks').get();

    List<BookmarkEntity> bookmarks = snapshot.docs.map((doc) {
      return BookmarkEntity(title: doc['title'], imageUrl: doc['imageUrl'], userId: user.uid);
    }).toList();

    for (var bookmark in bookmarks) {
      await bookmarkDao.insertBook(bookmark);
    }
  }

  // Add a bookmark to Firebase
  Future<void> addBookmarkToFirebase(BookmarkEntity book) async {
    final user = auth.currentUser;
    if (user == null) return;

    await firestore.collection('bookmarks').doc(user.uid).collection('userBookmarks').doc(book.title).set({
      'title': book.title,
      'imageUrl': book.imageUrl,
    });

    await bookmarkDao.insertBook(book);
  }

  // Remove a bookmark from Firebase
  Future<void> removeBookmarkFromFirebase(String title) async {
    final user = auth.currentUser;
    if (user == null) return;

    await firestore.collection('bookmarks').doc(user.uid).collection('userBookmarks').doc(title).delete();

    await bookmarkDao.deleteBook(title, user.uid);
  }

  // Clear local bookmarks on logout
  Future<void> clearLocalBookmarks() async {
    await bookmarkDao.clearAllBooks();
  }
}
