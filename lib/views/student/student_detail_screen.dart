import 'package:flutter/material.dart';
import '../../models/student.dart';

class StudentDetailScreen extends StatelessWidget {
  final Student student;

  const StudentDetailScreen({
    super.key,
    required this.student
  });
  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Student Details'
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 45,
                child: Icon( Icons.person, size: 50,),
              ),
            ),
            SizedBox(height: 25,),
            Text(
              'Name: ${student.name}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 15,),
            Text('Age: ${student.age}'),

            SizedBox(height: 15,),

          Text('Phone: ${student.phone}'),

          SizedBox(height: 15,),

          Text('Email: ${student.email}'),
          SizedBox(height: 15,),
          Text('Address: ${student.address}')
          ],
        ),
        ),
    );
  }
}