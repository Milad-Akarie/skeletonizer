import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/painting/skeletonizer_painting_context.dart';

/// A widget that represents a bone of the loading skeleton effect
abstract class Bone extends StatelessWidget {
  const Bone._({super.key});

  /// Creates a default bone widget
  const factory Bone({
    Key? key,
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    BoxShape shape,
    double? uniRadius,
    double indent,
    double indentEnd,
  }) = _Bone;

  /// Creates a circular bone widget
  const factory Bone.circle({
    Key? key,
    double? size,
    double indent,
    double indentEnd,
  }) = _Bone.circle;

  /// Creates a square bone widget
  const factory Bone.square({
    Key? key,
    double? size,
    double indent,
    double indentEnd,
    double? uniRadius,
    BorderRadiusGeometry? borderRadius,
  }) = _Bone.square;

  /// Creates a bone widget that mimics an icon
  const factory Bone.icon({
    Key? key,
    double? size,
    double indent,
    double indentEnd,
  }) = _IconBone;

  /// Creates a bone widget that mimics a text
  const factory Bone.text({
    Key? key,
    double? fontSize,
    int? words,
    double? width,
    TextStyle? style,
    TextAlign textAlign,
    BorderRadiusGeometry? borderRadius,
    double? uniRadius,
  }) = _TextBone;

  /// Creates a bone widget that mimics a multi line text
  const factory Bone.multiText({
    Key? key,
    double? fontSize,
    int lines,
    double? width,
    TextStyle? style,
    TextAlign textAlign,
    BorderRadiusGeometry? borderRadius,
    double? uniRadius,
  }) = _MultiTextBone;

  /// Creates a bone widget that mimics a button
  const factory Bone.button({
    Key? key,
    double? width,
    int? words,
    double? height,
    BorderRadiusGeometry? borderRadius,
    BoxShape? shape,
    double? uniRadius,
    double indent,
    double indentEnd,
    BoneButtonType type,
  }) = _ButtonBone;

  /// Creates a bone widget that mimics an icon button
  const factory Bone.iconButton({
    Key? key,
    double? size,
    double indent,
    double indentEnd,
    double? uniRadius,
    BorderRadiusGeometry? borderRadius,
  }) = _IconButtonBone;
}

class _Bone extends Bone {
  /// The default constructor
  const _Bone({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.uniRadius,
    this.indent = 0,
    this.indentEnd = 0,
  }) : assert(uniRadius == null || borderRadius == null),
       super._();

  final double? width, height, uniRadius;
  final double indent, indentEnd;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;

  const _Bone.circle({
    super.key,
    double? size,
    this.indent = 0,
    this.indentEnd = 0,
  }) : width = size,
       height = size,
       borderRadius = null,
       shape = BoxShape.circle,
       uniRadius = null,
       super._();

  const _Bone.square({
    super.key,
    double? size,
    this.indent = 0,
    this.indentEnd = 0,
    this.uniRadius,
    this.borderRadius,
  }) : width = size,
       height = size,
       shape = BoxShape.rectangle,
       super._();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: indent,
        end: indentEnd,
      ),
      child: SizedBox(
        width: width,
        height: height,
        child: BoneRenderObjectWidget(
          decoration: BoxDecoration(
            borderRadius: borderRadius ?? (uniRadius != null ? BorderRadius.circular(uniRadius!) : null),
            shape: shape,
          ),
        ),
      ),
    );
  }
}

class _IconBone extends Bone {
  const _IconBone({
    super.key,
    this.size,
    this.indent = 0,
    this.indentEnd = 0,
  }) : super._();
  final double? size;
  final double indent, indentEnd;

  @override
  Widget build(BuildContext context) {
    return Bone.circle(
      size: size ?? IconTheme.of(context).size ?? 24.0,
      indent: indent,
      indentEnd: indentEnd,
    );
  }
}

/// The type of button bone
enum BoneButtonType {
  /// represents an [ElevatedButton]
  elevated,

  /// represents a [FilledButton]
  filled,

  /// represents a [TextButton]
  text,

  /// represents an [OutlinedButton]
  outlined,
}

class _ButtonBone extends Bone {
  const _ButtonBone({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape,
    this.uniRadius,
    this.indent = 0,
    this.words,
    this.indentEnd = 0,
    this.type = BoneButtonType.elevated,
  }) : assert(uniRadius == null || borderRadius == null),
       assert(width == null || words == null),
       super._();
  final double? width, height, uniRadius;
  final int? words;
  final double indent, indentEnd;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape? shape;
  final BoneButtonType type;

  @override
  Widget build(BuildContext context) {
    final buttonTheme = ButtonTheme.of(context);

    final style = _getStyle(context);
    var effectiveWidth = buttonTheme.minWidth;
    if (width != null) {
      effectiveWidth = width!;
    } else if (words != null) {
      final effectiveFontSize = style.textStyle?.resolve(const {})?.fontSize ?? 14.0;
      effectiveWidth = max(
        effectiveFontSize * words! * 5,
        buttonTheme.minWidth,
      );
    }
    var effectiveBorderRadius = uniRadius != null ? BorderRadius.circular(uniRadius!) : borderRadius;
    var effectiveShape = shape;
    if (effectiveBorderRadius == null) {
      final shapeInfo = _getShape(
        style,
        height ?? buttonTheme.height,
      );
      effectiveBorderRadius = shapeInfo.$1;
      effectiveShape = shapeInfo.$2;
    }

    return Bone(
      width: effectiveWidth,
      height: height ?? buttonTheme.height,
      borderRadius: effectiveBorderRadius,
      shape: effectiveShape ?? BoxShape.rectangle,
      indent: indent,
      indentEnd: indentEnd,
    );
  }

  (BorderRadiusGeometry, BoxShape) _getShape(ButtonStyle style, double height) {
    final shape = style.shape?.resolve(const {});
    return switch (shape.runtimeType) {
      RoundedRectangleBorder _ => (
        (shape as RoundedRectangleBorder).borderRadius,
        BoxShape.rectangle,
      ),
      CircleBorder _ => (BorderRadius.zero, BoxShape.circle),
      StadiumBorder _ => (
        BorderRadius.circular(height / 2),
        BoxShape.rectangle,
      ),
      _ => (BorderRadius.zero, BoxShape.rectangle),
    };
  }

  ButtonStyle _getStyle(BuildContext context) {
    return switch (type) {
      BoneButtonType.elevated =>
        ElevatedButtonTheme.of(context).style ??
            const ElevatedButton(
              onPressed: null,
              child: SizedBox.shrink(),
            ).defaultStyleOf(context),
      BoneButtonType.filled =>
        FilledButtonTheme.of(context).style ??
            const FilledButton(
              onPressed: null,
              child: SizedBox.shrink(),
            ).defaultStyleOf(context),
      BoneButtonType.text =>
        TextButtonTheme.of(context).style ??
            const TextButton(
              onPressed: null,
              child: SizedBox.shrink(),
            ).defaultStyleOf(context),
      BoneButtonType.outlined =>
        OutlinedButtonTheme.of(context).style ??
            const OutlinedButton(
              onPressed: null,
              child: SizedBox.shrink(),
            ).defaultStyleOf(context),
    };
  }
}

class _IconButtonBone extends Bone {
  const _IconButtonBone({
    super.key,
    this.size,
    this.borderRadius,
    this.uniRadius,
    this.indent = 0,
    this.indentEnd = 0,
  }) : assert(uniRadius == null || borderRadius == null),
       super._();
  final double? size, uniRadius;
  final double indent, indentEnd;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    var width = size;
    var height = size;
    if (size == null) {
      final style = IconButtonTheme.of(context).style;
      final iconSize = style?.iconSize?.resolve(const {}) ?? IconTheme.of(context).size ?? 24.0;
      final padding = style?.padding?.resolve(const {}) ?? const EdgeInsets.all(8);
      width = iconSize + padding.horizontal;
      height = iconSize + padding.vertical;
    }
    final effectiveBorderRadius = uniRadius != null ? BorderRadius.circular(uniRadius!) : borderRadius;
    return Bone(
      width: width,
      height: height,
      borderRadius: effectiveBorderRadius,
      shape: effectiveBorderRadius == null ? BoxShape.circle : BoxShape.rectangle,
      indent: indent,
      indentEnd: indentEnd,
    );
  }
}

class _TextBone extends Bone {
  const _TextBone({
    super.key,
    this.fontSize,
    this.words,
    this.width,
    this.style,
    this.textAlign = TextAlign.start,
    this.borderRadius,
    this.uniRadius,
  }) : assert(width == null || words == null),
       super._();
  final double? width;
  final int? words;
  final double? fontSize;
  final TextStyle? style;
  final TextAlign textAlign;
  final BorderRadiusGeometry? borderRadius;
  final double? uniRadius;

  AlignmentGeometry _mapTextAlignToAlignment(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.end:
        return AlignmentDirectional.centerEnd;
      case TextAlign.justify:
        return Alignment.centerLeft;
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      case TextAlign.start:
        return AlignmentDirectional.centerStart;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;

    final effectiveFontSize = fontSize ?? effectiveStyle.fontSize ?? 14.0;
    final effectiveWidth = width ?? effectiveFontSize * (words ?? 3) * 5;

    var effectiveBorderRadius = borderRadius;
    if (uniRadius == null && effectiveBorderRadius == null) {
      final textBorder = Skeletonizer.of(context).config.textBorderRadius;
      effectiveBorderRadius = (textBorder.usesHeightFactor
              ? BorderRadius.circular(
                effectiveFontSize * textBorder.heightPercentage!,
              )
              : textBorder.borderRadius)
          ?.resolve(Directionality.of(context));
    }
    return Align(
      alignment: _mapTextAlignToAlignment(textAlign),
      heightFactor: 1,
      widthFactor: 1,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: max(0, (effectiveStyle.height ?? 1) - effectiveFontSize),
        ),
        child: Bone(
          width: effectiveWidth,
          height: effectiveFontSize,
          borderRadius: effectiveBorderRadius,
          uniRadius: uniRadius,
        ),
      ),
    );
  }
}

class _MultiTextBone extends Bone {
  const _MultiTextBone({
    super.key,
    this.fontSize,
    this.lines = 2,
    this.width,
    this.style,
    this.textAlign = TextAlign.start,
    this.borderRadius,
    this.uniRadius,
  }) : super._();
  final double? width;
  final int lines;
  final double? fontSize;
  final TextStyle? style;
  final TextAlign textAlign;
  final BorderRadiusGeometry? borderRadius;
  final double? uniRadius;

  CrossAxisAlignment _mapTextAlignToAlignment(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return CrossAxisAlignment.center;
      case TextAlign.end:
        return CrossAxisAlignment.end;
      case TextAlign.justify:
        return CrossAxisAlignment.start;
      case TextAlign.left:
        return CrossAxisAlignment.start;
      case TextAlign.right:
        return CrossAxisAlignment.end;
      case TextAlign.start:
        return CrossAxisAlignment.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveStyle = style ?? DefaultTextStyle.of(context).style;
    final effectiveFontSize = fontSize ?? effectiveStyle.fontSize ?? 14.0;
    final effectiveFontHeight = (effectiveStyle.height ?? 1.4) * effectiveFontSize;
    var effectiveBorderRadius = borderRadius;
    if (uniRadius == null && effectiveBorderRadius == null) {
      final textBorder = Skeletonizer.of(context).config.textBorderRadius;
      effectiveBorderRadius = (textBorder.usesHeightFactor
              ? BorderRadius.circular(
                effectiveFontSize * textBorder.heightPercentage!,
              )
              : textBorder.borderRadius)
          ?.resolve(Directionality.of(context));
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: _mapTextAlignToAlignment(textAlign),
          children: [
            for (var i = 0; i < lines; i++)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: (effectiveFontHeight - effectiveFontSize) / 2,
                ),
                child: Bone(
                  width: _getLineWidth(i, width ?? constraints.maxWidth),
                  height: effectiveFontSize,
                  borderRadius: effectiveBorderRadius,
                  uniRadius: uniRadius,
                ),
              ),
          ],
        );
      },
    );
  }

  double _getLineWidth(int line, double width) {
    if (line == lines - 1) return width * .65;
    return width;
  }
}

/// A widget that paints a [BoxDecoration] into a canvas with [ManualSkeletonizerPaintingContext].
class BoneRenderObjectWidget extends SingleChildRenderObjectWidget {
  /// The default constructor
  const BoneRenderObjectWidget({
    super.key,
    super.child,
    required this.decoration,
  });

  /// The decoration of the bone
  final BoxDecoration decoration;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return BoneRenderObject(decoration, Directionality.of(context));
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant BoneRenderObject renderObject,
  ) {
    (renderObject)
      ..decoration = decoration
      ..textDirection = Directionality.of(context);
  }
}

/// The render object of the [BoneRenderObjectWidget]
class BoneRenderObject extends RenderProxyBox {
  /// The default constructor
  BoneRenderObject(
    BoxDecoration decoration,
    TextDirection textDirection,
  ) : _decoration = decoration,
      _textDirection = textDirection;

  BoxDecoration? _decoration;

  set decoration(BoxDecoration? value) {
    if (_decoration != value) {
      _decoration = value;
      markNeedsPaint();
    }
  }

  TextDirection? _textDirection;

  set textDirection(TextDirection? value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_decoration == null) return;
    final paint =
        (context is SkeletonizerPaintingContext) ? context.shaderPaint : Paint()
          ..color = Colors.grey;
    final painter = _BoneBoxDecorationPainter(_decoration!, paint);
    painter.paint(
      context.canvas,
      offset,
      ImageConfiguration(size: size, textDirection: _textDirection),
    );
    super.paint(context, offset);
  }
}

/// An object that paints a [BoxDecoration] into a canvas.
class _BoneBoxDecorationPainter extends BoxPainter {
  _BoneBoxDecorationPainter(this._decoration, this.shaderPaint);

  final BoxDecoration _decoration;
  final Paint shaderPaint;

  void _paintBox(Canvas canvas, Rect rect, TextDirection? textDirection) {
    switch (_decoration.shape) {
      case BoxShape.circle:
        assert(_decoration.borderRadius == null);
        final Offset center = rect.center;
        final double radius = rect.shortestSide / 2.0;
        canvas.drawCircle(center, radius, shaderPaint);
      case BoxShape.rectangle:
        if (_decoration.borderRadius == null || _decoration.borderRadius == BorderRadius.zero) {
          canvas.drawRect(rect, shaderPaint);
        } else {
          canvas.drawRRect(
            _decoration.borderRadius!.resolve(textDirection).toRRect(rect),
            shaderPaint,
          );
        }
    }
  }

  /// Paint the box decoration into the given location on the given canvas.
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);
    final Rect rect = offset & configuration.size!;
    final TextDirection? textDirection = configuration.textDirection;
    _paintBox(canvas, rect, textDirection);
    _decoration.border?.paint(
      canvas,
      rect,
      shape: _decoration.shape,
      borderRadius: _decoration.borderRadius?.resolve(textDirection),
      textDirection: configuration.textDirection,
    );
  }

  @override
  String toString() {
    return 'BoneBoxPainter for $_decoration';
  }
}
