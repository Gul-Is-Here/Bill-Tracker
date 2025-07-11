import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'bill_tracker.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE bills(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        amount REAL NOT NULL,
        dueDate TEXT NOT NULL,
        frequency TEXT NOT NULL,
        category TEXT NOT NULL,
        isPaid INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE payments(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        billId INTEGER NOT NULL,
        amount REAL NOT NULL,
        paymentDate TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (billId) REFERENCES bills(id) ON DELETE CASCADE
      )
    ''');
  }

  // ========== BILL OPERATIONS ==========

  Future<int> insertBill(Map<String, dynamic> bill) async {
    final db = await database;
    return await db.insert('bills', bill);
  }

  Future<List<Map<String, dynamic>>> getBills() async {
    final db = await database;
    return await db.query('bills', orderBy: 'dueDate ASC');
  }

  Future<Map<String, dynamic>?> getBill(int id) async {
    final db = await database;
    final results = await db.query(
      'bills',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updateBill(Map<String, dynamic> bill) async {
    final db = await database;
    return await db.update(
      'bills',
      bill,
      where: 'id = ?',
      whereArgs: [bill['id']],
    );
  }

  Future<int> deleteBill(int id) async {
    final db = await database;
    return await db.delete('bills', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> searchBills(String query) async {
    final db = await database;
    return await db.query(
      'bills',
      where: 'name LIKE ?',
      whereArgs: ['%$query%'],
    );
  }

  Future<List<Map<String, dynamic>>> getBillsByCategory(String category) async {
    final db = await database;
    return await db.query(
      'bills',
      where: 'category = ?',
      whereArgs: [category],
    );
  }

  Future<List<Map<String, dynamic>>> getBillsByStatus(bool isPaid) async {
    final db = await database;
    return await db.query(
      'bills',
      where: 'isPaid = ?',
      whereArgs: [isPaid ? 1 : 0],
    );
  }

  // ========== PAYMENT OPERATIONS ==========

  Future<int> insertPayment(Map<String, dynamic> payment) async {
    final db = await database;
    return await db.insert('payments', payment);
  }

  Future<List<Map<String, dynamic>>> getPayments(int billId) async {
    final db = await database;
    return await db.query(
      'payments',
      where: 'billId = ?',
      whereArgs: [billId],
      orderBy: 'paymentDate DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAllPayments() async {
    final db = await database;
    return await db.query('payments', orderBy: 'paymentDate DESC');
  }

  Future<Map<String, dynamic>?> getPayment(int id) async {
    final db = await database;
    final results = await db.query(
      'payments',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    return results.isNotEmpty ? results.first : null;
  }

  Future<int> updatePayment(Map<String, dynamic> payment) async {
    final db = await database;
    return await db.update(
      'payments',
      payment,
      where: 'id = ?',
      whereArgs: [payment['id']],
    );
  }

  Future<int> deletePayment(int id) async {
    final db = await database;
    return await db.delete('payments', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> searchPayments(String query) async {
    final db = await database;
    return await db.query(
      'payments',
      where: 'notes LIKE ?',
      whereArgs: ['%$query%'],
    );
  }

  Future<List<Map<String, dynamic>>> getPaymentsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    return await db.query(
      'payments',
      where: 'paymentDate BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );
  }

  // ========== UTILITY METHODS ==========

  Future<void> clearDatabase() async {
    final db = await database;
    await db.delete('payments');
    await db.delete('bills');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
  
}
