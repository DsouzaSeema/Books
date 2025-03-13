// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $BookmarkDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $BookmarkDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $BookmarkDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<BookmarkDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorBookmarkDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BookmarkDatabaseBuilderContract databaseBuilder(String name) =>
      _$BookmarkDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $BookmarkDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$BookmarkDatabaseBuilder(null);
}

class _$BookmarkDatabaseBuilder implements $BookmarkDatabaseBuilderContract {
  _$BookmarkDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $BookmarkDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $BookmarkDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<BookmarkDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$BookmarkDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$BookmarkDatabase extends BookmarkDatabase {
  _$BookmarkDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  BookmarkDao? _bookmarkDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `BookmarkEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `title` TEXT NOT NULL, `imageUrl` TEXT NOT NULL, `userId` TEXT)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  BookmarkDao get bookmarkDao {
    return _bookmarkDaoInstance ??= _$BookmarkDao(database, changeListener);
  }
}

class _$BookmarkDao extends BookmarkDao {
  _$BookmarkDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _bookmarkEntityInsertionAdapter = InsertionAdapter(
            database,
            'BookmarkEntity',
            (BookmarkEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'imageUrl': item.imageUrl,
                  'userId': item.userId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<BookmarkEntity> _bookmarkEntityInsertionAdapter;

  @override
  Future<List<BookmarkEntity>> getAllBookmarks(String userId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM BookmarkEntity WHERE userId=?1',
        mapper: (Map<String, Object?> row) => BookmarkEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            imageUrl: row['imageUrl'] as String,
            userId: row['userId'] as String?),
        arguments: [userId]);
  }

  @override
  Future<BookmarkEntity?> isBookmarked(String title) async {
    return _queryAdapter.query(
        'SELECT * FROM BookmarkEntity WHERE title=?1 LIMIT 1',
        mapper: (Map<String, Object?> row) => BookmarkEntity(
            id: row['id'] as int?,
            title: row['title'] as String,
            imageUrl: row['imageUrl'] as String,
            userId: row['userId'] as String?),
        arguments: [title]);
  }

  @override
  Future<void> deleteBook(
    String title,
    String userId,
  ) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM BookmarkEntity WHERE title=?1 AND userId=?2',
        arguments: [title, userId]);
  }

  @override
  Future<void> clearAllBooks() async {
    await _queryAdapter.queryNoReturn('DELETE FROM BookmarkEntity');
  }

  @override
  Future<void> insertBook(BookmarkEntity book) async {
    await _bookmarkEntityInsertionAdapter.insert(
        book, OnConflictStrategy.abort);
  }
}
