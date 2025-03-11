
import 'package:floor/floor.dart';

@entity
class BookmarkEntity{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String title, imageUrl;

  BookmarkEntity({this.id,required this.title,required this.imageUrl});
}