// เป็น utility สำหรับ initial database
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper_test {
  static Database _db;

  Future<Database> get db async {
    // ถ้าเรียก db เมื่อไหร่ก้อจะ ได้ db ออกไป
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase(); // อันนี้มันจะ return db มาเก็บไว้ใน _db นะ
    return _db;
  }

  // Future<Database> initDatabase() async {
  initDatabase() async {
    // บรรทัดบนคือ เขียนแบบเต็มนะ จะมี Future ด้วย
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath,
        'test_db.db'); // เมื่อได้ db มาก้อนำมาจอยกับ test_db.db ที่เราให้มัน initial ขึ้นมานะ

    // open the database
    Database db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // When creating the db, create the table
      await db.execute(
          'CREATE TABLE customers (id INTEGER PRIMARY KEY, name TEXT)'); // มีแค่ 2  field นะ
      // ถ้าอยากได้หลาย table ก้อ create เพิ่มเติมได้ในส่วนนี้เลย ก้อ copy db.execute เพิ่มอีกหลายบรรทัดได้เลย
    });
    return db; // ถ้าเรียก method นี้ ก้อจะได้ database ออกไป
  }
}
