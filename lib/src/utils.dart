import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Adds functionality to [Paint] to clone it with a different color.
extension PaintX on Paint {
  /// Clones the [Paint] with a different color.
  Paint copyWith({Color? color, Shader? shader}) {
    return Paint()
      ..color = color ?? this.color
      ..shader = shader ?? this.shader
      ..blendMode = blendMode
      ..colorFilter = colorFilter
      ..filterQuality = filterQuality
      ..imageFilter = imageFilter
      ..invertColors = invertColors
      ..isAntiAlias = isAntiAlias
      ..strokeCap = strokeCap
      ..strokeJoin = strokeJoin
      ..maskFilter = maskFilter
      ..strokeWidth = strokeWidth
      ..style = style;
  }
}
