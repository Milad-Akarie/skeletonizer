// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:example/main.dart';
import 'package:skeleton_builder/skeleton_builder.dart';

void main() {
  final mat = Matrix4.diagonal3Values(2, 2, 1.0);

  print(MatrixUtils.getAsScale(mat));
  final inverted = mat.clone()..invert();
  print(MatrixUtils.getAsScale(inverted));
  const point = Offset(20, 20);
  final transformed = MatrixUtils.transformPoint(mat, point);
  print(transformed);

  print(MatrixUtils.transformPoint(inverted, transformed));
}
