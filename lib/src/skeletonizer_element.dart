import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeleton_builder/skeleton_builder.dart';
import 'package:skeleton_builder/src/builder/editors/box_bone_editor.dart';
import 'package:skeleton_builder/src/builder/editors/editor_config.dart';
import 'package:skeleton_builder/src/builder/editors/text_bone_editor.dart';
import 'package:skeleton_builder/src/builder/value_describers.dart';
import 'package:skeleton_builder/src/builder/widget_describer.dart';
import 'package:collection/collection.dart';
import 'package:skeleton_builder/src/helper_utils.dart';
import 'package:gap/gap.dart';

class SkeletonizerElement extends SingleChildRenderObjectWidget {
  const SkeletonizerElement({super.key, super.child, required this.onSkeletonReady});

  final ValueChanged<Widget?> onSkeletonReady;

  @override
  RenderSkeletonizer createRenderObject(BuildContext context) {
    return RenderSkeletonizer(
      onSkeletonReady,
      textDirection: Directionality.of(context),
      theme: Theme.of(context),
    );
  }

  @override
  void updateRenderObject(BuildContext context, covariant RenderSkeletonizer renderObject) {
    super.updateRenderObject(context, renderObject);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      // renderObject._skeletonize();
    });
  }
}

class RenderSkeletonizer extends RenderProxyBox {
  RenderSkeletonizer(
    this.onSkeletonReady, {
    required this.textDirection,
    required this.theme,
    RenderBox? child,
  }) : super(child);
  final TextDirection textDirection;
  final ThemeData theme;
  final ValueChanged<Widget?> onSkeletonReady;

  double _skeletonizedAtWidth = 0;

  @override
  void performLayout() {
    super.performLayout();
    if (_skeletonizedAtWidth != constraints.maxWidth) {
      _skeletonizedAtWidth = constraints.maxWidth;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _skeletonize();
      });
    }
  }

  void _skeletonize() {
    _bones.clear();
    skeletonize(child!);
    onSkeletonReady(Stack(children: _bones));
  }

  final _bones = <Widget>[];

  void skeletonize(RenderObject node) {
    node.visitChildren((child) {
      Widget? widget;
      if (child is RenderBox) {
        if (child is RenderParagraph) {
          widget = _buildTextBone(child);
        } else if (child is RenderDecoratedBox) {
          widget = _buildDecoratedBox(child);
          child.paintsChild(child);
        }

       print(  child.findParentOfType<RenderClipRRect>());

        if (widget != null) {
          final offset = child.localToGlobal(Offset.zero, ancestor: this);
          _bones.add(
            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: widget,
            ),
          );
        }
      }
      skeletonize(child);
    });
  }




  Widget _buildTextBone(RenderParagraph node) {
    final painter = TextPainter(
      text: node.text,
      textAlign: node.textAlign,
      textDirection: node.textDirection,
      textScaleFactor: node.textScaleFactor,
    )..layout(maxWidth: node.constraints.maxWidth);
    final fontSize = (node.text.style?.fontSize ?? 14) * node.textScaleFactor;
    final lineCount = (painter.size.height / painter.preferredLineHeight);

    return TextBone(
      lineHeight: painter.preferredLineHeight,
      textAlign: node.textAlign,
      textDirection: node.textDirection,
      fontSize: fontSize,
      lineLength: lineCount * painter.width,
      maxLines: node.maxLines,
      borderRadius: 8,
      width: painter.width,
    );
  }

  Widget _buildDecoratedBox(RenderDecoratedBox node) {
    final boxDecoration = node.decoration is BoxDecoration ? (node.decoration as BoxDecoration) : const BoxDecoration();

    final ShapeBorder shape;
    final borderSide = (boxDecoration.border?.top ?? BorderSide.none).copyWith(
      color: Colors.green,
    );

    if (boxDecoration.shape == BoxShape.circle) {
      shape = CircleBorder(side: borderSide);
    } else {
      shape = RoundedRectangleBorder(
        borderRadius: boxDecoration.borderRadius ?? BorderRadius.zero,
        side: borderSide,
      );
    }
    final canBeContainer = false;

    return BoxBone(
      borderRadius: boxDecoration.borderRadius,
      width: node.size.width,
      height: node.size.height,
      shape: boxDecoration.shape,
    );

    //  SkeletonContainer(
    //   shape: shape,
    //   width: node.assignableWidth,
    //   height: node.assignableHeight,
    //   // child: res.widget,
    // );
    //
  }

  Map<String, Object?> debugPropertiesMap(Diagnosticable node) {
    return Map.fromEntries(
      debugProperties(node).where((e) => e.name != null).map(
            (e) => MapEntry(e.name!, e.value),
          ),
    );
  }

  List<DiagnosticsNode> debugProperties(Diagnosticable node) {
    final builder = DiagnosticPropertiesBuilder();
    node.debugFillProperties(builder);
    return builder.properties;
  }

  T? debugValueOfType<T>(RenderObject node) {
    return debugProperties(node).firstWhereOrNull((e) => e.value is T)?.value as T?;
  }

  Widget? rebuildWidget(RenderObject? node) {
    if (node == null) return null;

    Widget? widget;

    // print(node.runtimeType);
    if (node is RenderBox && node.isInside<Divider>()) {
      final divider = node.findAncestorWidget<Divider>()!;
      final height = divider.thickness ?? theme.dividerTheme.thickness ?? 1;
      final padding = EdgeInsetsDirectional.only(
        start: divider.indent ?? 0,
        end: divider.endIndent ?? 0,
      );
      widget = SizedBox(
        height: node.size.height,
        child: BoxBone(
          alignment: Alignment.center,
          height: height,
          width: double.infinity,
          padding: padding,
        ),
      );
    } else if (node.isInside<IconButton>()) {
      final renderConstrains = node.findFirstChildOf<RenderConstrainedBox>();
      final size = renderConstrains?.size ?? const Size(48, 48);
      final icon = node.findFirstChildOf<RenderParagraph>();

      widget = SizedBox(
        width: size.width,
        height: size.height,
        child: BoxBone(
          alignment: Alignment.center,
          width: icon?.size.width ?? 24,
          height: icon?.size.height ?? 24,
          borderRadius: BorderRadius.circular(8),
        ),
      );
    } else if (node is RenderRotatedBox) {
      widget = RotatedBox(
        quarterTurns: node.quarterTurns,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderTransform) {
      final matrix4 = debugValueOfType<Matrix4>(node);
      final childWidget = rebuildWidget(node.child);

      if (childWidget != null) {
        widget = Transform(
          transform: matrix4 ?? Matrix4.identity(),
          alignment: node.alignment,
          origin: node.origin,
          child: childWidget,
        );
      }
    } else if (node is RenderClipPath) {
      widget = ClipPath(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderClipRect) {
      widget = ClipRect(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderClipOval) {
      widget = ClipOval(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderClipRRect) {
      widget = ClipRRect(
        borderRadius: node.borderRadius,
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderPhysicalModel) {
      widget = SkeletonContainer(
        elevation: node.elevation,
        child: rebuildWidget(node.child),
      );
    } else if (node is RenderPhysicalShape) {
      final isChip = node.isInside<RawChip>();
      final isButton = node.findParentWithName('_RenderInputPadding') != null || isChip;
      final shape = (node.clipper as ShapeBorderClipper).shape;
      BoxShape? boxShape;
      BorderRadiusGeometry? borderRadius;
      if (shape is RoundedRectangleBorder) {
        borderRadius = shape.borderRadius;
      } else if (shape is StadiumBorder) {
        borderRadius = BorderRadius.circular(node.size.height);
      } else if (shape is CircleBorder) {
        boxShape = BoxShape.circle;
      }

      if (true) {
        final width = isButton ? node.size.width : double.infinity;
        widget = BoxBone(
          width: width,
          height: node.size.height,
          shape: boxShape ?? BoxShape.rectangle,
          borderRadius: borderRadius,
          // alignment: isChip ? Alignment.center : null,
        );
      } else {
        widget = SkeletonContainer(
          clipBehavior: node.clipBehavior,
          elevation: node.elevation,
          shape: shape,
          child: rebuildWidget(node.child),
        );
      }
    } else if (node is RenderImage) {
      widget = const BoxBone();
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
        lineLength: lineCount * painter.width,
        maxLines: node.maxLines,
        borderRadius: 8,
        width: painter.width,
      );
    } else if (node is RenderDecoratedBox) {
      final boxDecoration =
          node.decoration is BoxDecoration ? (node.decoration as BoxDecoration) : const BoxDecoration();

      final ShapeBorder shape;
      final borderSide = (boxDecoration.border?.top ?? BorderSide.none).copyWith(
        color: Colors.green,
      );

      if (boxDecoration.shape == BoxShape.circle) {
        shape = CircleBorder(side: borderSide);
      } else {
        shape = RoundedRectangleBorder(
          borderRadius: boxDecoration.borderRadius ?? BorderRadius.zero,
          side: borderSide,
        );
      }
      final res = rebuildWidget(node.child);
      final canBeContainer = false;
      if (!canBeContainer) {
        widget = BoxBone(
          borderRadius: boxDecoration.borderRadius,
          width: node.size.width,
          height: node.size.height,
          shape: boxDecoration.shape,
        );
      } else {
        widget = SkeletonContainer(
          shape: shape,
          width: node.assignableWidth,
          height: node.assignableHeight,
          child: res,
        );
      }
    } else if (node is RenderObjectWithChildMixin) {
      widget = rebuildWidget(node.child);
    } else if (node is ContainerRenderObjectMixin) {
      widget = rebuildWidget(node.firstChild);
    } else if (node is CustomMultiChildLayout) {
      print('Here');
    } else if (node.typeName == '_RenderDecoration') {
      widget = const BoxBone();
    } else {
      print(node.runtimeType);
    }

    return widget;
  }
}
