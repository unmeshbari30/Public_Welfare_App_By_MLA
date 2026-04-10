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
  final void Function(String)? onChanged;
  final int? maxLines;
  final String? hintText;
  final int? maxLength;

  const CustomFilledTextField({
    super.key,
    this.onChanged,
    this.controller,
    this.style,
    this.isReadOnly = false,
    this.labelText,
    this.validator,
    this.enabled = true,
    this.obscureText = false,
    this.suffixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.keyboardType,
    this.maxLines,
    this.hintText,
    this.maxLength,
  });

  @override
  State<CustomFilledTextField> createState() => _CustomFilledTextFieldState();
}

class _CustomFilledTextFieldState extends State<CustomFilledTextField> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      maxLength: widget.maxLength,
      obscureText: widget.obscureText ?? false,
      controller: widget.controller,
      enabled: widget.enabled,
      maxLines: widget.obscureText == true ? 1 : widget.maxLines ?? 1,
      keyboardType: widget.keyboardType,
      textCapitalization: widget.textCapitalization,
      readOnly: widget.isReadOnly ?? false,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
      ),
      style:
          widget.style ??
          const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      focusNode: focusNode,
      onTapOutside: (event) => focusNode.unfocus(),
      validator: widget.validator,
    );
  }
}
