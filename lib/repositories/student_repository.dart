
import 'package:sqflite/sqflite.dart';

import '../core/database/database_helper.dart';
import '../models/student.dart';

class StudentRepository {
  final DatabaseHelper _databaseHelper= DatabaseHelper.instance;

  Future<List<Student>> getStudents(int classroomId) async {
   final Database db = await _databaseHelper.database;

   final result = await db.query(
    'students',
    where: 'classroomId = ?',
    whereArgs: [classroomId]
   );

   return result.map((map) => Student.fromMap(map)).toList();

  }
Future<int> addStudent (Student student) async{
  final Database db = await _databaseHelper.database;

  return await db.insert(
    'students',
    student.toMap()
    );
}
 Future<int> updateStudent(Student student) async {
  final Database db = await _databaseHelper.database;

  return await db.update(
    'students',
    student.toMap(),
    where: 'id = ?',
    whereArgs: [student.id],
  );
 }
 Future<Student?> getStudentById(int id) async {
  final Database db = await _databaseHelper.database;

  final result = await db.query(
    'students',
    where: 'id = ?',
    whereArgs: [id],
    limit: 1,
  );
  if (result.isEmpty){
    return null;
  }
  return Student.fromMap(result.first);

 }
 Future<int> deleteStudent(int id) async{
  final Database db = await _databaseHelper.database;

  return await db.delete(
    'students',
    where: 'id = ?',
    whereArgs: [id],
  );
 }

}
