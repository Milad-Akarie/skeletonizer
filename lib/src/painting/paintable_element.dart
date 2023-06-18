import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// An abstraction for objects that hold
/// painting information
///
/// This is like a stripped version of RenderObjects
abstract class PaintableElement {
  /// Default constructor
  const PaintableElement({required this.offset});

  /// The painting offset of the element
  final Offset offset;

  /// The painting bounds of the element
  Rect get rect;

  /// paints the element with the provided shaderPaint and global offset
  void paint(PaintingContext context, Offset offset, Paint shaderPaint);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaintableElement &&
          runtimeType == other.runtimeType &&
          offset == other.offset;

  @override
  int get hashCode => offset.hashCode;
}

/// An abstraction for Container-like ancestor elements
///
/// this will paint it self then paint any descendent elements
abstract class AncestorElement extends PaintableElement {
  /// The descenders of this ancestor
  final List<PaintableElement> descendents;

  /// Default constructor
  const AncestorElement({
    this.descendents = const [],
    required super.offset,
  });

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
