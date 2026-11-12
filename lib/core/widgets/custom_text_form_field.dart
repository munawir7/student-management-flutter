import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget{
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;

  const CustomTextFormField({
   super.key,
   required this.controller,
   required this.labelText,
   required this.hintText,
   this.keyboardType = TextInputType.text,
   this.validator,
   this.inputFormatters
  });

  @override  
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
        
        )
      ),
    );
  }
}