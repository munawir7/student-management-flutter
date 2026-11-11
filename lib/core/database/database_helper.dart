import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';


class DatabaseHelper {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = 
  DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async{
    if (_database !=null){
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;

  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'student_management.db');

    return await openDatabase(
      path,
      version:  1,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _createTables,
    );
  }
Future<void> _createTables(Database db, int version) async {
  await db.execute('''
CREATE TABLE classrooms (
id INTEGER PRIMARY KEY AUTOINCREMENT,
name TEXT NOT NULL,
description TEXT NOT NULL
) 

 ''' );
await db.execute(
  '''
CREATE TABLE students (
id INTEGER PRIMARY KEY AUTOINCREMENT,
classroomId INTEGER NOT NULL,
name TEXT NOT NULL,
age INTEGER NOT NULL,
phone TEXT NOT NULL,
email TEXT NOT NULL,
address TEXT NOT NULL,
FOREIGN KEY (classroomId)
REFERENCES classrooms (id)
ON DELETE CASCADE
)

'''
 );

 
 

}

}