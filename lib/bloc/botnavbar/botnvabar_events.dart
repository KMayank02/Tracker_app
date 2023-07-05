import 'package:flutter/material.dart';

@immutable
abstract class BottomNavigationEvent {
  const BottomNavigationEvent();
}

class TabChange extends BottomNavigationEvent {
  final int tabIndex;

  const TabChange({required this.tabIndex});
}
