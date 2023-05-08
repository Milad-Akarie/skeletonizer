import 'dart:developer';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeleton_builder/skeleton_builder.dart';
import 'package:skeleton_builder/src/builder/widget_describer.dart';

class SkeletonScanner extends SingleChildRenderObjectWidget {
  /// Creates a widget that isolates repaints.
  const SkeletonScanner({super.key, super.child, required this.onLayout});

  final ValueChanged<Widget?> onLayout;

  @override
  RenderSkeletonScanner createRenderObject(BuildContext context) => RenderSkeletonScanner(onLayout);
}

class RenderSkeletonScanner extends RenderProxyBox {
  /// Creates a repaint boundary around [child].
  RenderSkeletonScanner(this.onLayout, {RenderBox? child}) : super(child);

  final ValueChanged<Widget?> onLayout;

  Widget? rootWidget;

  void visitAll() {
    final res = rebuildWidget(child!);

    onLayout(res.widget);
    // log(res.describer!.bluePrint(4));
  }

  RebuildResult rebuildWidget(RenderObject? node) {
    if (node == null) return RebuildResult(null, null);
    // print(node.runtimeType);

    Widget? widget;
    WidgetDescriber? describer;
    if (node is RenderPadding) {
      final res = rebuildWidget(node.child);
      widget = res.widget;
      describer = res.describer;
      final isEmpty = node.padding.vertical == 0 && node.padding.horizontal == 0;
      if (!isEmpty && node.child?.isListTile != true) {
        widget = Padding(
          padding: node.padding,
          child: widget,
        );
        describer = SingleChildWidgetDescriber(
          name: 'Padding',
          properties: {'padding': 'EdgeInsets.all(8)'},
          child: describer,
        );
      }
    } else if (node is RenderSliverPadding) {
      final res = rebuildWidget(node.child);
      widget = res.widget;
      describer = res.describer;
      widget = Padding(
        padding: node.padding,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'Padding',
        properties: {'padding': 'EdgeInsets.all(8)'},
        child: res.describer,
      );
    } else if (node is RenderPositionedBox) {
      final res = rebuildWidget(node.child);
      widget = res.widget;
      describer = res.describer;
      widget = Align(
        alignment: node.alignment,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'Align',
        properties: {'alignment': 'Alignment.center'},
        child: res.describer,
      );
    } else if (node is RenderConstrainedBox) {
      var size = node.additionalConstraints.smallest;
      if (node.widget is SizedBox) {
        final sizedBox = (node.widget as SizedBox);
        size = Size(sizedBox.width ?? 0, sizedBox.height ?? 0);
      } else if (node.parent is RenderFlex) {
        final direction = (node.parent as RenderFlex).direction;
        if (direction == Axis.vertical && size.width.isInfinite) {
          size = Size(0, size.height);
        } else if (direction == Axis.horizontal && size.height.isInfinite) {
          size = Size(size.width, 0);
        }
      }

      final res = rebuildWidget(node.child);
      widget = SizedBox.fromSize(
        size: node.size,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'SizedBox.fromSize',
        properties: {'size': 'Size(0,0)'},
        child: res.describer,
      );
    } else if (node is RenderAspectRatio) {
      final res = rebuildWidget(node.child);
      widget = AspectRatio(
        aspectRatio: node.aspectRatio,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'AspectRatio',
        properties: {'aspectRatio': '1'},
        child: res.describer,
      );
    } else if (node is RenderFittedBox) {
      final res = rebuildWidget(node.child);
      widget = FittedBox(
        fit: node.fit,
        alignment: node.alignment,
        clipBehavior: node.clipBehavior,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'FittedBox',
        properties: {
          'fit': 'BoxFit.fill',
          'alignment': 'Alignment.center',
          'clipBehavior': 'Clip.none',
        },
        child: res.describer,
      );
    } else if (node is RenderRotatedBox) {
      final res = rebuildWidget(node.child);
      widget = RotatedBox(
        quarterTurns: node.quarterTurns,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'RotatedBox',
        properties: {'quarterTurns': '1'},
        child: res.describer,
      );
    } else if (node is RenderTransform) {
      // todo handle matrix value
      // print(node.debugDescribeChildren());
      final res = rebuildWidget(node.child);
      widget = Transform(
        transform: Matrix4.identity(),
        alignment: node.alignment,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'Transform',
        properties: {
          'transform': 'Matrix4.identity()',
          'alignment': 'Alignment.center',
        },
        child: res.describer,
      );
    } else if (node is RenderFlex) {
      final children = [for (final child in node.children) rebuildWidget(child)];
      widget = Flex(
        direction: node.direction,
        mainAxisAlignment: node.mainAxisAlignment,
        crossAxisAlignment: node.crossAxisAlignment,
        mainAxisSize: node.mainAxisSize,
        children: List.of(children.map((e) => e.widget!)),
      );
      describer = MultiChildWidgetDescriber(
        name: 'Flex',
        properties: {
          'direction': 'Axis.vertical',
          'mainAxisAlignment': 'MainAxisAlignment.center',
          'crossAxisAlignment': 'CrossAxisAlignment.center',
          'mainAxisSize': 'MainAxisSize.min',
        },
        children: List.of(children.map((e) => e.describer!)),
      );
    } else if (node is RenderStack) {
      final children = [for (final child in node.children) rebuildWidget(child)];
      widget = Stack(
        fit: node.fit,
        alignment: node.alignment,
        children: List.of(children.map((e) => e.widget!)),
      );
      describer = MultiChildWidgetDescriber(
          name: 'Stack',
          properties: {
            'fit': 'node.fit',
            'alignment': 'node.alignment',
          },
          children: List.of(
            children.map((e) => e.describer!),
          ));
    } else if (node is RenderCustomMultiChildLayoutBox) {
      if (node.delegate.toString() == '_ScaffoldLayout') {
        final scaffoldSlots = <String, RenderObject>{
          for (final c in node.children.where((e) => e.parentData is MultiChildLayoutParentData))
            (c.parentData as MultiChildLayoutParentData).id.toString(): c,
        };
        final appBarRes = rebuildWidget(scaffoldSlots['_ScaffoldSlot.appBar']);
        final bodyRes = rebuildWidget(scaffoldSlots['_ScaffoldSlot.body']);
        final appBar = appBarRes.widget;
        if (scaffoldSlots.isNotEmpty) {
          widget = Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar == null
                ? null
                : PreferredSize(
                    preferredSize: appBar is SizedBox ? Size.fromHeight(appBar.height!) : Size.zero,
                    child: appBar,
                  ),
            body: bodyRes.widget,
          );

          describer = SlottedWidgetDescriber(
            name: 'Scaffold',
            properties: {
              'backgroundColor': 'Colors.transparent',
            },
            slots: {
              'appBar': appBarRes.describer,
              'body': bodyRes.describer,
            },
          );
        }
      } else if (node.delegate.toString() == '_ToolbarLayout') {
        final appBarSlots = <String, RenderObject>{
          for (final c in node.children.where((e) => e.parentData is MultiChildLayoutParentData))
            (c.parentData as MultiChildLayoutParentData).id.toString(): c,
        };

        final titleRes = rebuildWidget(appBarSlots['_ToolbarSlot.middle']);
        final leadingRes = rebuildWidget(appBarSlots['_ToolbarSlot.leading']);
        if (appBarSlots.isNotEmpty) {
          widget = AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: titleRes.widget,
            leading: leadingRes.widget,
            // actions: [
            //   for(final child in (appBarSlots['_ToolbarSlot.trailing']  as RenderFlex?)?.children ?? [])
            //     rebuildWidget(child)!,
            // ],
          );
          describer = SlottedWidgetDescriber(
            name: 'AppBar',
            slots: {
              'title': titleRes.describer,
              'leading': leadingRes.describer,
            },
          );
        }
      }
    } else if (node is RenderSliverList) {
      final children = [for (final child in node.children.take(1)) rebuildWidget(child)];
      widget = ListView(
        children: List.of(children.map((e) => e.widget!)),
      );
      describer = MultiChildWidgetDescriber(
        name: 'ListView',
        properties: {
          'scrollDirection': 'Axis.vertical',
        },
        children: List.of(children.map((e) => e.describer!)),
      );
    } else if (node is RenderPhysicalShape) {
      final isButton = node.findParentWithName('_RenderInputPadding') != null;
      final res = isButton ? RebuildResult() : rebuildWidget(node.child);
      final shape = (node.clipper as ShapeBorderClipper).shape;
      widget = BoxBone.container(
        clipBehavior: node.clipBehavior,
        elevation: node.elevation,
        shape: shape,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'BoxBone.container',
        properties: {
          'clipBehavior': 'Clip.none',
          'shape': 'ShapeBorderClipper()',
        },
        child: res.describer,
      );
    } else if (node is RenderImage) {
      widget = const BoxBone();
      describer = const SingleChildWidgetDescriber(
        name: 'BoxBone',
      );
    } else if (node is RenderCustomPaint) {
      var size = node.size;
      if (node.child != null) {
        final res = rebuildWidget(node.child);
        widget = res.widget;
        describer = res.describer;
      } else if (node.isWidget<Switch>()) {
        size = const Size(32, 16);
        widget = SizedBox.fromSize(
          size: node.size,
          child: Center(
            child: Container(
              color: Colors.green.withOpacity(.5),
              width: size.width,
              height: size.height,
            ),
          ),
        );
      } else {
        widget = Container(
          color: Colors.green.withOpacity(.5),
          width: size.width,
          height: size.height,
        );
      }
    } else if (node is RenderParagraph) {
      final painter = TextPainter(
        text: node.text,
        textAlign: node.textAlign,
        textDirection: node.textDirection,
        textScaleFactor: node.textScaleFactor,
      )..layout(maxWidth: node.constraints.maxWidth);
      final fontSize = (node.text.style?.fontSize ?? 14) * node.textScaleFactor;
      final lineCount = (painter.size.height / painter.preferredLineHeight);
      widget = TextBone(
        lineHeight: painter.preferredLineHeight,
        textAlign: node.textAlign,
        textDirection: node.textDirection,
        fontSize: fontSize,
        lineLength: lineCount * node.textSize.width,
        maxLines: node.maxLines,
        width: lineCount == 1 ? node.textSize.width : null,
      );

      describer = const SingleChildWidgetDescriber(
        name: 'TextBone',
        properties: {
          'width': '0',
          'height': '0',
        },
      );
    } else if (node is RenderDecoratedBox) {
      final boxDecoration =
          node.decoration is BoxDecoration ? (node.decoration as BoxDecoration) : const BoxDecoration();

      final ShapeBorder shape;
      final borderSide = boxDecoration.border?.top ?? BorderSide.none;
      if (boxDecoration.shape == BoxShape.circle) {
        shape = CircleBorder(side: borderSide);
      } else {
        shape = RoundedRectangleBorder(
          borderRadius: boxDecoration.borderRadius ?? BorderRadius.zero,
          side: borderSide,
        );
      }
      final res = rebuildWidget(node.child);
      widget = BoxBone.container(
        shape: shape,
        width: node.constraints.specificWidth,
        height: node.constraints.specificHeight,
        child: res.widget,
      );
      describer = const SingleChildWidgetDescriber(
        name: 'Container',
        properties: {
          'width': '0',
          'height': '0',
        },
      );
    } else if (node.isListTile) {
      final labeledNodes = <String, RenderObject>{
        for (final child in node.debugDescribeChildren())
          if (child.name != null && child.value is RenderObject) child.name!: child.value as RenderObject,
      };

      final contentPadding = (node.parent is RenderPadding) ? (node.parent as RenderPadding).padding : null;

      if (labeledNodes.isNotEmpty) {
        final titleRes = rebuildWidget(labeledNodes['title']);
        final subtitleRes = rebuildWidget(labeledNodes['subtitle']);
        final trailingRes = rebuildWidget(labeledNodes['trailing']);
        final leadingRes = rebuildWidget(labeledNodes['leading']);
        widget = ListTile(
          title: titleRes.widget,
          subtitle: subtitleRes.widget,
          trailing: trailingRes.widget,
          leading: leadingRes.widget,
          contentPadding: contentPadding,
        );
        describer = SlottedWidgetDescriber(
          name: 'ListTile',
          properties: {
            'contentPadding': 'contentPadding',
          },
          slots: {
            'title': titleRes.describer,
            'subtitle': subtitleRes.describer,
            'trailing': trailingRes.describer,
            'leading': leadingRes.describer,
          },
        );
      }
    } else if (node is RenderObjectWithChildMixin) {
      final res = rebuildWidget(node.child);
      if (node.typeName == '_RenderColoredBox') {
        widget = ColoredBox(
          color: Colors.blue.withOpacity(.4),
          child: res.widget,
        );
        describer = SingleChildWidgetDescriber(
          name: 'ColoredBox',
          child: res.describer,
        );
      } else if (node.typeName == '_RenderInputPadding') {
        if (node.child?.parentData is BoxParentData) {
          final boxData = node.child!.parentData as BoxParentData;
          widget = Padding(
            padding: EdgeInsets.symmetric(
              vertical: boxData.offset.dy,
              horizontal: boxData.offset.dx,
            ),
            child: res.widget,
          );
          describer = SingleChildWidgetDescriber(
            name: 'Padding',
            properties: {'padding': 'EdgeInsets.zero'},
            child: res.describer,
          );
        }
      } else {
        widget = res.widget;
        describer = res.describer;
      }
    } else if (node is ContainerRenderObjectMixin) {
      final res = rebuildWidget(node.firstChild);
      widget = res.widget;
      describer = res.describer;
    } else if (node is CustomMultiChildLayout) {
      print('Here');
    } else if (node.typeName == '_RenderDecoration') {
      widget = ColoredBox(
        color: Colors.red.withOpacity(1),
      );
      describer = const SingleChildWidgetDescriber(
        name: 'ColoredBox',
      );
    } else {
      print(node.runtimeType);
    }

    if (widget != null) {
      if (node.parentData is FlexParentData) {
        final data = node.parentData as FlexParentData;
        if (data.flex != null) {
          widget = Expanded(flex: data.flex!, child: widget);
          describer = SingleChildWidgetDescriber(
            name: 'Expanded',
            properties: {'flex': 'data.flex!'},
            child: describer,
          );
        }
      } else if (node.parentData is StackParentData) {
        final data = node.parentData as StackParentData;
        if (data.isPositioned) {
          widget = Positioned(
              top: data.top,
              bottom: data.bottom,
              left: data.left,
              right: data.right,
              width: data.width,
              height: data.height,
              child: widget);

          describer = SingleChildWidgetDescriber(
            name: 'Positioned',
            properties: {
              'top': 'data.top',
              'bottom': 'data.bottom',
              'left': 'data.left',
              'right': 'data.right',
              'width': 'data.width',
              'height': 'data.height',
            },
            child: describer,
          );
        }
      }
    }

    return RebuildResult(widget, describer);
  }
}

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

extension RenderObjectX on RenderObject {
  String get typeName => runtimeType.toString();

  Widget? get widget => debugCreator is DebugCreator ? (debugCreator as DebugCreator).element.widget : null;

  bool get isMaterialButton {
    return isWidget<ElevatedButton>() ||
        isWidget<TextButton>() ||
        isWidget<OutlinedButton>() ||
        isWidget<FilledButton>();
  }

  T? findFirstChildOf<T extends RenderBox>() {
    E? findType<E>(RenderObjectWithChildMixin box) {
      if (box is T) {
        return box as E;
      } else if (box.child is RenderObjectWithChildMixin) {
        return findType<E>(box.child as RenderObjectWithChildMixin);
      }
      return null;
    }

    if (this is RenderObjectWithChildMixin) {
      return findType<T>(this as RenderObjectWithChildMixin);
    }
    return null;
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

  bool isWidget<T extends Widget>() {
    if (debugCreator is! DebugCreator) return false;
    final element = (debugCreator as DebugCreator).element;
    return element.findAncestorWidgetOfExactType<T>() != null;
  }

  bool get isListTile => typeName == '_RenderListTile';
}

extension BoxConstrainsX on BoxConstraints {
  bool get hasSpecificWidth => maxWidth == minWidth;

  bool get hasSpecificHeight => maxHeight == minHeight;

  double? get specificWidth => hasSpecificWidth ? maxWidth : null;

  double? get specificHeight => hasBoundedHeight ? maxHeight : null;
}
