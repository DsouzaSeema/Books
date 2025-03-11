import 'package:book/data/local/bookmark_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class BookmarkDao{
  @Query('SELECT * FROM BookmarkEntity ')
  Future<List<BookmarkEntity>> getAllBookmarks();
  
  @Query('SELECT * FROM BookmarkEntity WHERE title=:title LIMIT 1')
  Future<BookmarkEntity?> isBookmarked(String title);

  @insert
  Future<void> insertBook(BookmarkEntity book);

  @Query('DELETE FROM BookmarkEntity WHERE title=:title')
  Future<void> deleteBook(String title);
}