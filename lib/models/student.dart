class Student {
  final int? id;
  final int classroomId;
  final String name;
  final int age;
  final String phone;
  final String email;
  final String address;

  Student({
    this.id,
    required this.classroomId,
    required this.name,
    required this.age,
    required this.phone,
    required this.email,
    required this.address
  });
  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'classroomId': classroomId,
      'name': name,
      'age': age,
      'phone': phone,
      'email': email,
      'address': address
    };
  }
  factory Student.fromMap(Map<String, dynamic> map) {
    return Student(
      id: map['id'] as int?,
      classroomId: map['classroomId'] as int, 
      name: map['name'] as String, 
      age: map['age'] as int, 
      phone: map['phone'] as String, 
      email: map['email'] as String, 
      address: map['address'] as String);
  }
}