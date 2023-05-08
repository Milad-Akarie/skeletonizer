import 'package:flutter/material.dart';

class RebuildResult {
  final Widget? widget;
  final WidgetDescriber? describer;

  RebuildResult([this.widget, this.describer]);
}

abstract class WidgetDescriber {
  const WidgetDescriber({
    required this.name,
    this.properties = const {},
  });

  String bluePrint([int depth = 0]);

  final String name;
  final Map<String, String> properties;

  String tabs(int depth) {
    return '  ' * depth;
  }
}

class SingleChildWidgetDescriber extends WidgetDescriber {
  const SingleChildWidgetDescriber({
    Key? key,
    this.child,
    required super.name,
    super.properties,
  });

  final WidgetDescriber? child;

  @override
  String bluePrint([int depth = 0]) {
    if(child == null && properties.isEmpty ) return '$name(),';
    final childDesc = child == null ? '' : '\n${tabs(depth)}child: ${child!.bluePrint(depth + 1)}';
    return '$name(\n${properties.keys.map((k) => '${tabs(depth)}$k: ${properties[k]}').join(',\n')},$childDesc\n${tabs(depth)})';
  }
}

class MultiChildWidgetDescriber extends WidgetDescriber {
  const MultiChildWidgetDescriber({
    Key? key,
    required this.children,
    required super.name,
    super.properties,
  });

  final List<WidgetDescriber> children;

  @override
  String bluePrint([int depth = 0]) {

    final childrenDes = '\n${tabs(depth)}children:[\n${children.map((e) => '${tabs(depth)}${e.bluePrint(depth + 1)}').toList().join(',\n')}\n${tabs(depth)}]';
    return '$name(\n${properties.keys.map((k) => '${tabs(depth)}$k: ${properties[k]}').join(',\n')},$childrenDes\n${tabs(depth)})';
  }
}

class SlottedWidgetDescriber extends WidgetDescriber {
  const SlottedWidgetDescriber({
    Key? key,
    required this.slots,
    required super.name,
    super.properties,
  });

  final Map<String, WidgetDescriber?> slots;

  @override
  String bluePrint([int depth = 0]) {
    slots.removeWhere((key, value) => value == null);
    final childrenDes =
        'children: ${slots.keys.map((k) => '$k: ${slots[k]!.bluePrint(depth + 1)}').toList().join(',\n')}';
    return '${' ' * depth}$name(${properties.keys.map((k) => '$k: ${properties[k]}').join(',\n')},$childrenDes\n)';
  }
}
