class WidgetTemplate {
  static String generate(String name, String body) {
    return ''' 
      import 'package:flutter/material.dart';
      import 'package:skeleton_builder/bones.dart';
          
      class $name extends StatelessWidget {
        const $name({Key? key}) : super(key: key);
      
        @override
        Widget build(BuildContext context) {
          return $body;
        }
      }
    ''';
  }
}
