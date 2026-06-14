import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalBookDB {
  LocalBookDB._();
  static final LocalBookDB instance = LocalBookDB._();

  static Database? _database;
  final List<Map<String, dynamic>> _webCache = [];
  final List<Map<String, dynamic>> _myWebCache = [];

  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database!;
    _database = await _initDB('ruangbuku.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE books (
  id TEXT PRIMARY KEY,
  isbn TEXT,
  title TEXT NOT NULL,
  author TEXT,
  description TEXT,
  isPublic INTEGER NOT NULL,
  statusVerifikasi TEXT,
  ownerId TEXT,
  ownerName TEXT,
  imageUrl TEXT,
  distance TEXT,
  condition TEXT
)
''');

    await db.execute('''
CREATE TABLE my_books (
  id TEXT PRIMARY KEY,
  isbn TEXT,
  title TEXT NOT NULL,
  author TEXT,
  description TEXT,
  isPublic INTEGER NOT NULL,
  statusVerifikasi TEXT,
  ownerId TEXT,
  ownerName TEXT,
  imageUrl TEXT,
  distance TEXT,
  condition TEXT
)
''');
  }

  Future<void> _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
CREATE TABLE my_books (
  id TEXT PRIMARY KEY,
  isbn TEXT,
  title TEXT NOT NULL,
  author TEXT,
  description TEXT,
  isPublic INTEGER NOT NULL,
  statusVerifikasi TEXT,
  ownerId TEXT,
  ownerName TEXT,
  imageUrl TEXT,
  distance TEXT,
  condition TEXT
)
''');
    }
  }

  Future<void> insertBook(Map<String, dynamic> book) async {
    if (kIsWeb) {
      _webCache.removeWhere((b) => b['id'] == book['id']);
      _webCache.add(book);
      return;
    }
    final db = await database;
    if (db != null) {
      await db.insert(
        'books',
        book,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> clearBooks() async {
    if (kIsWeb) {
      _webCache.clear();
      return;
    }
    final db = await database;
    if (db != null) {
      await db.delete('books');
    }
  }

  Future<List<Map<String, dynamic>>> getAllBooks() async {
    if (kIsWeb) {
      return List<Map<String, dynamic>>.from(_webCache);
    }
    final db = await database;
    if (db != null) {
      return db.query('books');
    }
    return [];
  }

  Future<void> insertMyBook(Map<String, dynamic> book) async {
    if (kIsWeb) {
      _myWebCache.removeWhere((b) => b['id'] == book['id']);
      _myWebCache.add(book);
      return;
    }
    final db = await database;
    if (db != null) {
      await db.insert(
        'my_books',
        book,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  Future<void> clearMyBooks() async {
    if (kIsWeb) {
      _myWebCache.clear();
      return;
    }
    final db = await database;
    if (db != null) {
      await db.delete('my_books');
    }
  }

  Future<List<Map<String, dynamic>>> getAllMyBooks() async {
    if (kIsWeb) {
      return List<Map<String, dynamic>>.from(_myWebCache);
    }
    final db = await database;
    if (db != null) {
      return db.query('my_books');
    }
    return [];
  }
}
