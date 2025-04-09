import 'package:flutter/material.dart';

class DropdownValueController<T> extends ValueNotifier<T?> {
  T? get selectedItem => value;

  set selectedItem(T? newValue) {
    value = newValue;
    updated?.call(newValue);
  }

  Function(T? item)? updated;

  DropdownValueController({T? selectedItem}) : super(selectedItem);
}
