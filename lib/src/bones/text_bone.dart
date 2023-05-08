import 'dart:math' as math;

import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final effectiveWidth = width ?? constrains.maxWidth;
      final actualLineCount = (lineLength / effectiveWidth).ceil();
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
                      padding: EdgeInsets.only(top: spacing * .6),
                       shape: RoundedRectangleBorder(
                         borderRadius:  BorderRadius.circular(4),
                       ),
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

class BoxBone extends StatelessWidget {
  const BoxBone({
    Key? key,
    this.borderRadius,
    this.width,
    this.height,
    this.color,
    this.child,
    this.shape,
    this.padding = EdgeInsets.zero,
  })  : _container = false,
        elevation = 0.0,
        clipBehavior = Clip.none,
        super(key: key);

  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final ShapeBorder? shape;
  final bool _container;
  final Clip clipBehavior;
  final double elevation;
  final EdgeInsetsGeometry padding;

  const BoxBone.container({
    Key? key,
    this.borderRadius,
    this.width,
    this.height,
    this.color,
    this.child,
    this.shape,
    this.clipBehavior = Clip.none,
    this.elevation = 0.0,
    this.padding = EdgeInsets.zero,
  })  : _container = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final isContainer = _container && child != null;
    final effectiveColor = isContainer ? Theme.of(context).colorScheme.surface : Colors.grey.shade300;
    final effectiveElevation = isContainer ? elevation : 0.0;
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: color ?? effectiveColor,
          clipBehavior: clipBehavior,
          elevation: effectiveElevation,
          shape: shape,
          child: child,
        ),
      ),
    );
  }
}
