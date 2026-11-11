import 'package:sqflite/sqflite.dart';

import '../core/database/database_helper.dart';
import '../models/classroom.dart';

class ClassroomRepository {
   final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

   Future<int> addClassroom(Classroom classroom) async {
    final db = await _databaseHelper.database;

    return await db.insert(
      'classrooms', 
      classroom.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace);

   }
   Future<List<Classroom>> getClassrooms() async {
    final db = await _databaseHelper.database;

    final result = await db.query('classrooms');

    return result.map((map) => Classroom.fromMap(map)).toList();
   }

   Future<int> updateClassroom(Classroom classroom) async {
    final db = await _databaseHelper.database;
   
   return await db.update(
    'classrooms',
    classroom.toMap(),
    where: 'id = ?',
    whereArgs: [classroom.id],
   );
}

  Future<int> deleteClassroom(int id) async {
    final db = await _databaseHelper.database;

    return await db.delete(
      'classrooms',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}