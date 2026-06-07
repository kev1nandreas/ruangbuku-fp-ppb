import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // In-memory fallback cache for Flutter Web
  final List<Map<String, dynamic>> _webCache = [];

  DatabaseHelper._init();

  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database!;
    _database = await _initDB('ruangbuku.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
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
  }

  Future<void> insertBook(Map<String, dynamic> book) async {
    if (kIsWeb) {
      _webCache.removeWhere((b) => b['id'] == book['id']);
      _webCache.add(book);
      return;
    }
    final db = await database;
    if (db != null) {
      await db.insert('books', book, conflictAlgorithm: ConflictAlgorithm.replace);
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
      return await db.query('books');
    }
    return [];
  }
}
