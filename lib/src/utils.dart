import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Holds helper methods on [Rect]
extension RectX on Rect {
  /// Creates
  RRect toRRect(BorderRadius borderRadius) {
    return borderRadius.toRRect(this);
  }

  /// Whether the given [rect] intersects with this rect
  bool intersectsWith(Rect rect) {
    return contains(rect.topLeft) ||
        contains(rect.topRight) ||
        contains(rect.bottomLeft) ||
        contains(rect.bottomRight);
  }
}

/// Holds helper methods on [RenderObject]
extension RenderObjectX on RenderObject {
  /// Whether this render object has non-empty parent data
  bool get hasParentData => parentData.runtimeType != ParentData;

  /// The widget that built this render object
  Widget? get widget => debugCreator is DebugCreator
      ? (debugCreator as DebugCreator).element.widget
      : null;


  /// Finds the first [RenderSemanticsAnnotations] in above this render object
  RenderSemanticsAnnotations? findFirstAnnotation() {
    RenderSemanticsAnnotations? find(AbstractNode box) {
      if (box is RenderSemanticsAnnotations) {
        return box;
      } else if (box.parent != null) {
        return find(box.parent!);
      }
      return null;
    }

    return find(this);
  }
}
