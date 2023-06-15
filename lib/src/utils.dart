import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension ChildernIterator on ContainerRenderObjectMixin {
  List<RenderObject> get children {
    final childrenList = <RenderObject>[];
    var child = firstChild;
    while (child != null) {
      childrenList.add(child);
      child = childAfter(child);
    }
    return childrenList;
  }
}

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

  T? findFirstChildOf<T>() {
    E? findType<E>(RenderObject box) {
      if (box is E && box != this) {
        return box as E;
      } else if (box is RenderObjectWithChildMixin && box.child != null) {
        return findType<E>(box.child!);
      } else if (box is ContainerRenderObjectMixin) {
        for (final child in box.children) {
          final res = findType<E>(child);
          if (res != null) {
            return res;
          }
        }
        return null;
      } else {
        return null;
      }
    }

    return findType<T>(this);
  }

  T? findChild<T>(T? Function(RenderObject object) predicate) {
    E? findType<E>(RenderObject box) {
      final res = predicate(box);
      if (res != null) {
        return res as E;
      } else if (box is RenderObjectWithChildMixin && box.child != null) {
        return findType<E>(box.child!);
      } else if (box is ContainerRenderObjectMixin) {
        for (final child in box.children) {
          final res = findType<E>(child);
          if (res != null) {
            return res;
          }
        }
        return null;
      } else {
        return null;
      }
    }

    return findType<T>(this);
  }

  T? findParentOfType<T extends RenderBox>() {
    E? findType<E>(AbstractNode box) {
      if (box is T) {
        return box as E;
      } else if (box.parent != null) {
        return findType<E>(box.parent!);
      }
      return null;
    }
    return findType<T>(this);
  }

  bool isChildOf(AbstractNode parent) {
    bool findType(AbstractNode box) {
      if (box == parent) {
        return true;
      } else if (box.parent != null) {
        return findType(box.parent!);
      }
      return false;
    }

    return findType(this);
  }

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

  bool get treatAsSliver => isInside<CustomScrollView>() && !isInside<SliverToBoxAdapter>();

  bool isInside<T extends Widget>() {
    return findAncestorWidget<T>() != null;
  }

  T? findAncestorWidget<T extends Widget>() {
    if (debugCreator is! DebugCreator) return null;
    final element = (debugCreator as DebugCreator).element;
    return element.findAncestorWidgetOfExactType<T>();
  }

  State<T>? findStateOfWidget<T extends StatefulWidget>() {
    if (debugCreator is! DebugCreator) return null;
    final element = (debugCreator as DebugCreator).element;
    return element.findAncestorStateOfType<State<T>>();
  }

  bool get isListTile => typeName == '_RenderListTile';
}
