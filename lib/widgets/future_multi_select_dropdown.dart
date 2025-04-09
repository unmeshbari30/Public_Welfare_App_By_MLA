import 'package:flutter/material.dart';
import 'package:test_app/widgets/shimmer_placeholder.dart';

class FutureMultiSelectDropdown<T extends Comparable> extends StatefulWidget {
  final Future<List<T>>? items;
  final List<DropdownMenuItem<T>> Function(List<T> items) itemsBuilder;
  final String Function(T item) itemTitleTextBuilder;
  final void Function(List<T>)? onChanged;
  final List<T>? selectedValues;
  final TextStyle? style;
  final bool? isReadOnly;
  final String? Function(List<T>)? validator;
  final String? labelText;
  final Color? labelColor; // New parameter for label color

  const FutureMultiSelectDropdown({
    super.key,
    this.style,
    this.isReadOnly = false,
    this.labelText,
    this.validator,
    this.items,
    this.onChanged,
    this.selectedValues,
    required this.itemsBuilder,
    this.labelColor,
    required this.itemTitleTextBuilder, // Pass label color as a parameter
  });

  @override
  _FutureMultiSelectDropdownState<T> createState() => _FutureMultiSelectDropdownState<T>();
}

class _FutureMultiSelectDropdownState<T extends Comparable> extends State<FutureMultiSelectDropdown<T>> {
  // List<T> selectedItems = [];

  @override
  void initState() {
    super.initState();
    // selectedItems = widget.selectedValues ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return buildDropdownCard(context, snapshot.data!);
        } else {
          return ShimmerPlaceholderFormField(
            shimmerColor: Colors.white,
            backgroundColor: Theme.of(context).colorScheme.surface,
          );
        }
      },
    );
  }

  Card buildDropdownCard(BuildContext context, List<T> items) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 2,
      margin: const EdgeInsets.all(0),
      color: Colors.red.shade900,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Transform.scale(
        scale: 1.01,
        child: GestureDetector(
          onTap: () => _showMultiSelectDialog(context, items),
          child: InputDecorator(
            decoration: InputDecoration(
              filled: true,
              labelText: widget.labelText,
              labelStyle: TextStyle(
                fontSize: 17,
                color: widget.labelColor ?? Theme.of(context).colorScheme.onSurface,
              ),
              border: InputBorder.none,
            ),
            child: Text(
              widget.selectedValues?.isEmpty ?? true
                  ? 'Select Items'
                  : widget.selectedValues?.map(
                        (e) => widget.itemTitleTextBuilder(e),
                      ).join(', ') ?? "",
              style: widget.style ??
                  TextStyle(
                    fontSize: 17,
                    color: widget.labelColor ?? Theme.of(context).colorScheme.onSurface, // Use same color
                  ),
            ),
          ),
        ),
      ),
    );
  }

  // Function to show the dialog with checkboxes
  Future<void> _showMultiSelectDialog(BuildContext context, List<T> items) async {
    // Temporary list to hold selections within the dialog
    // var selectedTempItems = selectedItems;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Use StatefulBuilder to manage dialog state independently
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              // backgroundColor: Theme.of(context).cardTheme.color,
              title: Text(widget.labelText ?? 'Select Items'),
              content: SingleChildScrollView(
                child: Column(
                  children: items.map((item) {
                    return CheckboxListTile(
                      // fillColor: WidgetStatePropertyAll(Colors.amber),
                      tileColor: Colors.transparent,
                      title: Text(
                        widget.itemTitleTextBuilder(item),
                        style: TextStyle(
                          color: widget.labelColor ?? Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      value: widget.selectedValues?.contains(item),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            widget.selectedValues?.add(item);
                          } else {
                            widget.selectedValues?.remove(item);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Update the main widget's state when OK is pressed
                    setState(() {
                      widget.onChanged?.call(widget.selectedValues ?? []);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
