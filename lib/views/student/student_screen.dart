import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/classroom.dart';
import '../../models/student.dart';
import '../../viewmodels/student_viewmodel.dart';
import 'student_detail_screen.dart';

class StudentScreen extends StatefulWidget {
final Classroom classroom;
 
 const StudentScreen({
   super.key,
   required this.classroom
 });

 @override 
 State<StudentScreen> createState() => _StudentScreenState();

}
class _StudentScreenState extends State<StudentScreen>{

  @override 
  void initState(){
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_){
     context.read<StudentViewmodel>().loadStudents(
      widget.classroom.id!,
     );
    });
  }
 
 void _showDeleteConfirmation(Student student){
 showDialog(context: context, 
 builder: (dialogContext){
 return AlertDialog(
  title: Text('Delete Student'),
  content: Text(
    'Are you sure you want to delete ${student.name}?',

  ),
  actions: [
    TextButton(onPressed: (){
      Navigator.pop(dialogContext);
    }, child: Text('Cancel'),
    ),
    ElevatedButton(onPressed: () async{
      final success = await context
      .read<StudentViewmodel>()
      .deleteStudent(student.id!);
      if (!mounted || !dialogContext.mounted) return;

      Navigator.pop(dialogContext);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          success
          ? 'Student deleted successfully'
          : 'Failed to delete student',
        ))
      );
    }, child: Text('Delete'))
  ],
 );
 }); 
}

void _showStudentDialog({Student? student}){
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();

  if (student != null) {
  nameController.text = student.name;
  ageController.text = student.age.toString();
  phoneController.text = student.phone;
  emailController.text = student.email;
  addressController.text = student.address;
}

  showDialog(
    context: context, 
    builder: (dialogContext){
      return AlertDialog(
       title: Text(student == null ? 'Add Student' : 'Edit Student'),

        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Student Name'
                ),
              ),
              TextField(
                controller: ageController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Phone'
                ),
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                labelText: 'Email',
                ),
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: 'Address'
                ),
              ),

            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext), 
            child: Text('Cancel'),),
            ElevatedButton(
              onPressed: () async{
                final name = nameController.text.trim();
                final age = int.tryParse(ageController.text.trim());
                final phone = phoneController.text.trim();
                final email = emailController.text.trim();
                final address = addressController.text.trim();

                if (name.isEmpty ||
                    age == null ||
                    age <= 0 ||
                    phone.isEmpty ||
                    email.isEmpty ||
                    address.isEmpty ){
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        SnackBar(
                          content: Text('Please enter valid student details'),)
                      );
                      return;
                    }
                   final updatedStudent = Student(
                    id: student?.id,
                    classroomId: widget.classroom.id!,
                    name: name,
                    age: age,
                    phone: phone,
                    email: email,
                    address: address
                   );
                   final viewModel = context.read<StudentViewmodel>();

                   final success = student == null
                   ? await viewModel.addStudent(updatedStudent)
                   : await viewModel.updateStudent(updatedStudent);

                      if (!mounted || !dialogContext.mounted) return;

                      if (success) {
                        Navigator.pop(dialogContext);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                           content: Text(
                             student == null
                             ? 'Student added successfully'
                             : 'Student updated successfully',
                            ))
                        );
                      } else {
                        ScaffoldMessenger.of(dialogContext).showSnackBar(
                          SnackBar(
                            content: Text(
                              viewModel.errorMessage ?? 'Failed to add student',
                            ) 
                          )
                        );
                      }
              },
               child: Text(student == null ? 'Add' : 'Update'),
              )
        ],
      );
    });
}
@override 
Widget build(BuildContext context){
  return Scaffold(
    appBar: AppBar(
      title: Text(widget.classroom.name),
       centerTitle: true,
    ),
    body: Consumer<StudentViewmodel>(
      builder: (context, viewModel, child) {
       
    if (viewModel.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (viewModel.errorMessage != null &&
       viewModel.students.isEmpty    
    ){
      return Center(
        child: Text(viewModel.errorMessage!),
      );
    }
    if (viewModel.students.isEmpty){
      return Center(
        child: Text('No students available. Add you first student!'),
      );
    }
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: viewModel.students.length,
      itemBuilder: (context, index) {
        final student = viewModel.students[index];

        return Card(
          child: ListTile(
            onTap: () {
              Navigator.push(context,
               MaterialPageRoute(builder: (context)
               => StudentDetailScreen(student: student)));
            },
            leading: CircleAvatar(
              child: Icon(Icons.person),
            ),
title: Text(
  student.name,
  style: TextStyle(
    fontWeight: FontWeight.bold
  ),
),

subtitle: Text(
  'Age: ${student.age}\nPhone: ${student.phone}',
),

 trailing: PopupMenuButton<String>(
 onSelected: (value){
  if (value == 'edit') {
  _showStudentDialog(student: student);
}
else if (value == 'delete') {
  _showDeleteConfirmation(student);
}
 },
 itemBuilder: (context) => [
  PopupMenuItem(
    value: 'edit',
    child: Text('Edit'),
  ),
  PopupMenuItem(
    value: 'delete',
    child: Text('Delete'),
  ),
 ],
 
 ),

          ),
        );
      },
      );
      } ,),

      floatingActionButton: FloatingActionButton(
        onPressed: _showStudentDialog,
        child: Icon(Icons.add),
      )
  );
}
}