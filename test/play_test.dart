import 'package:flutter/material.dart';
import 'package:skeleton_builder/src/builder/widget_describer.dart';

main() {
  const layout = SingleChildWidgetDescriber(
    name: 'Padding',
    properties: {'padding': 'EdgeInsets.all(20)'},
    child: SingleChildWidgetDescriber(
      name: 'SizedBox',
      properties: {'width': '20', 'height': '30'},
    ),
  );

  print(layout.bluePrint());
}
