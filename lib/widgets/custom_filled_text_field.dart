import 'package:flutter/material.dart';

class CustomFilledTextField extends StatefulWidget {
  final TextEditingController? controller;
  final TextStyle? style;
  final bool? isReadOnly;
  final String? Function(String?)? validator;
  final String? labelText;
  final bool? enabled;
  final bool? obscureText;
  final Widget? suffixIcon;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  const CustomFilledTextField(
      {super.key,
      this.controller,
      this.style,
      this.isReadOnly = false,
      this.labelText,
      this.validator,
      this.enabled = true,
      this.obscureText = false,
      this.suffixIcon,
      this.textCapitalization = TextCapitalization.none,
      this.keyboardType});

  @override
  State<CustomFilledTextField> createState() => _CustomFilledTextFieldState();
}

class _CustomFilledTextFieldState extends State<CustomFilledTextField> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: const EdgeInsets.all(0),
      color: Colors.red.shade900,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Transform.scale(
        scale: 1.01,
        child: TextFormField(
          obscureText: widget.obscureText ?? false,
          controller: widget.controller,
          enabled: widget.enabled,
          keyboardType: widget.keyboardType,
          textCapitalization: widget.textCapitalization,
          readOnly: widget.isReadOnly ?? false,
          decoration: InputDecoration(
            labelText: widget.labelText,
            suffixIcon: widget.suffixIcon,
            filled: true,
            border: InputBorder.none,
            errorStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
          ),
          style: widget.style ?? const TextStyle(fontSize: 17),
          focusNode: focusNode,
          onTapOutside: (event) => focusNode.unfocus(),
          validator: widget.validator,
        ),
      ),
    );
  }
}
