import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skeleton_builder/src/bones/box_bone.dart';

class TextBone extends StatelessWidget {
  const TextBone(
      {Key? key,
      required this.lineHeight,
      required this.lineLength,
      required this.fontSize,
      this.width,
      this.height,
      this.maxLines,
      this.textAlign,
      this.textDirection,
      this.indent = 0.0,
      this.borderRadius = 0.0,
      this.textScaleFactor})
      : super(key: key);

  final double lineHeight;
  final double? textScaleFactor;
  final double fontSize;
  final double lineLength;
  final double? width;
  final double? height;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final double indent;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final effectiveWidth = width ?? constrains.maxWidth;
      final actualLineCount = math.max((lineLength / effectiveWidth).floor(), 1);

      var lineCount = maxLines == null ? actualLineCount : math.min(maxLines!, actualLineCount);
      final spacing = lineHeight - fontSize;
      return Text.rich(
        TextSpan(
          children: [
            for (var i = 0; i < lineCount; i++)
              WidgetSpan(
                child: SizedBox(
                  width: _calcWidth(i, lineCount, effectiveWidth),
                  height: lineHeight,
                  child: Center(
                    child: BoxBone(
                      height: fontSize,
                      width: _calcWidth(i, lineCount, effectiveWidth),
                      padding: EdgeInsetsDirectional.only(top: spacing * .6, end: indent),
                      borderRadius: BorderRadius.circular(borderRadius),
                    ),
                  ),
                ),
              )
          ],
        ),
        textAlign: textAlign,
        textDirection: textDirection,
        maxLines: maxLines,
      );
    });
  }

  double _calcWidth(int i, int lineCount, double effectiveWidth) {
    return i == lineCount - 1 && lineCount > 1 ? effectiveWidth * .7 : effectiveWidth;
  }
}
