import 'package:flutter/material.dart';
import 'package:rajesh_dada_padvi/widgets/shimmer_placeholder.dart';

import 'dropdown_value_controller.dart';

class FutureFilledDropdown<T> extends StatefulWidget {
  final Future<List<T>> items;
  final DropdownValueController<T?> controller;
  final String? Function(T item) titleBuilder;
  final TextStyle? style;
  final bool? isReadOnly;
  final String? Function(T?)? validator;
  final String? labelText;
  final InputDecoration? decoration;
  final void Function(T?)? onChange;

  const FutureFilledDropdown({
    super.key,
    required this.items,
    required this.controller,
    this.style,
    this.isReadOnly = false,
    this.labelText,
    this.validator,
    this.decoration,
    required this.titleBuilder,
    this.onChange,
  });

  @override
  State<FutureFilledDropdown<T>> createState() =>
      _FutureFilledDropdownState<T>();
}

class _FutureFilledDropdownState<T> extends State<FutureFilledDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: widget.items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return _buildDropdownCard(context, snapshot.data!);
        }

        return ShimmerPlaceholderFormField(
          shimmerColor: Theme.of(context).colorScheme.primary.withAlpha(64),
          backgroundColor: Theme.of(context).colorScheme.surface,
        );
      },
    );
  }

  Widget _buildDropdownCard(BuildContext context, List<T> items) {
    final theme = Theme.of(context);

    return DropdownButtonFormField<T>(
      onChanged: widget.isReadOnly ?? false
          ? null
          : (value) {
              widget.controller.selectedItem = value;
              widget.onChange?.call(value);
            },
      items: items
          .map(
            (e) => DropdownMenuItem<T>(
              value: e,
              child: Text(
                widget.titleBuilder.call(e) ?? "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          )
          .toList(),
      initialValue: widget.controller.selectedItem,
      isExpanded: true,
      validator: widget.validator,
      decoration:
          widget.decoration ??
          InputDecoration(
            labelText: widget.labelText,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 20,
            ),
          ),
      style: widget.style ?? const TextStyle(fontSize: 16),
      dropdownColor: theme.colorScheme.surface,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      borderRadius: BorderRadius.circular(20),
      menuMaxHeight: 320,
      selectedItemBuilder: (context) => items
          .map(
            (e) => Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.titleBuilder.call(e) ?? "",
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
