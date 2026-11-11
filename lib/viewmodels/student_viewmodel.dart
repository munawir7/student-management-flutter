import 'package:flutter/material.dart';
import '../models/student.dart';
import '../repositories/student_repository.dart';

class StudentViewmodel extends ChangeNotifier {
  final StudentRepository _repository;

  
    StudentViewmodel ({
      StudentRepository? repository,
        
    }) :_repository = repository ?? StudentRepository();

    List<Student> _students = [];
    bool _isLoading = false;
    bool _isSaving = false;

    String? _errorMessage;

    List<Student> get students => _students;

    bool get isLoading => _isLoading;
    bool get isSaving => _isSaving;

    String? get errorMessage => _errorMessage;

    Future<void> loadStudents(int classroomId) async {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      try {
  _students = await _repository.getStudents(classroomId);
      } catch (e) {
        _errorMessage = 'Failed to load students: $e' ;

      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
    Future <bool> addStudent(Student student) async {
      _isSaving = true;
      _errorMessage = null;
      notifyListeners();

      try {
        await _repository.addStudent(student);

        _students = await _repository.getStudents(student.classroomId);

        return true;
      } catch (e){
        _errorMessage = 'Failed to add student: $e';
        return false;
      }finally {
        _isSaving = false;
        notifyListeners();
      }
    }
    Future<bool> updateStudent(Student student) async {
      _isSaving = true;
      _errorMessage = null;
      notifyListeners();

      try {
        await _repository.updateStudent(student);

        final index = _students.indexWhere(
          (item) => item.id == student.id,
        );
        if (index != -1) {
          _students[index] = student;
        }

        return true;
      } catch (e){
        _errorMessage = 'Failed to update student: $e';
        return false;
      } finally {
        _isSaving = false;
        notifyListeners();
      }
    }
    Future<bool> deleteStudent(int id) async{
      _isSaving = true;
      _errorMessage = null;
      notifyListeners();

      try {
        await _repository.deleteStudent(id);

        _students.removeWhere(
          (student) => student.id == id,
        );
        return true;

      } catch (e){
        _errorMessage = 'Failed to delete student: $e';
        return false;

      } finally {
        _isSaving = false;
        notifyListeners();
      }
    }
    Future<Student?>getStudentById(int id )async {
      try {
        return await _repository.getStudentById(id);
      } catch (e) {
        _errorMessage = 'Failed to get student details: $e';
        notifyListeners();
        return null;
      }
    }
  }