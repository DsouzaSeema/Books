import 'dart:async';

import 'package:book/data/local/bookmarkDao.dart';
import 'package:floor/floor.dart';

import 'bookmark_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part '../../database.g.dart';
@Database(version:1,entities:[BookmarkEntity])
abstract class BookmarkDatabase extends FloorDatabase{
  BookmarkDao get bookmarkDao;
}

Future<BookmarkDatabase> initDatabase() async{
  final database=await $FloorBookmarkDatabase.databaseBuilder('bookmarks.db').build();
      return database;
}

