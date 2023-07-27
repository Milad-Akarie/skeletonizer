import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

extension PaintX on Paint {
  Paint cloneWithColor([Color? color]) {
    return Paint()
      ..blendMode = blendMode
      ..color = color ?? this.color
      ..colorFilter = colorFilter
      ..filterQuality = filterQuality
      ..imageFilter = imageFilter
      ..invertColors = invertColors
      ..isAntiAlias = isAntiAlias
      ..maskFilter = maskFilter
      ..shader = shader
      ..strokeCap = strokeCap
      ..strokeJoin = strokeJoin
      ..strokeMiterLimit = strokeMiterLimit
      ..strokeWidth = strokeWidth
      ..style = style
      ..maskFilter = maskFilter
      ..strokeJoin = strokeJoin
      ..strokeMiterLimit = strokeMiterLimit
      ..strokeWidth = strokeWidth
      ..style = style;
  }
}
