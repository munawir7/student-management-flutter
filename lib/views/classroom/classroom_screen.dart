import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constance.dart';
import '../../core/widgets/custom_text_form_field.dart';
import '../../models/classroom.dart';
import '../../viewmodels/classroom_viewmodel.dart';
import '../student/student_screen.dart';

class ClassroomScreen extends StatefulWidget{
  const ClassroomScreen({
    super.key
  });
  @override
  State<ClassroomScreen> createState() => _ClassroomScreenState();

}

 class _ClassroomScreenState extends State<ClassroomScreen>{
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ClassroomViewmodel>().loadClassrooms();
    });
  }
  void _showClassroomDialog({Classroom? classroom}) {
    final isEditing = classroom != null;

    final nameController = TextEditingController(
      text: classroom?.name ?? '',
    );

    final descriptionController = TextEditingController(
      text: classroom?.description ?? '',
    );
    showDialog(
      context: context, 
      builder: (dialogContext){
        return AlertDialog(
          title: Text(isEditing ? 'Edit Classroom' : 'Add Classroom'),
          content: SingleChildScrollView(
  child: Column(
    mainAxisSize: MainAxisSize.min,
    children: [
              CustomTextFormField(
                controller: nameController, 
                labelText: AppConstance.classroomName, 
                hintText: AppConstance.classroomHint),
                SizedBox(height: 12,),

               CustomTextFormField(
                controller: descriptionController, 
                labelText: AppConstance.description, 
                hintText: AppConstance.descriptionHint) 
            ],

          ),),
actions: [
  ElevatedButton(
    onPressed: () async{
      debugPrint('ADD BUTTON CLICKED');
      final name = nameController.text.trim();
      final description = descriptionController.text.trim();

      if (name.isEmpty || description.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
          content: Text('Please fill in all fields'),
          ),
          );
          return;
      }
      final viewModel = context.read<ClassroomViewmodel>();

      final success = isEditing
      ? await viewModel.updateClassroom(
        Classroom(
        id: classroom.id,  
        name: name, 
        description: description),)
        : await viewModel.addClassroom(
          
          name: name,
          description: description,
        );
        if (!mounted || !dialogContext.mounted) return;

        if (success){
          Navigator.pop(dialogContext);

ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isEditing
              ? 'Classroom updated successfully'
              : 'Classroom added succesfully',
              )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              viewModel.errorMessage ?? 'Something went wrong'
            )));
        }
    }, 
    child: Text(isEditing ? 'Update' : 'Add'),
   )
],

        );
     }
     );
  }
  void _deleteClassroom(int id)async{
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext){
        return AlertDialog(
          title: Text('Delete Classroom'),
          content: Text(
            'Are you sure you want you to delete this classroom?',
          ),
          actions: [
            TextButton(
              onPressed: ()=> Navigator.pop(dialogContext, false), 
              child: Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(dialogContext, true), 
              child: Text(
                'Delete'
              ))
          ],
        );
      });

      if (confirm != true || !mounted) return;

      final viewModel = context.read<ClassroomViewmodel>();
      final success = await viewModel.deleteClassroom(id);

      if (!mounted) return;
     

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
            ? 'Classroom deleted successfully'
            : viewModel.errorMessage?? 'Failed to delete classroom',
          ))
      );
       }

       @override
       Widget build (BuildContext context){
        return Scaffold(
          appBar: AppBar(
            title: Text('Classrooms'),
            centerTitle: true,
          ),
          body: Consumer<ClassroomViewmodel>(
            builder: (context, viewModel, child){
              if (viewModel.isLoading){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (viewModel.errorMessage !=null &&
               viewModel.classrooms.isEmpty
              ){
                return Center(
                  child: Text(viewModel.errorMessage!),
                );
              }
              if (viewModel.classrooms.isEmpty){
                return Center(
                  child: Text('No classrooms availble. Add your first classroom!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(12),

                itemCount: viewModel.classrooms.length,
                itemBuilder: (context, index){
                  final classroom = viewModel.classrooms[index];

                  return Card(
                    margin: EdgeInsets.only(bottom: 12),

                    child: ListTile(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentScreen(
                              classroom: classroom))
                          );
                      },
                      contentPadding: EdgeInsets.all(12),

                      leading:  CircleAvatar(
                        child: Icon(Icons.school),
                      ),

                      title: Text(
                        classroom.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 6),
                        child: Text(classroom.description),
                        ),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value =='edit'){
                              _showClassroomDialog(
                                classroom: classroom
                              );
                            } else if (value == 'delete'){
                              _deleteClassroom(classroom.id!);
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8,),
                                  Text('edit')
                                ],
                              )),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red,),
                                    SizedBox(width: 8,),
                                    Text('Delete'),
                                  ],
                                ))
                          ],
                        ),
                    ),

                   
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            
            onPressed: (){
              _showClassroomDialog();
            },
            child: Icon(Icons.add),
            
          ),
        );
       }
 }