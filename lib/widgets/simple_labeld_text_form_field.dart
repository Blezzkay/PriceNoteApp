import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../constants/fonts.dart';
import '../../constants/sizes.dart';
import 'custom_labeled_text_form_field.dart';

class SimpleLabeledTextFormField extends StatelessWidget {
  final double padding;
  final String label;
  final TextEditingController controller;
  final String? Function(String?) validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final String hintText;
  final bool isMultiline; // NEW

  const SimpleLabeledTextFormField({
    super.key,
    this.padding = 0,
    required this.label,
    required this.controller,
    required this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.hintText = '',
    this.isMultiline = false, // default false
  });

  @override
  Widget build(BuildContext context) {
    return CustomLabeledTextFormField(
      padding: padding,
      label: label,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      keyboardType: isMultiline ? TextInputType.multiline : keyboardType,
      hintText: hintText,
      labelColor: textDarkColor,
      borderColor: borderLineColor,
      activeBorderColor: borderLineActiveColor,
      borderRadius: textFieldBorderRadius,
      fontFamily: figtreeFontMedium,
      maxLines: isMultiline ? null : 1, // NEW
      textInputAction: isMultiline ? TextInputAction.newline : TextInputAction.done, // NEW
    );
  }
}
