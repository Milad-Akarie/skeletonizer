import 'package:flutter/rendering.dart';
import 'package:skeletonizer/src/painting/paintable_element.dart';

class RRectClipElement extends AncestorElement {
  final RRect clip;

  RRectClipElement({
    required this.clip,
    required super.offset,
    required super.descendents,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RRectClipElement && runtimeType == other.runtimeType && clip == other.clip && super == (other);

  @override
  int get hashCode => clip.hashCode ^ super.hashCode;

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

class RectClipElement extends AncestorElement {
  @override
  final Rect rect;

  RectClipElement({
    required this.rect,
    required super.descendents,
    required super.offset,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is RectClipElement && runtimeType == other.runtimeType && rect == other.rect && super == (other);

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

class PathClipElement extends AncestorElement {
  final Path clip;

  PathClipElement({
    required this.clip,
    required super.descendents,
    required super.offset,
  });


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is PathClipElement && runtimeType == other.runtimeType && clip == other.clip && super == (other);

  @override
  int get hashCode => clip.hashCode ^ super.hashCode;

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

