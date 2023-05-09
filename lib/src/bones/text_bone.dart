import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skeleton_builder/src/custom_decorated_box.dart';

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
                      borderRadius: BorderRadius.circular(6),
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
    this.shape = BoxShape.rectangle,
    this.padding = EdgeInsets.zero,
  }) : super(key: key);

  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final BoxShape shape;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color ?? Colors.grey.shade300,
            borderRadius: borderRadius,
            shape: shape,
          ),
          child: child,
        ),
      ),
    );
  }
}

class SkeletonContainer extends StatelessWidget {
  const SkeletonContainer({
    Key? key,
    this.width,
    this.height,
    this.color,
    this.child,
    this.shape,
    this.padding = EdgeInsets.zero,
    this.elevation = 0.0,
    this.clipBehavior = Clip.none,
  }) : super(key: key);

  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final ShapeBorder? shape;
  final Clip clipBehavior;
  final double elevation;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SizedBox(
        width: width,
        height: height,
        child: Material(
          color: color ?? Theme.of(context).colorScheme.surface,
          clipBehavior: clipBehavior,
          elevation: elevation,
          shape: shape,
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [
                  Colors.red,
                  Colors.blue,
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft
              ).createShader(Offset.zero & MediaQuery.of(context).size);
            },
            child: child,
          ),
        ),
      ),
    );
  }
}
