import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';

/// Holds painting information for [RenderRRect]
///
/// clips [descendents] with a RRect clip
class ClipRRectElement extends AncestorElement {
  /// The clip to be used by the clip-layer
  final RRect clip;

  /// Default constructor
  ClipRRectElement({
    required this.clip,
    required super.offset,
    required super.descendents,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClipRRectElement &&
          runtimeType == other.runtimeType &&
          clip == other.clip &&
          super == (other);

  @override
  int get hashCode => clip.hashCode ^ super.hashCode;

  @override
  String toString() {
    return 'RRectClipElement{clip: $clip, offset: $offset, descendents: $descendents}';
  }

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipRRect(true, offset, clip.outerRect, clip, (context, _) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }

  @override
  Rect get rect => clip.outerRect;
}

/// Holds painting information for [RenderClipRect]
///
/// clips [descendents] with a Rect clip
class ClipRectElement extends AncestorElement {
  /// The clip to be used by the clip-layer
  @override
  final Rect rect;

  /// Default constructor
  ClipRectElement({
    required this.rect,
    required super.descendents,
    required super.offset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClipRectElement &&
          runtimeType == other.runtimeType &&
          rect == other.rect &&
          super == (other);

  @override
  int get hashCode => rect.hashCode ^ super.hashCode;

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipRect(true, offset, rect.shift(this.offset),
        (context, offset) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }
}

/// Holds painting information for [RenderClipPath] & [RenderClipOval]
///
/// clips [descendents] with a Path clip
class ClipPathElement extends AncestorElement {
  /// The clip to be used by the clip-layer
  final Path clip;

  /// Default constructor
  ClipPathElement({
    required this.clip,
    required super.descendents,
    required super.offset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClipPathElement &&
          runtimeType == other.runtimeType &&
          rect == other.rect &&
          super == (other);

  @override
  int get hashCode => rect.hashCode ^ super.hashCode;

  @override
  String toString() {
    return 'PathClipElement{clip: $clip, offset: $offset, descendents: $descendents}';
  }

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipPath(true, offset, rect, clip.shift(this.offset),
        (context, offset) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }

  @override
  Rect get rect => clip.getBounds();
}
