import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

abstract class PaintableElement {
  const PaintableElement({required this.offset});

  final Offset offset;

  Rect get rect;

  void paint(PaintingContext context, Offset offset, Paint shaderPaint);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is PaintableElement && runtimeType == other.runtimeType && offset == other.offset;

  @override
  int get hashCode => offset.hashCode;
}

abstract class AncestorElement extends PaintableElement {
  final List<PaintableElement> descendents;

  const AncestorElement({this.descendents = const [], required super.offset});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AncestorElement &&
          runtimeType == other.runtimeType &&
          const ListEquality().equals(descendents, other.descendents) &&
          super == (other);

  @override
  int get hashCode => const ListEquality().hash(descendents) ^ super.hashCode;
}
