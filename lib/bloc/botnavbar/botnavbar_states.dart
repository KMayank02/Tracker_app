import 'package:flutter/material.dart';

@immutable
abstract class BottomNavigationState {
  final int tabIndex;

  const BottomNavigationState({required this.tabIndex});
}

class BottomNavigationInitial extends BottomNavigationState {
  const BottomNavigationInitial({required super.tabIndex});
}
