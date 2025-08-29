import 'package:flutter/material.dart';
import 'package:text_form_field_wrapper/text_form_field_wrapper.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputAction textInputAction;
  final TextInputType keyboardType;
  final String? Function(String?)? validator; // Made optional
  final TextEditingController controller;
  final bool obscureText;
  final TextFormFieldPosition position;

  const CustomTextFormField(
      {super.key,
      required this.labelText,
      required this.hintText,
      this.keyboardType = TextInputType.text,
      this.textInputAction = TextInputAction.next,
      this.validator, // Optional
      required this.controller,
      this.obscureText = false,
      this.position = TextFormFieldPosition.alone});

  @override
  Widget build(BuildContext context) {
    // Accessing the current theme text color using the new bodyLarge property
    final textColor = Theme.of(context).textTheme.bodySmall?.color;

    return TextFormFieldWrapper(
      formField: TextFormField(
        controller: controller,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          labelStyle: TextStyle(
              color: textColor), // Apply theme-based text color to label
          hintStyle: TextStyle(
              color: textColor), // Apply theme-based text color to hint
          border: InputBorder.none,
        ),
        keyboardType: keyboardType,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: textInputAction,
        validator: validator, // No issues if null
        obscureText: obscureText,
        style: TextStyle(
            color: textColor), // Apply theme-based text color to the input text
      ),
      position: position,
    );
  }
}
