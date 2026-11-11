import 'package:flutter/material.dart';

import '../models/classroom.dart';
import '../repositories/classroom_repository.dart';

class ClassroomViewmodel extends ChangeNotifier {
  final ClassroomRepository _repository;

  ClassroomViewmodel({
    ClassroomRepository? repository
  })
  : _repository = repository ?? ClassroomRepository();

  List<Classroom> _classrooms = [];

  bool _isLoading = false;
  bool _isSaving = false;

  String? _errorMessage;

  List<Classroom> get classrooms => _classrooms;

  bool get isLoading => _isLoading;
  
  bool get isSaving => _isSaving;

  String? get errorMessage => _errorMessage;

  Future<void> loadClassrooms() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _classrooms = await _repository.getClassrooms();

    } catch (e){
      _errorMessage = 'Failed to load classrooms: $e';

    } finally {
    _isLoading = false;
    notifyListeners();
    }
  }
  Future<bool> addClassroom({
    required String name,
    required String description,
  }) async {
    _isSaving= true;
    _errorMessage = null;
    notifyListeners();

    try {
      final classroom = Classroom(
        name: name,
      description: description);
      await _repository.addClassroom(classroom);

      _classrooms = await _repository.getClassrooms();

      return true;
    } catch (e) {
      _errorMessage = 'Failed to add classroom: $e';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
  Future<bool> updateClassroom(Classroom classroom)async {
  _isSaving = true;
  _errorMessage = null;
  notifyListeners();

  try{
  await _repository.updateClassroom(classroom); 

  final index = _classrooms.indexWhere(
  (item) => item.id == classroom.id,
  );
  if (index != -1 ){
  _classrooms[index] = classroom;

  }

  return true;

  } catch (e){
  _errorMessage = 'Failed to update classroom: $e';
  return false;
  } finally {
  _isSaving = false;
  notifyListeners();
  }
  }
  Future<bool> deleteClassroom(int id) async{
  _isSaving= true;
  _errorMessage = null;
  notifyListeners();

  try {
  await _repository.deleteClassroom(id);

  _classrooms.removeWhere(
  (classroom) => classroom.id == id,
  );

  return true;
  } catch (e){
  _errorMessage = 'Failed to delete classroom: $e';
  return false;
  } finally {
  _isSaving = false;
  notifyListeners();
  }
    }
}