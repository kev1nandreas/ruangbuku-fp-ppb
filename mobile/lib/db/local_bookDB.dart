import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class LocalBookDB {
  LocalBookDB._();
  static final LocalBookDB instance = LocalBookDB._();

  static Database? _database;
  static Future<Database>? _initDbFuture;
  final List<Map<String, dynamic>> _webCache = [];
  final List<Map<String, dynamic>> _myWebCache = [];

  Future<Database?> get database async {
    if (kIsWeb) return null;
    if (_database != null) return _database!;
    _initDbFuture ??= _initDB('ruangbuku.db');
    _database = await _initDbFuture;
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);
    return openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE users (
  local_id INTEGER PRIMARY KEY AUTOINCREMENT,
  backend_id TEXT UNIQUE,
  name TEXT,
  email TEXT UNIQUE,
  avatarUrl TEXT
)
''');

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
  local_owner_id INTEGER,
  ownerName TEXT,
  imageUrl TEXT,
  distance TEXT,
  condition TEXT,
  hasActiveBorrowing INTEGER DEFAULT 0
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
  local_owner_id INTEGER,
  ownerName TEXT,
  imageUrl TEXT,
  distance TEXT,
  condition TEXT,
  hasActiveBorrowing INTEGER DEFAULT 0
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
    if (oldVersion < 3) {
      try { await db.execute('ALTER TABLE books ADD COLUMN hasActiveBorrowing INTEGER DEFAULT 0'); } catch (_) {}
      try { await db.execute('ALTER TABLE my_books ADD COLUMN hasActiveBorrowing INTEGER DEFAULT 0'); } catch (_) {}
    }
    if (oldVersion < 4) {
      try {
        await db.execute('''
CREATE TABLE users (
  local_id INTEGER PRIMARY KEY AUTOINCREMENT,
  backend_id TEXT UNIQUE,
  name TEXT,
  email TEXT UNIQUE,
  avatarUrl TEXT
)
''');
      } catch (_) {}
      try { await db.execute('ALTER TABLE books ADD COLUMN local_owner_id INTEGER'); } catch (_) {}
      try { await db.execute('ALTER TABLE my_books ADD COLUMN local_owner_id INTEGER'); } catch (_) {}
    }
  }

  // --- USER OPERATIONS ---
  
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    if (kIsWeb) return null;
    final db = await database;
    if (db == null) return null;
    final result = await db.query('users', where: 'email = ?', whereArgs: [email]);
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int?> upsertUser(Map<String, dynamic> user) async {
    if (kIsWeb) return null;
    final db = await database;
    if (db == null) return null;
    
    final email = user['email'] as String?;
    if (email == null) return null;
    
    final existing = await getUserByEmail(email);
    if (existing != null) {
      await db.update(
        'users',
        user,
        where: 'email = ?',
        whereArgs: [email],
      );
      return existing['local_id'] as int?;
    } else {
      return await db.insert('users', user, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  // --- BOOK OPERATIONS ---

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

  // --- MY BOOKS OPERATIONS ---

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

  Future<void> deleteMyBooksByBackendOwner(String ownerId) async {
    if (kIsWeb) {
      _myWebCache.removeWhere((b) => b['ownerId'] == ownerId);
      return;
    }
    final db = await database;
    if (db != null) {
      await db.delete('my_books', where: 'ownerId = ?', whereArgs: [ownerId]);
    }
  }

  Future<List<Map<String, dynamic>>> getMyBooksByBackendOwner(String ownerId) async {
    if (kIsWeb) {
      return _myWebCache.where((b) => b['ownerId'] == ownerId).toList();
    }
    final db = await database;
    if (db != null) {
      return db.query('my_books', where: 'ownerId = ?', whereArgs: [ownerId]);
    }
    return [];
  }
}
