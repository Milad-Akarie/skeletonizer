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

extension RenderBoxX on RenderBox {
  double get assignableHeight => constraints.hasTightHeight ? constraints.maxHeight : size.height;

  double get assignableWidth => constraints.hasTightWidth ? constraints.maxWidth : size.width;
}

extension BoxConstrainsX on BoxConstraints {
  bool get isUnconstrained =>
      (minWidth == 0 && maxWidth == double.infinity && minHeight == 0 && maxHeight == double.infinity);
}

extension RenderObjectX on RenderObject {
  String get typeName => runtimeType.toString();

  Widget? get widget => debugCreator is DebugCreator ? (debugCreator as DebugCreator).element.widget : null;

  Offset globalOffsetFrom(RenderObject ancestor) {
    final data = parentData;
    var offset = Offset.zero;
    if (this == ancestor) return offset;
    if (data is BoxParentData) {
      offset = offset + data.offset;
    } else if (data is StackParentData) {
      offset = offset + data.offset;
    } else if (data is MultiChildLayoutParentData) {
      offset = offset + data.offset;
    } else if (data is SliverPhysicalParentData) {
      offset = offset + data.paintOffset;
    }  else if(data is SliverMultiBoxAdaptorParentData){
      offset = offset + Offset(0,data.layoutOffset!);
    }else{
      print(data);
    }
    if (parent is RenderObject) {
      offset = offset + (parent as RenderObject).globalOffsetFrom(ancestor);
    }
    return offset;
  }

  Offset globalOffset(RenderObject ancestor) => MatrixUtils.transformPoint(
        getTransformToIgnoringRenderTransforms(ancestor),
        Offset.zero,
      );

  Matrix4 getTransformToIgnoringRenderTransforms(RenderObject? ancestor) {
    final bool ancestorSpecified = ancestor != null;
    assert(attached);
    if (ancestor == null) {
      final AbstractNode? rootNode = owner!.rootNode;
      if (rootNode is RenderObject) {
        ancestor = rootNode;
      }
    }
    final List<RenderObject> renderers = <RenderObject>[];
    for (RenderObject renderer = this; renderer != ancestor; renderer = renderer.parent! as RenderObject) {
      renderers.add(renderer);

      assert(renderer.parent != null); // Failed to find ancestor in parent chain.
    }
    if (ancestorSpecified) {
      renderers.add(ancestor!);
    }
    final Matrix4 transform = Matrix4.identity();
    var point = Offset.zero;
    for (int index = renderers.length - 1; index > 0; index -= 1) {
      renderers[index].applyPaintTransform(renderers[index - 1], transform);
      print('${renderers[index].runtimeType}: ${point = MatrixUtils.transformPoint(transform, point)}');
    }
    print(renderers.map((e) => e.runtimeType));
    print('AllTrans ${MatrixUtils.transformPoint(transform, Offset.zero)}');
    return transform;
  }

  bool get isMaterialButton {
    return isInside<ElevatedButton>() ||
        isInside<TextButton>() ||
        isInside<OutlinedButton>() ||
        isInside<FilledButton>();
  }

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

extension RenderCustomMultiChildLayoutBoxX on RenderCustomMultiChildLayoutBox {
  bool buildsAppBar(RenderObject parentNode) =>
      delegate.toString() == '_ToolbarLayout' && (depth - parentNode.depth) == 7;

  bool buildsAScaffold(RenderObject parentNode) =>
      delegate.toString() == '_ScaffoldLayout' && (depth - parentNode.depth) == 2;
}
