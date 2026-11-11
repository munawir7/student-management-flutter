import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:provider/provider.dart';
import 'package:student_management/viewmodels/student_viewmodel.dart';
import 'package:student_management/views/classroom/classroom_screen.dart';

import 'viewmodels/classroom_viewmodel.dart';

void main(){
  if(kIsWeb){
    databaseFactory = databaseFactoryFfiWeb;
  }
  runApp(
    MultiProvider(
      providers: [
     ChangeNotifierProvider(
      create: (context)=> ClassroomViewmodel()),
      ChangeNotifierProvider(create: (context) => StudentViewmodel(),
      ),
      ],
      child: MyApp(),
      ),
  );
}

class MyApp extends StatelessWidget{
 const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Management',
      
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home:  ClassroomScreen()
      );
    
  }
}