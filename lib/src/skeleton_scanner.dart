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

class SkeletonScanner extends SingleChildRenderObjectWidget {
  const SkeletonScanner({super.key, super.child, required this.onPreviewReady});

  final ValueChanged<Widget?> onPreviewReady;

  @override
  RenderSkeletonScanner createRenderObject(BuildContext context) {
    return RenderSkeletonScanner(
      onPreviewReady,
      textDirection: Directionality.of(context),
      theme: Theme.of(context),
    );
  }
}

class RenderSkeletonScanner extends RenderProxyBox {
  /// Creates a repaint boundary around [child].
  RenderSkeletonScanner(
    this.onPreview, {
    required this.textDirection,
    required this.theme,
    RenderBox? child,
  }) : super(child);
  final TextDirection textDirection;
  final ThemeData theme;
  final ValueChanged<Widget?> onPreview;
  final _textBoneConfigs = <RenderParagraph, TextBoneConfig>{};
  final _boxBoneConfigs = <RenderObject, BoxBoneConfig>{};

  WidgetDescriber? rebuild({bool preview = false, bool reset = false}) {
    if (reset) {
      _textBoneConfigs.clear();
      _boxBoneConfigs.clear();
    }
    final res = rebuildWidget(child!);
    // print(res.describer?.bluePrint(4));
    if (preview) {
      onPreview(res.widget);
      return null;
    } else {
      return res.describer;
    }
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

  RebuildResult rebuildWidget(RenderObject? node) {
    if (node == null) return RebuildResult();

    Widget? widget;
    WidgetDescriber? describer;
    bool skipParent = false;

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
      describer = SingleChildWidgetDescriber(
        name: 'SizedBox',
        properties: {
          'height': node.size.height.describe,
        },
        child: SingleChildWidgetDescriber(
          name: 'BoxBone',
          properties: {
            'alignment': Alignment.center,
            'width': double.infinity.describe,
            'height': height.describe,
            if (padding.horizontal > 0) 'padding': padding.describe,
          },
        ),
      );
    } else if (node.isInside<IconButton>()) {
      final renderConstrains = node.findFirstChildOf<RenderConstrainedBox>();
      final size = renderConstrains?.size ?? const Size(48, 48);
      final icon = node.findFirstChildOf<RenderParagraph>();
      if (node.parent is RenderConstrainedBox) {
        skipParent = true;
      }
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
      describer = SingleChildWidgetDescriber(
        name: 'SizedBox',
        properties: {
          'width': size.width.describe,
          'height': size.height.describe,
        },
        child: SingleChildWidgetDescriber(
          name: 'BoxBone',
          properties: {
            'alignment': Alignment.center,
            'borderRadius': 'BorderRadius.circular(8)',
            'width': (icon?.size.width ?? 24).describe,
            'height': (icon?.size.height ?? 24).describe,
          },
        ),
      );
    } else if (node is RenderPadding) {
      final res = rebuildWidget(node.child);
      widget = res.widget;
      describer = res.describer;
      if (!res.skipParent) {
        final isEmpty = node.padding.vertical == 0 && node.padding.horizontal == 0;
        if (!isEmpty && node.child?.isListTile != true) {
          widget = Padding(
            padding: node.padding,
            child: widget,
          );
          describer = SingleChildWidgetDescriber(
            name: 'Padding',
            properties: {'padding': node.padding.describe},
            child: describer,
          );
        }
      }
    } else if (node is RenderSliverPadding) {
      final res = rebuildWidget(node.child);
      widget = res.widget;
      describer = res.describer;
      if (!res.skipParent) {
        widget = SliverPadding(
          padding: node.padding,
          sliver: res.widget,
        );
        describer = SingleChildWidgetDescriber(
          name: 'Padding',
          properties: {'padding': 'EdgeInsets.all(8)'},
          child: res.describer,
        );
      }
    } else if (node is RenderPositionedBox) {
      final res = rebuildWidget(node.child);
      widget = res.widget;
      describer = res.describer;

      if (!res.skipParent) {
        final isCenter = node.alignment == Alignment.center;
        widget = Align(
          alignment: node.alignment,
          child: res.widget,
        );
        describer = SingleChildWidgetDescriber(
          name: isCenter ? 'Center' : 'Align',
          properties: {if (!isCenter) 'alignment': '${node.alignment}'},
          child: res.describer,
        );
      }
    } else if (node is RenderConstrainedBox) {
      final res = rebuildWidget(node.child);
      widget = res.widget;
      describer = res.describer;
      final constraints = node.additionalConstraints;
      if (!res.skipParent && !constraints.isUnconstrained) {
        if (constraints.isTight ||
            (constraints.hasTightWidth && !constraints.hasBoundedHeight) ||
            (constraints.hasTightHeight && !constraints.hasBoundedWidth)) {
          final width = constraints.hasTightWidth ? constraints.maxWidth : null;
          var height = constraints.hasTightHeight ? constraints.maxHeight : null;

          widget = SizedBox(
            height: height,
            width: width,
            child: res.widget,
          );
          describer = SingleChildWidgetDescriber(
            name: 'SizedBox',
            properties: {
              if (width != null) 'width': width.describe,
              if (height != null) 'height': height.describe,
            },
            child: res.describer,
          );
        } else {
          final maxWidth = constraints.maxWidth == double.infinity ? null : constraints.maxWidth;
          final maxHeight = constraints.maxHeight == double.infinity ? null : constraints.maxHeight;
          final minHeight = constraints.minHeight == 0 ? null : constraints.minHeight;
          final minWidth = constraints.minWidth == 0 ? null : constraints.minWidth;

          widget = ConstrainedBox(
            constraints: node.additionalConstraints,
            child: res.widget,
          );
          describer = SingleChildWidgetDescriber(
            name: 'ConstrainedBox',
            properties: {
              if (maxWidth != null) 'maxWidth': maxWidth.describe,
              if (maxHeight != null) 'maxHeight': maxHeight.describe,
              if (minWidth != null) 'minWidth': minWidth.describe,
              if (minHeight != null) 'minHeight': minHeight.describe,
            },
            child: res.describer,
          );
        }
      }
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
    } else if (node.typeName == 'RenderGap') {
      final props = debugPropertiesMap(node);
      final mainAxisExt = props['mainAxisExtent'] as double;
      final crossAxisExt = props['crossAxisExtent'] as double?;
      if (props['color'] != null) {
        double? height = mainAxisExt;
        double? width = crossAxisExt;
        var dir = Axis.vertical;
        if (node.parent is RenderFlex) {
          dir = (node.parent as RenderFlex).direction;
        }
        if (dir == Axis.horizontal) {
          height = crossAxisExt;
          width = mainAxisExt;
        }
        widget = BoxBone(
          height: height,
          width: width,
        );
        describer = SingleChildWidgetDescriber(
          name: 'BoxBone',
          properties: {
            if (width != null) 'width': width.describe,
            if (height != null) 'height': height.describe,
          },
        );
      } else {
        widget = node.widget;
        describer = SingleChildWidgetDescriber(
          name: 'Gap',
          posProperties: [mainAxisExt.describe],
          properties: {
            if (crossAxisExt != null) 'crossAxisExtent': crossAxisExt.describe,
          },
        );
      }
    } else if (node.typeName == 'RenderSliverGap') {
      widget = node.widget;
      final props = debugPropertiesMap(node);
      describer = describer = SingleChildWidgetDescriber(
        name: 'SliverGap',
        posProperties: [(props['mainAxisExtent'] as double).describe],
      );
    } else if (node is RenderIntrinsicWidth) {
      final res = rebuildWidget(node.child);
      widget = IntrinsicWidth(
        stepWidth: node.stepWidth,
        stepHeight: node.stepHeight,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'IntrinsicWidth',
        properties: {
          'stepWidth': 'node.stepWidth',
          'stepHeight': 'node.stepHeight',
        },
        child: res.describer,
      );
    } else if (node is RenderIntrinsicHeight) {
      final res = rebuildWidget(node.child);
      widget = IntrinsicHeight(child: res.widget);
      describer = SingleChildWidgetDescriber(
        name: 'IntrinsicHeight',
        child: res.describer,
      );
    } else if (node is RenderFractionallySizedOverflowBox) {
      final res = rebuildWidget(node.child);
      widget = FractionallySizedBox(
        widthFactor: node.widthFactor,
        heightFactor: node.heightFactor,
        alignment: node.alignment,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'FractionallySizedBox',
        properties: {
          'widthFactor': 'node.widthFactor',
          'heightFactor': 'node.heightFactor',
          'alignment': 'node.alignment',
        },
        child: res.describer,
      );
    } else if (node is RenderLimitedBox) {
      final res = rebuildWidget(node.child);
      widget = LimitedBox(
        maxWidth: node.maxWidth,
        maxHeight: node.maxHeight,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'LimitedBox',
        properties: {
          'maxWidth': 'node.maxWidth',
          'maxHeight': 'node.maxHeight',
        },
        child: res.describer,
      );
    } else if (node is RenderConstrainedOverflowBox) {
      final res = rebuildWidget(node.child);
      widget = OverflowBox(
        maxWidth: node.maxWidth,
        maxHeight: node.maxHeight,
        minWidth: node.minWidth,
        minHeight: node.minHeight,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'OverflowBox',
        properties: {
          'maxWidth': 'node.maxWidth',
          'maxHeight': 'node.maxHeight',
          'minWidth': 'node.maxHeight',
          'minHeight': 'node.maxHeight',
        },
        child: res.describer,
      );
    } else if (node is RenderConstrainedOverflowBox) {
      final res = rebuildWidget(node.child);
      widget = SizedOverflowBox(
        alignment: node.alignment,
        size: node.size,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'SizedOverflowBox',
        properties: {
          'size': 'node.size',
          'alignment': 'node.alignment',
        },
        child: res.describer,
      );
    } else if (node is RenderBaseline) {
      final res = rebuildWidget(node.child);
      widget = Baseline(
        baseline: node.baseline,
        baselineType: node.baselineType,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'Baseline',
        properties: {
          'baseline': node.baseline,
          'baselineType': node.baselineType,
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
        properties: {'quarterTurns': node.quarterTurns},
        child: res.describer,
      );
    } else if (node is RenderTransform) {
      final matrix4 = debugValueOfType<Matrix4>(node);
      final res = rebuildWidget(node.child);
      widget = res.widget;
      describer = res.describer;

      if (widget != null) {
        widget = Transform(
          transform: matrix4 ?? Matrix4.identity(),
          alignment: node.alignment,
          origin: node.origin,
          child: res.widget,
        );
        describer = SingleChildWidgetDescriber(
          name: 'Transform',
          properties: {
            'transform': matrix4 == null
                ? 'ReplaceWithMatrix()'
                : 'Matrix4.columns(${[
                    matrix4.row0,
                    matrix4.row1,
                    matrix4.row2,
                    matrix4.row3,
                  ].map((r) {
                    return 'Vector(${r.x.describe},${r.y.describe},${r.z.describe},${r.w.describe}),';
                  }).join()},)',
            if (node.alignment != null) 'alignment': node.alignment,
            if (node.origin != null) 'origin': node.origin,
          },
          child: res.describer,
        );
      }
    } else if (node is RenderFlex) {
      final children = [for (final child in node.children) rebuildWidget(child)];
      final validChildren = children.where((e) => e.widget != null);
      if (validChildren.isNotEmpty) {
        widget = Flex(
          direction: node.direction,
          mainAxisAlignment: node.mainAxisAlignment,
          crossAxisAlignment: node.crossAxisAlignment,
          mainAxisSize: node.mainAxisSize,
          children: List.of(validChildren.map((e) => e.widget!)),
        );

        describer = MultiChildWidgetDescriber(
          name: node.direction.widgetName,
          properties: {
            if (node.mainAxisAlignment != MainAxisAlignment.start) 'mainAxisAlignment': node.mainAxisAlignment,
            if (node.crossAxisAlignment != CrossAxisAlignment.center) 'crossAxisAlignment': node.crossAxisAlignment,
            if (node.mainAxisSize != MainAxisSize.max) 'mainAxisSize': node.mainAxisSize,
          },
          children: List.of(validChildren.map((e) => e.describer!)),
        );
      }
    } else if (node is RenderStack) {
      final effectiveChildren = node.children.take(node.isInside<IndexedStack>() ? 1 : node.childCount);
      final children = [for (final child in effectiveChildren) rebuildWidget(child)];
      final validChildren = children.where((e) => e.widget != null);
      if (validChildren.isNotEmpty) {
        widget = Stack(
          fit: node.fit,
          alignment: node.alignment,
          children: List.of(validChildren.map((e) => e.widget!)),
        );
        describer = MultiChildWidgetDescriber(
          name: 'Stack',
          properties: {
            if (node.fit != StackFit.loose) 'fit': node.fit,
            if (node.alignment != AlignmentDirectional.topStart) 'alignment': node.alignment,
          },
          children: List.of(
            validChildren.map((e) => e.describer!),
          ),
        );
      }
    } else if (node is RenderWrap) {
      final children = [for (final child in node.children) rebuildWidget(child)];
      widget = Wrap(
        clipBehavior: node.clipBehavior,
        alignment: node.alignment,
        runAlignment: node.runAlignment,
        crossAxisAlignment: node.crossAxisAlignment,
        spacing: node.spacing,
        verticalDirection: node.verticalDirection,
        textDirection: node.textDirection,
        children: List.of(
          children.map((e) => e.widget!),
        ),
      );
      describer = MultiChildWidgetDescriber(
        name: 'Wrap',
        properties: {
          'clipBehavior': 'node.clipBehavior',
          'alignment': 'node.alignment',
          'runAlignment': 'node.runAlignment',
          'crossAxisAlignment': 'node.crossAxisAlignment',
          'spacing': 'node.spacing',
          'verticalDirection': 'node.verticalDirection',
          'textDirection': 'node.textDirection',
        },
        children: List.of(
          children.map((e) => e.describer!),
        ),
      );
    } else if (node is RenderFlow) {
      final children = [for (final child in node.children) rebuildWidget(child)];
      widget = Flow(
        delegate: node.delegate,
        clipBehavior: node.clipBehavior,
        children: List.of(
          children.map((e) => e.widget!),
        ),
      );
      describer = MultiChildWidgetDescriber(
        name: 'Flow',
        properties: {
          'delegate': '${node.delegate.toString()}()',
          'clipBehavior': 'node.clipBehavior',
        },
        children: List.of(
          children.map((e) => e.describer!),
        ),
      );
    } else if (node is RenderTable) {
      // todo handle table
      widget = Table(
        border: node.border,
        children: [
          for (var i = 0; i < node.rows; i++)
            TableRow(
              children: List.of(
                node.row(i).map(rebuildWidget).map((e) => e.widget!),
              ),
            ),
        ],
      );

      describer = const SingleChildWidgetDescriber(name: 'name');
    } else if (node is RenderCustomMultiChildLayoutBox) {
      if (node.delegate.toString() == '_ScaffoldLayout') {
        final scaffoldSlots = <String, RenderObject>{
          for (final c in node.children.where((e) => e.parentData is MultiChildLayoutParentData))
            (c.parentData as MultiChildLayoutParentData).id.toString(): c,
        };

        var appBarRes = rebuildWidget(scaffoldSlots['_ScaffoldSlot.appBar']);
        var fabRes = rebuildWidget(scaffoldSlots['_ScaffoldSlot.floatingActionButton']);

        if (appBarRes.widget is ConstrainedBox) {
          appBarRes = RebuildResult(
            widget: (appBarRes.widget as ConstrainedBox).child,
            describer: (appBarRes.describer as SingleChildWidgetDescriber).child,
          );
        }

        final bodyRes = rebuildWidget(scaffoldSlots['_ScaffoldSlot.body']);
        var appBar = appBarRes.widget;
        if (scaffoldSlots.isNotEmpty) {
          widget = Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: fabRes.widget,
            appBar: appBar == null
                ? null
                : appBar is AppBar
                    ? appBar
                    : PreferredSize(
                        preferredSize: Size.fromHeight(node.size.height),
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
              'floatingActionButton': fabRes.describer,
            },
          );
        }
      } else if (node.delegate.toString() == '_ToolbarLayout') {
        final appBarSlots = _rebuildAppBarSlots(node);
        widget = AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: appBarSlots.title?.widget,
          leading: appBarSlots.leading?.widget,
          actions: List.of(appBarSlots.actions.map((e) => e.widget!)),
        );
        describer = SlottedWidgetDescriber(
          name: 'AppBar',
          slots: {
            'title': appBarSlots.title?.describer,
            'leading': appBarSlots.leading?.describer,
          },
          multiChildrenSlots: {
            if (appBarSlots.actions.isNotEmpty)
              'actions': List.of(
                appBarSlots.actions.map((e) => e.describer!),
              )
          },
        );
      }
    } else if (node is RenderSliverList ||
        node is RenderSliverFixedExtentList ||
        node.typeName == '_RenderSliverPrototypeExtentList') {
      final children = [for (final child in (node as ContainerRenderObjectMixin).children) rebuildWidget(child)];

      if (children.isNotEmpty) {
        EdgeInsetsGeometry? padding;
        if (node.parent is RenderSliverPadding) {
          skipParent = true;
          padding = (node.parent as RenderSliverPadding).padding;
        }

        double? itemExtent;
        List<RebuildResult> listItemWidgets = [children.first];
        RebuildResult? protoType;
        if (node is RenderSliverFixedExtentList) {
          itemExtent = node.children.whereType<RenderBox>().firstOrNull?.size.height;
        } else if (node.typeName == '_RenderSliverPrototypeExtentList') {
          protoType = children.first;
        } else {
          final itemsWithDiffHashes = <int, RebuildResult>{};
          for (final c in children) {
            itemsWithDiffHashes[c.describer.hashCode] = c;
          }
          listItemWidgets = List.of(itemsWithDiffHashes.values);
        }

        final scrollDirection = node.findParentOfType<RenderViewport>()?.axis ?? Axis.vertical;

        if (node.treatAsSliver) {
          widget = SkeletonList.sliver(
            itemExtent: itemExtent,
            itemCount: node.childCount,
            protoTypeitem: protoType?.widget,
            child: Column(
              children: List.of(listItemWidgets.map((e) => e.widget!)),
            ),
          );
        } else {
          widget = SkeletonList(
            padding: padding,
            itemExtent: itemExtent,
            protoTypeitem: protoType?.widget,
            scrollDirection: scrollDirection,
            child: Flex(
              direction: scrollDirection,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List.of(listItemWidgets.map((e) => e.widget!)),
            ),
          );
        }
        describer = SlottedWidgetDescriber(
          name: node.treatAsSliver ? 'SkeletonList.sliver' : 'SkeletonList',
          properties: {
            if (!node.treatAsSliver) ...{
              if (padding != null) 'padding': padding.describe,
              if (scrollDirection != Axis.vertical) 'scrollDirection': 'Axis.horizontal',
            },
            if (itemExtent != null) 'itemExtent': '$itemExtent',
          },
          slots: {
            if (protoType != null) 'protoTypeitem': protoType.describer,
            'child': listItemWidgets.length == 1
                ? listItemWidgets.first.describer
                : MultiChildWidgetDescriber(
                    name: scrollDirection.widgetName,
                    children: List.of(
                      listItemWidgets.map((e) => e.describer!),
                    ),
                  ),
          },
        );
      }
    } else if (node is RenderSliverGrid) {
      final children = [for (final child in node.children.take(1)) rebuildWidget(child)];
      final scrollDirection = node.findParentOfType<RenderViewport>()?.axis ?? Axis.vertical;
      EdgeInsetsGeometry? padding;
      if (node.parent is RenderSliverPadding) {
        skipParent = true;
        padding = (node.parent as RenderSliverPadding).padding;
      }
      final delegate = node.gridDelegate;

      if (node.treatAsSliver) {
        widget = SkeletonGrid.sliver(
          gridDelegate: delegate,
          child: children.first.widget!,
          itemCount: node.childCount,
        );
      } else {
        widget = SkeletonGrid(
          gridDelegate: delegate,
          padding: padding,
          scrollDirection: scrollDirection,
          child: children.first.widget!,
        );
      }
      describer = SingleChildWidgetDescriber(
        name: node.treatAsSliver ? 'SkeletonGrid.sliver' : 'SkeletonGrid',
        properties: {
          if (!node.treatAsSliver) ...{
            if (padding != null) 'padding': padding.describe,
            if (scrollDirection != Axis.vertical) 'scrollDirection': 'Axis.vertical',
          },
          'gridDelegate': 'GridDelegate()',
        },
        child: children.first.describer,
      );
    } else if (node is RenderSliverFillViewport) {
      final children = [for (final child in node.children.take(1)) rebuildWidget(child)];
      final scrollDirection = node.findParentOfType<RenderViewport>()?.axis ?? Axis.horizontal;
      var padEnds = true;
      if (node.parentData is SliverPhysicalParentData) {
        padEnds = (node.parentData as SliverPhysicalParentData).paintOffset.dx != 0;
      }

      widget = SkeletonPageView(
        viewportFraction: node.viewportFraction,
        scrollDirection: scrollDirection,
        padEnds: padEnds,
        child: children.first.widget!,
      );
    } else if (node is RenderSliverToBoxAdapter) {
      final res = rebuildWidget(node.child);
      widget = SliverToBoxAdapter(child: res.widget);
      describer = SingleChildWidgetDescriber(
        name: 'SliverToBoxAdapter',
        child: res.describer,
      );
    } else if (node is RenderViewport) {
      if (node.treatAsSliver) {
        final children = <RebuildResult>[];
        for (final child in node.children) {
          if (child.isInside<SliverAppBar>()) {
            final rootStack = child.findFirstChildOf<RenderStack>();
            final appBarLayout = rootStack?.findFirstChildOf<RenderCustomMultiChildLayoutBox>();
            final flexSpaceStack = rootStack?.findFirstChildOf<RenderStack>();
            final appBarSlots = appBarLayout == null ? null : _rebuildAppBarSlots(appBarLayout);
            final flexSpaceRes = rebuildWidget(flexSpaceStack);
            final expandedHeight = (child is RenderSliver) ? child.geometry!.layoutExtent : null;
            final appBarWidget = SliverAppBar(
              expandedHeight: expandedHeight,
              backgroundColor: Colors.transparent,
              title: appBarSlots?.title?.widget,
              leading: appBarSlots?.leading?.widget,
              flexibleSpace: flexSpaceRes.widget,
            );
            describer = SlottedWidgetDescriber(
              name: 'SliverAppBar',
              properties: {
                if (expandedHeight != null) 'expandedHeight': expandedHeight,
              },
              slots: {
                'title': appBarSlots?.title?.describer,
                'leading': appBarSlots?.leading?.describer,
                'flexibleSpace': flexSpaceRes.describer,
              },
            );
            log(describer.bluePrint());
            children.add(RebuildResult(
              widget: appBarWidget,
              describer: describer,
              node: child,
            ));
          } else {
            children.add(rebuildWidget(child));
          }
        }

        final slivers = <Widget>[];
        final describers = <WidgetDescriber>[];
        for (final child in children) {
          if (child.widget is! SliverMultiBoxAdaptorWidget &&
              child.widget is! SliverToBoxAdapter &&
              child.widget is! SliverAppBar &&
              child.widget is! SliverGap) {
            final maxExtent = (child.node is RenderSliver) ? (child.node as RenderSliver).geometry!.layoutExtent : 0.0;
            slivers.add(
              FixedExtentSliverHeader(
                maxExtent: maxExtent,
                child: child.widget,
              ),
            );
            describers.add(SingleChildWidgetDescriber(
              name: 'FixedExtentSliverHeader',
              properties: {'maxExtent': maxExtent.describe},
              child: child.describer,
            ));
          } else {
            slivers.add(child.widget!);
            describers.add(child.describer!);
          }
        }

        widget = CustomScrollView(
          scrollDirection: node.axis,
          slivers: slivers,
        );
        describer = MultiChildWidgetDescriber(
          name: 'CustomScrollView',
          childrenName: 'slivers',
          children: describers,
        );
      } else {
        final res = rebuildWidget(node.firstChild);
        widget = res.widget;
        describer = res.describer;
      }
    } else if (node is RenderClipPath) {
      final res = rebuildWidget(node.child);
      widget = ClipPath(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'ClipPath',
        properties: {
          'clipBehavior': node.clipBehavior,
          if (node.clipper != null) 'clipper': 'ReplaceWithClipper()',
        },
        child: res.describer,
      );
    } else if (node is RenderClipRect) {
      final res = rebuildWidget(node.child);
      widget = ClipRect(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'ClipRect',
        properties: {
          'clipBehavior': '${node.clipBehavior}',
          if (node.clipper != null) 'clipper': 'ReplaceWithClipper()',
        },
        child: res.describer,
      );
    } else if (node is RenderClipOval) {
      final res = rebuildWidget(node.child);
      widget = ClipOval(
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'ClipOval',
        properties: {
          'clipBehavior': node.clipBehavior,
          if (node.clipper != null) 'clipper': 'ReplaceWithClipper()',
        },
        child: res.describer,
      );
    } else if (node is RenderClipRRect) {
      final res = rebuildWidget(node.child);
      widget = ClipRRect(
        borderRadius: node.borderRadius,
        clipBehavior: node.clipBehavior,
        clipper: node.clipper,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'ClipRRect',
        properties: {
          'borderRadius': node.borderRadius.describe,
          'clipBehavior': node.clipBehavior,
          if (node.clipper != null) 'clipper': 'ReplaceWithClipper()'
        },
        child: res.describer,
      );
    } else if (node is RenderCustomPaint) {
      final res = rebuildWidget(node.child);
      if (res.widget != null) {
        widget = CustomPaint(
          painter: node.painter,
          foregroundPainter: node.painter,
          child: res.widget,
        );
        describer = SingleChildWidgetDescriber(name: 'CustomPaint', child: res.describer, properties: {
          if (node.painter != null) 'painter': 'ReplaceWithPainter()',
          if (node.foregroundPainter != null) 'foregroundPainter': 'ReplaceWithPainter()',
        });
      } else {
        final config = _boxBoneConfigs[node] ??= BoxBoneConfig();
        widget = BoxBoneEditor(
          initialConfig: config,
          onChange: (config) {
            _boxBoneConfigs[node] = config;
            rebuild(preview: true);
          },
          child: BoxBone(
            width: node.size.width,
            height: node.size.height,
          ),
        );
        describer = SingleChildWidgetDescriber(name: 'BoxBone', properties: {
          'width': node.size.width,
          'height': node.size.height,
        });
      }
    } else if (node is RenderPhysicalModel) {
      final layout = node.findFirstChildOf<RenderCustomMultiChildLayoutBox>();
      if (layout != null && (layout.buildsAppBar(node) || layout.buildsAScaffold(node))) {
        final res = rebuildWidget(layout);
        widget = res.widget;
        describer = res.describer;
      } else {
        final res = rebuildWidget(node.child);
        widget = SkeletonContainer(
          elevation: node.elevation,
          child: res.widget,
        );
        describer = SingleChildWidgetDescriber(
          name: 'SkeletonContainer',
          child: res.describer,
        );
      }
    } else if (node is RenderPhysicalShape) {
      final isButton = node.findParentWithName('_RenderInputPadding') != null;

      final shape = (node.clipper as ShapeBorderClipper).shape;
      BoxShape? boxShape;
      BorderRadiusGeometry? borderRadius;
      if (shape is RoundedRectangleBorder) {
        borderRadius = shape.borderRadius;
      } else {
        boxShape = BoxShape.circle;
      }

      final config = _boxBoneConfigs[node] ??= BoxBoneConfig(
        canBeContainer: !isButton,
        treatAsBone: isButton,
      );

      if (config.treatAsBone || !config.includeBone) {
        final width = isButton ? node.size.width : double.infinity;
        skipParent = true;
        widget = BoxBone(
          width: width,
          height: node.size.height,
          shape: boxShape ?? BoxShape.rectangle,
          borderRadius: borderRadius,
        );
        describer = SingleChildWidgetDescriber(
          name: 'BoxBone',
          properties: {
            'width': width.describe,
            'height': node.size.height.describe,
          },
        );
      } else {
        final res = rebuildWidget(node.child);
        widget = SkeletonContainer(
          clipBehavior: node.clipBehavior,
          elevation: node.elevation,
          shape: shape,
          child: res.widget,
        );
        describer = SingleChildWidgetDescriber(
          name: 'SkeletonContainer',
          properties: {
            'clipBehavior': 'Clip.none',
            'shape': 'ShapeBorderClipper()',
          },
          child: res.describer,
        );
      }
      widget = BoxBoneEditor(
        initialConfig: config,
        onChange: (config) {
          _boxBoneConfigs[node] = config;
          rebuild(preview: true);
        },
        child: widget,
      );
    } else if (node is RenderImage) {
      widget = const BoxBone();
      describer = const SingleChildWidgetDescriber(name: 'BoxBone');
      final config = _boxBoneConfigs[node] ??= BoxBoneConfig();
      widget = BoxBoneEditor(
        initialConfig: config,
        onChange: (config) {
          _boxBoneConfigs[node] = config;
          rebuild(preview: true);
        },
        child: widget,
      );
    } else if (node is RenderCustomPaint) {
      var size = node.size;
      if (node.child != null) {
        final res = rebuildWidget(node.child);
        widget = res.widget;
        describer = res.describer;
      } else if (node.isInside<Switch>()) {
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

      final config = _textBoneConfigs[node] ??= TextBoneConfig(
        fixedWidth: lineCount <= 1,
        radius: 8,
        width: painter.width,
        canHaveFixedWidth: lineCount <= 1,
      );

      final indent = config.fixedWidth ? 0.0 : config.indent;
      final fixedWith = config.fixedWidth ? config.width : null;

      EdgeInsetsGeometry? padding;
      if (node.parent is RenderPadding) {
        skipParent = true;
        padding = (node.parent as RenderPadding).padding;
      }

      widget = TextBoneEditor(
        initialConfig: config,
        onChange: (config) {
          _textBoneConfigs[node] = config;
          rebuild(preview: true);
        },
        child: TextBone(
          padding: padding ?? EdgeInsets.zero,
          lineHeight: painter.preferredLineHeight,
          textAlign: node.textAlign,
          textDirection: node.textDirection,
          fontSize: fontSize,
          lineLength: lineCount * painter.width,
          maxLines: node.maxLines,
          borderRadius: config.radius,
          indent: indent,
          width: fixedWith,
        ),
      );
      final textDirection = node.widget is RichText ? (node.widget as RichText).textDirection : null;
      describer = SingleChildWidgetDescriber(
        name: 'TextBone',
        properties: {
          'lineHeight': painter.preferredLineHeight,
          if (node.textAlign != TextAlign.start) 'textAlign': node.textAlign,
          if (textDirection != null) 'textDirection': textDirection,
          if (padding != null) 'padding': padding.describe,
          'fontSize': fontSize.describe,
          if ((lineCount * painter.width) != fixedWith) 'lineLength': (lineCount * painter.width).describe,
          if (node.maxLines != null) 'maxLines': node.maxLines!.describe,
          'borderRadius': config.radius.describe,
          if (indent != 0) 'indent': indent.describe,
          if (fixedWith != null) 'width': fixedWith.describe,
        },
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
      final canBeContainer = res.widget != null;
      final config = _boxBoneConfigs[node] ??= BoxBoneConfig(
        canBeContainer: canBeContainer,
        treatAsBone: !canBeContainer,
      );

      if (config.treatAsBone || !config.includeBone) {
        Size boneSize = Size(
          double.infinity,
          node.constraints.hasTightHeight ? node.constraints.maxHeight : node.size.height,
        );
        if (node.parent is RenderConstrainedBox) {
          final box = node.parent as RenderConstrainedBox;
          if (box.additionalConstraints.isTight) {
            boneSize = box.additionalConstraints.biggest;
            skipParent = true;
          }
        }

        widget = BoxBone(
          borderRadius: boxDecoration.borderRadius,
          height: boneSize.height,
          width: boneSize.width,
          shape: boxDecoration.shape,
        );

        describer = SingleChildWidgetDescriber(
          name: 'BoxBone',
          properties: {
            if (boxDecoration.borderRadius != null) 'borderRadius': boxDecoration.borderRadius,
             'width': boneSize.width.describe,
            'height': boneSize.height.describe,
          },
        );
      } else {
        widget = SkeletonContainer(
          shape: shape,
          width: node.assignableWidth,
          height: node.assignableHeight,
          child: res.widget,
        );
        describer = const SingleChildWidgetDescriber(
          name: 'SkeletonContainer',
          properties: {
            'width': '0',
            'height': '0',
          },
        );
      }

      widget = BoxBoneEditor(
        initialConfig: config,
        onChange: (config) {
          _boxBoneConfigs[node] = config;
          rebuild(preview: true);
        },
        child: widget,
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
            if (contentPadding != null) 'contentPadding': contentPadding.describe,
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
      widget = res.widget;
      describer = res.describer;
      if (node.typeName == '_RenderColoredBox') {
        final config = _boxBoneConfigs[node] ??= BoxBoneConfig(
          canBeContainer: res.widget != null,
          treatAsBone: res.widget == null,
        );
        if (config.treatAsBone) {
          widget = BoxBone(
            width: double.infinity,
            height: (node is RenderBox) ? (node as RenderBox).size.height : null,
          );
        } else {
          widget = SkeletonContainer(
            color: Colors.green,
            child: res.widget,
          );
        }
        widget = BoxBoneEditor(
          initialConfig: config,
          onChange: (config) {
            _boxBoneConfigs[node] = config;
            rebuild(preview: true);
          },
          child: widget,
        );

        describer = SingleChildWidgetDescriber(
          name: 'BoxBone',
          child: res.describer,
        );
      } else if (node.typeName == '_RenderInputPadding') {
        if (node.child?.parentData is BoxParentData) {
          final offset = (node.child!.parentData as BoxParentData).offset;
          if (offset.dy != 0 && offset.dx != 0) {
            widget = Padding(
              padding: EdgeInsets.symmetric(
                vertical: offset.dy,
                horizontal: offset.dx,
              ),
              child: res.widget,
            );
            describer = SingleChildWidgetDescriber(
              name: 'Padding',
              properties: {
                'padding': EdgeInsets.symmetric(
                  vertical: offset.dy,
                  horizontal: offset.dx,
                )
              },
              child: res.describer,
            );
          }
        }
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
          if (data.fit == FlexFit.tight) {
            widget = Expanded(flex: data.flex!, child: widget);
            describer = SingleChildWidgetDescriber(
              name: 'Expanded',
              properties: {
                if (data.flex != null && data.flex != 1) 'flex': data.flex!.describe,
              },
              child: describer,
            );
          } else {
            final fit = data.fit ?? FlexFit.loose;
            widget = Flexible(flex: data.flex!, fit: fit, child: widget);
            describer = SingleChildWidgetDescriber(
              name: 'Flexible',
              properties: {
                if (data.flex != null && data.flex != 1) 'flex': data.flex!.describe,
                if (data.fit != FlexFit.loose) 'fit': data.fit,
              },
              child: describer,
            );
          }
          print(describer.bluePrint(4));
        }
      } else if (node.parentData is StackParentData) {
        final data = node.parentData as StackParentData;
        final positionedDir = node.findAncestorWidget<PositionedDirectional>();
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
            name: positionedDir != null ? 'PositionedDirectional' : 'Positioned',
            properties: {
              if (data.top != null) 'top': data.top!.describe,
              if (data.bottom != null) 'bottom': data.bottom!.describe,
              if (data.width != null) 'width': data.width!.describe,
              if (data.height != null) 'height': data.height!.describe,
              if (positionedDir != null) ...{
                if (positionedDir.start != null) 'start': positionedDir.start!.describe,
                if (positionedDir.end != null) 'end': positionedDir.end!.describe,
              } else ...{
                if (data.left != null) 'left': data.left!.describe,
                if (data.right != null) 'right': data.right!.describe,
              },
            },
            child: describer,
          );
        }
      }
    }

    return RebuildResult(
      widget: widget,
      describer: describer,
      skipParent: skipParent,
      node: node,
    );
  }

  _AppBarSlots _rebuildAppBarSlots(RenderCustomMultiChildLayoutBox node) {
    final appBarSlots = <String, RenderObject>{
      for (final c in node.children.where((e) => e.parentData is MultiChildLayoutParentData))
        (c.parentData as MultiChildLayoutParentData).id.toString(): c,
    };

    final titleRes = rebuildWidget(appBarSlots['_ToolbarSlot.middle']);
    final leadingRes = rebuildWidget(appBarSlots['_ToolbarSlot.leading']);
    final actionsObject = appBarSlots['_ToolbarSlot.trailing'];
    final actions = actionsObject is RenderFlex ? actionsObject.children : <RenderObject>[];

    return _AppBarSlots(
        title: titleRes, leading: leadingRes, actions: [for (final action in actions) rebuildWidget(action)]);
  }
}

class _AppBarSlots {
  final RebuildResult? title, leading;
  final List<RebuildResult> actions;

  _AppBarSlots({
    this.title,
    this.leading,
    this.actions = const [],
  });
}
