import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension RectX on Rect {
  RRect toRRect(BorderRadius borderRadius) {
    return RRect.fromRectAndCorners(
      this,
      topLeft: borderRadius.topLeft,
      topRight: borderRadius.topRight,
      bottomLeft: borderRadius.bottomLeft,
      bottomRight: borderRadius.bottomRight,
    );
  }

  bool containsRect(Rect rect){

    if(rect.left < left || rect.right > right) return false;
     if(rect.top < top || rect.bottom > bottom) return false;
     return true;
  }
}


extension RenderObjectX on RenderObject {
  String get typeName => runtimeType.toString();

  bool get hasParentData =>  parentData.runtimeType != ParentData;

  Widget? get widget => debugCreator is DebugCreator ? (debugCreator as DebugCreator).element.widget : null;

  AbstractNode? findParentWithName(String name) {
    AbstractNode? find(AbstractNode box) {
      if (box.runtimeType.toString() == name) {
        return box;
      } else if (box.parent != null) {
        return find(box.parent!);
      }
      return null;
    }

    return find(this);
  }

}
