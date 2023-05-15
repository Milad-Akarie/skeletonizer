import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeleton_builder/skeleton_builder.dart';
import 'package:skeleton_builder/src/builder/editors/box_bone_editor.dart';
import 'package:skeleton_builder/src/builder/editors/editor_config.dart';
import 'package:skeleton_builder/src/builder/editors/text_bone_editor.dart';
import 'package:skeleton_builder/src/builder/widget_describer.dart';
import 'package:collection/collection.dart';

class SkeletonScanner extends SingleChildRenderObjectWidget {
  const SkeletonScanner({super.key, super.child, required this.onPreviewReady});

  final ValueChanged<Widget?> onPreviewReady;

  @override
  RenderSkeletonScanner createRenderObject(BuildContext context) {
    return RenderSkeletonScanner(
      onPreviewReady,
      textDirection: Directionality.of(context),
    );
  }
}

class RenderSkeletonScanner extends RenderProxyBox {
  /// Creates a repaint boundary around [child].
  RenderSkeletonScanner(this.onPreview, {required this.textDirection, RenderBox? child}) : super(child);
  final TextDirection textDirection;
  final ValueChanged<Widget?> onPreview;
  final _textBoneConfigs = <RenderParagraph, TextBoneConfig>{};
  final _boxBoneConfigs = <RenderObject, BoxBoneConfig>{};

  WidgetDescriber? rebuild({bool preview = false, bool reset = false}) {
    if (reset) {
      _textBoneConfigs.clear();
      _boxBoneConfigs.clear();
    }
    final res = rebuildWidget(child!);
    if (preview) {
      onPreview(res.widget);
      return null;
    } else {
      return res.describer;
    }
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
      final res = rebuildWidget(node.child);
      final constraints = node.additionalConstraints;

      if (constraints.isTight ||
          (constraints.hasTightWidth && !constraints.hasBoundedHeight) ||
          (constraints.hasTightHeight && !constraints.hasBoundedWidth)) {
        final width = constraints.hasTightWidth ? constraints.maxWidth : null;
        final height = constraints.hasTightHeight ? constraints.maxHeight : null;
        widget = SizedBox(
          height: height,
          width: width,
          child: res.widget,
        );
        describer = SingleChildWidgetDescriber(
          name: 'SizedBox',
          properties: {
            if (width != null) 'width': width.safeString,
            if (height != null) 'height': height.safeString,
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
            if (maxWidth != null) 'maxWidth': maxWidth.safeString,
            if (maxHeight != null) 'maxHeight': maxHeight.safeString,
            if (minWidth != null) 'minWidth': minWidth.safeString,
            if (minHeight != null) 'minHeight': minHeight.safeString,
          },
          child: res.describer,
        );
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
          'baseline': 'node.baseline',
          'baselineType': 'node.baselineType',
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
      final matrix4 = debugValueOfType<Matrix4>(node);
      final res = rebuildWidget(node.child);
      widget = Transform(
        transform: matrix4 ?? Matrix4.identity(),
        alignment: node.alignment,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'Transform',
        properties: {
          'transform': matrix4 == null ? 'ReplaceWithMatrix()' : 'Matrix4.fromList(${matrix4.storage.toList()})',
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
        name: node.direction.widgetName,
        properties: {
          'mainAxisAlignment': 'MainAxisAlignment.center',
          'crossAxisAlignment': 'CrossAxisAlignment.center',
          'mainAxisSize': 'MainAxisSize.min',
        },
        children: List.of(children.map((e) => e.describer!)),
      );
    } else if (node is RenderStack) {
      final effectiveChild = node.children.take(node.isInside<IndexedStack>() ? 1 : node.childCount);
      final children = [for (final child in effectiveChild) rebuildWidget(child)];
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
        ),
      );
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

      // widget = SizedBox();
      describer = const SingleChildWidgetDescriber(name: 'name');
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
            child: Column(
              children: List.of(listItemWidgets.map((e) => e.widget!)),
            ),
          );
        }
        describer = SlottedWidgetDescriber(
          name: node.treatAsSliver ? 'SkeletonList.sliver' : 'SkeletonList',
          properties: {
            if (!node.treatAsSliver) ...{
              if (padding != null) 'padding': padding.toString(),
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
            if (padding != null) 'padding': padding.toString(),
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
      if (node.isInside<CustomScrollView>()) {
        final children = <RebuildResult>[];
        for (final child in node.children) {
          if (child.isInside<SliverAppBar>()) {
            const sliverAppBar = Text("Hello") ;
            final physicalModel = child.findChild((object) {
              if (object.isInside<FlexibleSpaceBarSettings>()) {
                return object;
              }
              return null;
            });


            // final titleRes = rebuildWidget(sliverAppBar)
            //   final childWidth = SliverAppBar(
            //      title: ,
            //   );
            //
          }
          children.add(rebuildWidget(child));
        }

        widget = CustomScrollView(
          slivers: [
            for (final child in children.map((e) => e.widget!))
              if (child is! SliverMultiBoxAdaptorWidget && child is! SliverToBoxAdapter)
                SliverToBoxAdapter(
                  child: SizedBox(height: 120, child: child),
                )
              else
                child
          ],
        );

        describer = MultiChildWidgetDescriber(
          children: [
            for (final child in children)
              if (child.widget is! SliverMultiBoxAdaptorWidget && child.widget is! SliverToBoxAdapter)
                SingleChildWidgetDescriber(
                  name: 'SliverToBoxAdapter',
                  child: SingleChildWidgetDescriber(
                    name: 'SizedBox',
                    properties: {'height': '120'},
                    child: child.describer,
                  ),
                )
              else
                child.describer!
          ],
          name: 'CustomScrollView',
          childrenName: 'slivers',
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
        properties: {'clipBehavior': 'node.clipBehavior', if (node.clipper != null) 'clipper': 'ReplaceWithClipper()'},
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
        properties: {'clipBehavior': 'node.clipBehavior', if (node.clipper != null) 'clipper': 'ReplaceWithClipper()'},
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
        properties: {'clipBehavior': 'node.clipBehavior', if (node.clipper != null) 'clipper': 'ReplaceWithClipper()'},
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
          'borderRadius': 'BorderRadius()',
          'clipBehavior': 'node.clipBehavior',
          if (node.clipper != null) 'clipper': 'ReplaceWithClipper()'
        },
        child: res.describer,
      );
    } else if (node is RenderPhysicalModel) {
      final res = rebuildWidget(node.child);
      widget = SkeletonContainer(
        elevation: node.elevation,
        child: res.widget,
      );
      describer = SingleChildWidgetDescriber(
        name: 'SkeletonContainer',
        child: res.describer,
      );
    } else if (node is RenderPhysicalShape) {
      final isButton = node.findParentWithName('_RenderInputPadding') != null;

      final shape = (node.clipper as ShapeBorderClipper).shape;

      final config = _boxBoneConfigs[node] ??= BoxBoneConfig(
        canBeContainer: !isButton,
        treatAsBone: isButton,
      );

      if (config.treatAsBone || !config.includeBone) {
        widget = BoxBone(
          width: isButton ? node.size.width : double.infinity,
          height: node.size.height,
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

      widget = TextBoneEditor(
        initialConfig: config,
        onChange: (config) {
          _textBoneConfigs[node] = config;
          rebuild(preview: true);
        },
        child: TextBone(
          lineHeight: painter.preferredLineHeight,
          textAlign: node.textAlign,
          textDirection: node.textDirection,
          fontSize: fontSize,
          lineLength: lineCount * painter.width,
          maxLines: node.maxLines,
          borderRadius: config.radius,
          indent: config.fixedWidth ? 0 : config.indent,
          width: config.fixedWidth ? config.width : null,
        ),
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

      final config = _boxBoneConfigs[node] ??= BoxBoneConfig(
        canBeContainer: res.widget != null && !node.isInside<Divider>(),
        treatAsBone: node.isInside<Divider>(),
      );

      if (config.treatAsBone || !config.includeBone) {
        widget = BoxBone(
          borderRadius: boxDecoration.borderRadius?.resolve(textDirection),
          height: node.constraints.hasTightHeight ? node.constraints.maxHeight : node.size.height,
          width: double.infinity,
        );
        describer = const SingleChildWidgetDescriber(
          name: 'BoxBone',
          properties: {
            'width': '0',
            'height': '0',
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

    return RebuildResult(
      widget: widget,
      describer: describer,
      skipParent: skipParent,
    );
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

extension RenderBoxX on RenderBox {
  double get assignableHeight => constraints.hasTightHeight ? constraints.maxHeight : size.height;

  double get assignableWidth => constraints.hasTightWidth ? constraints.maxWidth : size.width;
}

extension RenderObjectX on RenderObject {
  String get typeName => runtimeType.toString();

  Widget? get widget => debugCreator is DebugCreator ? (debugCreator as DebugCreator).element.widget : null;

  bool get isMaterialButton {
    return isInside<ElevatedButton>() ||
        isInside<TextButton>() ||
        isInside<OutlinedButton>() ||
        isInside<FilledButton>();
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

  T? findChild<T>(T? Function(RenderObject object) predicate) {
    E? findType<E>(RenderObjectWithChildMixin box) {
      final res = predicate(box);
      if (res != null) {
        return res as E;
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

  bool get isListTile => typeName == '_RenderListTile';
}

extension AxisX on Axis {
  String get widgetName => this == Axis.vertical ? 'Column' : 'Row';
}

extension NumX on num {
  String get safeString => isInfinite ? 'double.infinity' : toString();
}
