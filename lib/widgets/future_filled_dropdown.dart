// import 'package:flutter/material.dart';
// import 'package:test_app/widgets/shimmer_placeholder.dart';
// import 'dropdown_value_controller.dart';

// class FutureFilledDropdown<T> extends StatefulWidget {
//   final Future<List<T>> items;
//   final DropdownValueController<T?> controller;
//   final String? Function(T item) titleBuilder;
//   final TextStyle? style;
//   final bool? isReadOnly;
//   final String? Function(T?)? validator;
//   final String? labelText;
//   final InputDecoration? decoration;
//   final void Function(T?)? onChange;

//   const FutureFilledDropdown({
//     super.key,
//     required this.items,
//     required this.controller,
//     this.style,
//     this.isReadOnly = false,
//     this.labelText,
//     this.validator,
//     this.decoration,
//     required this.titleBuilder,
//     this.onChange,
//   });

//   @override
//   State<FutureFilledDropdown<T>> createState() => _FutureFilledDropdownState<T>();
// }

// class _FutureFilledDropdownState<T> extends State<FutureFilledDropdown<T>> {
//   final FocusNode focusNode = FocusNode();
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: widget.items,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
//           return buildDropdownCard(context, snapshot.data!);
//         } else {
//           return ShimmerPlaceholderFormField(
//             shimmerColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.25),
//             backgroundColor: Theme.of(context).colorScheme.surface,
//           );
//         }
//       },
//     );
//   }

//   Card buildDropdownCard(BuildContext context, List<T> items) {
//     return Card(
//       clipBehavior: Clip.antiAliasWithSaveLayer,
//       elevation: 2,
//       margin: const EdgeInsets.all(0),
//       color: Colors.grey.shade900,
//       shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5)),
//       child: Transform.scale(
//         scale: 1.01,
//         child: DropdownButtonFormField<T>(
//           // onChanged: (value) {
//           //   widget.controller.selectedItem = value;
//           //   if (widget.onChange != null) {
//           //     widget.onChange!(value);
//           //   }
//           // },
//           onChanged: widget.isReadOnly ?? false
//               ? null
//               : (value) {
//                   widget.controller.selectedItem = value;
//                   if (widget.onChange != null) {
//                     widget.onChange!(value);
//                   }
//                 },
//           items: items
//               .map(
//                 (e) => DropdownMenuItem(
//                   value: e,
//                   child: Text(
//                     widget.titleBuilder.call(e) ?? "",
//                     style: TextStyle(
//                       fontSize: 17,
//                       color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                 ),
//               )
//               .toList(),
//           // widget.itemsBuilder.call(items)?.toList(),
//           value: widget.controller.selectedItem,
//           isExpanded: true,
//           decoration: widget.decoration ??
//               InputDecoration(
//                 labelText: widget.labelText,
//                 filled: true,
//                 border: InputBorder.none,
//                 errorStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
//               ),
//           style: widget.style ?? const TextStyle(fontSize: 17),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:test_app/widgets/shimmer_placeholder.dart';
import 'dropdown_value_controller.dart';

class FutureFilledDropdown<T> extends StatefulWidget {
  final Future<List<T>> items;
  final DropdownValueController<T?> controller;
  final String? Function(T item) titleBuilder;
  final TextStyle? style;
  final bool? isReadOnly;
  final String? Function(T?)? validator; // ✅ Nullable validator
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
  State<FutureFilledDropdown<T>> createState() => _FutureFilledDropdownState<T>();
}

class _FutureFilledDropdownState<T> extends State<FutureFilledDropdown<T>> {
  final FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<T>>(
      future: widget.items,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
          return buildDropdownCard(context, snapshot.data!);
        } else {
          return ShimmerPlaceholderFormField(
            shimmerColor: Theme.of(context).colorScheme.primary.withAlpha(64),
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
      color: Colors.grey.shade900,
      shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(5)),
      child: Transform.scale(
        scale: 1.01,
        child: DropdownButtonFormField<T>(
          onChanged: widget.isReadOnly ?? false
              ? null
              : (value) {
                  widget.controller.selectedItem = value;
                  if (widget.onChange != null) {
                    widget.onChange!(value);
                  }
                },
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(
                    widget.titleBuilder.call(e) ?? "",
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              )
              .toList(),
          value: widget.controller.selectedItem,
          isExpanded: true,
          validator: widget.validator, // ✅ Only set if non-null
          decoration: widget.decoration ??
              InputDecoration(
                labelText: widget.labelText,
                filled: true,
                border: InputBorder.none,
                errorStyle: const TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
          style: widget.style ?? const TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
