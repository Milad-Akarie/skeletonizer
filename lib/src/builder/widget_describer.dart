import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class RebuildResult {
  final Widget? widget;
  final WidgetDescriber? describer;
  final bool skipParent;
  final AbstractNode? node;

  RebuildResult({
    this.widget,
    this.describer,
    this.skipParent = false,
    this.node,
  });
}

abstract class WidgetDescriber {
  const WidgetDescriber({
    required this.name,
    this.properties = const {},
  });

  String bluePrint([int depth = 0]);

  final String name;
  final Map<String, dynamic> properties;

  bool get hasProps => properties.isNotEmpty;

  String tabs(int depth) {
    return '  ' * depth;
  }

  @override
  int get hashCode => name.hashCode ^ const MapEquality().hash(properties);

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class SingleChildWidgetDescriber extends WidgetDescriber {
  const SingleChildWidgetDescriber({
    Key? key,
    this.child,
    required super.name,
    this.childName = 'child',
    this.posProperties = const [],
    super.properties,
  });
  final List<Object> posProperties;
  final String childName;
  final WidgetDescriber? child;

  @override
  String bluePrint([int depth = 0]) {
    if (child == null && !hasProps && posProperties.isEmpty) return '$name(),';
    final posProps = posProperties.isNotEmpty ? posProperties.map((e) => '$e,').join() : '';
    final childDesc = child == null ? '' : '\n${tabs(depth)}$childName: ${child!.bluePrint(depth + 1)}';
    return '$name(${hasProps ? '\n' : ''}$posProps${properties.keys.map((k) => '${tabs(depth)}$k: ${properties[k]},').join('\n')}$childDesc\n${tabs(depth)})';
  }

  @override
  int get hashCode => super.hashCode ^ child.hashCode;

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class MultiChildWidgetDescriber extends WidgetDescriber {
  const MultiChildWidgetDescriber({
    Key? key,
    required this.children,
    required super.name,
    this.childrenName = 'children',
    super.properties,
  });

  final List<WidgetDescriber> children;
  final String childrenName;

  @override
  String bluePrint([int depth = 0]) {
    final childrenDes =
        '\n${tabs(depth)}$childrenName:[\n${children.map((e) => '${tabs(depth)}${e.bluePrint(depth + 1)}').toList().join(',\n')}\n${tabs(depth)}]';
    return '$name(${hasProps ? '\n' : ''}${properties.keys.map((k) => '${tabs(depth)}$k: ${properties[k]},').join('\n')}$childrenDes\n${tabs(depth)})';
  }

  @override
  int get hashCode => super.hashCode ^ const ListEquality().hash(children);

  @override
  bool operator ==(Object other) {
    return false;
  }
}

class SlottedWidgetDescriber extends WidgetDescriber {
  const SlottedWidgetDescriber({
    Key? key,
    required this.slots,
    required super.name,
    this.multiChildrenSlots = const {},
    super.properties,
  });

  final Map<String, WidgetDescriber?> slots;
  final Map<String, List<WidgetDescriber>> multiChildrenSlots;

  @override
  String bluePrint([int depth = 0]) {
    slots.removeWhere((key, value) => value == null);
    final slotsRes = slots.keys.map((k) => '${tabs(depth)}$k: ${slots[k]!.bluePrint(depth + 1)},\n').join();

    final multiChildrenSlotsRes = multiChildrenSlots.keys
        .map((k) =>
            '${tabs(depth)}$k: ${multiChildrenSlots[k]!.map((e) => '\n${tabs(depth + 1)}${e.bluePrint(depth + 1)}').toList()}')
        .join(',\n');
    return '$name(${hasProps ? '\n' : ''}${properties.keys.map((k) => '${tabs(depth)}$k: ${properties[k]},\n').join()}$slotsRes$multiChildrenSlotsRes)';
  }

  @override
  int get hashCode => super.hashCode ^ const MapEquality().hash(slots);

  @override
  bool operator ==(Object other) {
    return false;
  }
}
