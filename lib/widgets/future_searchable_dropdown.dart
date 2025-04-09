import 'package:flutter/material.dart';
import 'package:test_app/widgets/shimmer_placeholder.dart';

import 'dropdown_value_controller.dart';

class FutureSearchableDropdown<T> extends StatefulWidget {
  final Future<List<T>> items;
  final DropdownValueController<T?> controller;
  final String? Function(T item) titleBuilder;
  final TextStyle? style;
  final bool? isReadOnly;
  final String? Function(T?)? validator;
  final void Function(T? item)? onChanged;
  final String? labelText;
  final InputDecoration? decoration;
  final bool isEnabled;

  const FutureSearchableDropdown(
      {super.key,
      required this.items,
      required this.controller,
      this.style,
      this.isReadOnly = false,
      this.labelText,
      this.validator,
      this.decoration,
      this.onChanged,
      required this.titleBuilder,
      this.isEnabled = true});

  @override
  State<FutureSearchableDropdown<T>> createState() => _FutureSearchableDropdownState<T>();
}

class _FutureSearchableDropdownState<T> extends State<FutureSearchableDropdown<T>> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        widget.controller.updated = (e) {
          if (e != null) {
            textController.text = widget.titleBuilder.call(e) ?? "";
          }
        };

        widget.controller.updated?.call(widget.controller.selectedItem);
      },
    );
  }

  final FocusNode focusNode = FocusNode();
  SearchController searchController = SearchController();
  TextEditingController textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return AbsorbPointer(absorbing: !widget.isEnabled, child: buildDropdownCard(context, snapshot.data!));
          // return buildDropdownCard(context, snapshot.data!);
        } else {
          return ShimmerPlaceholderFormField(
            shimmerColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
            backgroundColor: Theme.of(context).colorScheme.surface,
          );
        }
      },
    );
  }

  Card buildDropdownCard(BuildContext context, List<T> items) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 1,
      margin: const EdgeInsets.all(0),
      color: Colors.red.shade900,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
      child: Transform.scale(
          scale: 1.01,
          child: SearchAnchor(
            searchController: searchController,
            isFullScreen: false,
            viewShape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(25)),
            viewBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            viewElevation: 4,
            viewSurfaceTintColor: Colors.transparent,
            dividerColor: Colors.white,
            builder: (context, controller) {
              return TextFormField(
                controller: textController,
                enabled: false,
                decoration: widget.decoration ??
                    InputDecoration(
                      labelText: widget.labelText,
                      filled: true,
                      border: InputBorder.none,
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        //color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70,
                        color: widget.isEnabled
                            ? (Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70)
                            : Colors.grey,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      enabled: true,
                      errorStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                style: widget.style ??
                    // TextStyle(
                    //     color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                    //     fontSize: 17),
                    TextStyle(
                      color: widget.isEnabled
                          ? (Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)
                          : Colors.grey,
                      fontSize: 17,
                    ),
                validator: (value) {
                  return widget.validator?.call(widget.controller.selectedItem);
                },
              );
            },
            suggestionsBuilder: (context, controller) {
              var filtered = items.where(
                (element) =>
                    widget.titleBuilder
                        .call(element)
                        ?.contains(RegExp(".*${controller.text}.*", caseSensitive: false)) ??
                    false,
              );
              return filtered.map((e) => ListTile(
                    title: Text(
                      widget.titleBuilder.call(e) ?? "",
                      style: TextStyle(
                        fontSize: 17,
                        color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    onTap: () {
                      widget.onChanged?.call(e);
                      widget.controller.selectedItem = e;
                      // textController.text = widget.titleBuilder.call(e) ?? "";
                      Navigator.of(context).pop();
                    },
                  ));
            },
          )),
    );
  }
}
