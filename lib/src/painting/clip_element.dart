import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';

class ClipRRectElement extends AncestorElement {
  final RRect clip;

  ClipRRectElement({
    required this.clip,
    required super.offset,
    required super.descendents,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClipRRectElement && runtimeType == other.runtimeType && clip == other.clip && super == (other);

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

class ClipRectElement extends AncestorElement {
  @override
  final Rect rect;

  ClipRectElement({
    required this.rect,
    required super.descendents,
    required super.offset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClipRectElement && runtimeType == other.runtimeType && rect == other.rect && super == (other);

  @override
  int get hashCode => rect.hashCode ^ super.hashCode;

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipRect(true, offset, rect.shift(this.offset), (context, offset) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }
}

class ClipPathElement extends AncestorElement {
  final Path clip;

  ClipPathElement({
    required this.clip,
    required super.descendents,
    required super.offset,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClipPathElement && runtimeType == other.runtimeType && rect == other.rect && super == (other);

  @override
  int get hashCode => rect.hashCode ^ super.hashCode;

  @override
  String toString() {
    return 'PathClipElement{clip: $clip, offset: $offset, descendents: $descendents}';
  }

  @override
  void paint(PaintingContext context, Offset offset, Paint shaderPaint) {
    context.pushClipPath(true, offset, rect, clip.shift(this.offset), (context, offset) {
      for (final descendent in descendents) {
        descendent.paint(context, offset, shaderPaint);
      }
    });
  }

  @override
  Rect get rect => clip.getBounds();
}
