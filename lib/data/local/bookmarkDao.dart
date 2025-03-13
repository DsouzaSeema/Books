import 'package:book/data/local/bookmark_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class BookmarkDao {
  @Query('SELECT * FROM BookmarkEntity WHERE userId=:userId')
  Future<List<BookmarkEntity>> getAllBookmarks(String userId);

  @Query('SELECT * FROM BookmarkEntity WHERE title=:title LIMIT 1')
  Future<BookmarkEntity?> isBookmarked(String title);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertBook(BookmarkEntity book);

  @Query('DELETE FROM BookmarkEntity WHERE title=:title AND userId=:userId')
  Future<void> deleteBook(String title,String userId);

  @Query('DELETE FROM BookmarkEntity')
  Future<void> clearAllBooks();


}