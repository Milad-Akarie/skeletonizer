import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:skeletonizer/src/painting/skeletonizer_painting_context.dart';

abstract class Bone extends StatelessWidget {
  const Bone._({super.key});

  /// Creates a default bone widget
  const factory Bone({
    Key? key,
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    BoxShape shape,
    double? circleRadius,
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
    double? circleRadius,
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
    double? circleRadius,
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
    double? circleRadius,
  }) = _MultiTextBone;

  /// Creates a bone widget that mimics a button
  const factory Bone.button({
    Key? key,
    double? width,
    double? height,
    BorderRadiusGeometry? borderRadius,
    BoxShape? shape,
    double? circleRadius,
    double indent,
    double indentEnd,
  }) = _ButtonBone;
}




class _Bone extends Bone {
  /// The default constructor
  const _Bone({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
    this.circleRadius,
    this.indent = 0,
    this.indentEnd = 0,
  })  : assert(circleRadius == null || borderRadius == null),
        super._(key: key);

  final double? width, height, circleRadius;
  final double indent, indentEnd;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;

  const _Bone.circle({
    Key? key,
    double? size,
    this.indent = 0,
    this.indentEnd = 0,
  })  : width = size,
        height = size,
        borderRadius = null,
        shape = BoxShape.circle,
        circleRadius = null,
        super._(key: key);

  const _Bone.square({
    Key? key,
    double? size,
    this.indent = 0,
    this.indentEnd = 0,
    this.circleRadius,
    this.borderRadius,
  })  : width = size,
        height = size,
        shape = BoxShape.rectangle,
        super._(key: key);

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
            borderRadius: borderRadius ?? (circleRadius != null ? BorderRadius.circular(circleRadius!) : null),
            shape: shape,
          ),
        ),
      ),
    );
  }
}

class _IconBone extends Bone {
  const _IconBone({
    Key? key,
    this.size,
    this.indent = 0,
    this.indentEnd = 0,
  }) : super._(key: key);
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

class _ButtonBone extends Bone {
  const _ButtonBone({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.shape,
    this.circleRadius,
    this.indent = 0,
    this.indentEnd = 0,
  })  : assert(circleRadius == null || borderRadius == null),
        super._(key: key);
  final double? width, height, circleRadius;
  final double indent, indentEnd;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    final buttonTheme = ButtonTheme.of(context);
    final buttonShape = buttonTheme.shape;

    final effectiveShape = shape ?? (buttonShape is RoundedRectangleBorder ? BoxShape.rectangle : BoxShape.circle);
    final effectiveBorderRadius =
        borderRadius ?? (buttonShape is RoundedRectangleBorder ? buttonShape.borderRadius : null);

    return Bone(
      width: width ?? buttonTheme.minWidth,
      height: height ?? buttonTheme.height,
      borderRadius: effectiveBorderRadius,
      shape: effectiveShape,
      circleRadius: circleRadius,
      indent: indent,
      indentEnd: indentEnd,
    );
  }
}

class _TextBone extends Bone {
  const _TextBone({
    Key? key,
    this.fontSize,
    this.words,
    this.width,
    this.style,
    this.textAlign = TextAlign.start,
    this.borderRadius,
    this.circleRadius,
  })  : assert(width == null || words == null),
        super._(key: key);
  final double? width;
  final int? words;
  final double? fontSize;
  final TextStyle? style;
  final TextAlign textAlign;
  final BorderRadiusGeometry? borderRadius;
  final double? circleRadius;

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
    final effectiveFontSize = fontSize ?? style?.fontSize ?? DefaultTextStyle.of(context).style.fontSize ?? 14.0;
    final effectiveWidth = width ?? effectiveFontSize * (words ?? 3) * 5;
    var effectiveBorderRadius = borderRadius;
    if (circleRadius == null && effectiveBorderRadius == null) {
      final textBorder = Skeletonizer.of(context).config.textBorderRadius;
      effectiveBorderRadius = (textBorder.usesHeightFactor
              ? BorderRadius.circular(effectiveFontSize * textBorder.heightPercentage!)
              : textBorder.borderRadius)
          ?.resolve(Directionality.of(context));
    }
    return Align(
      alignment: _mapTextAlignToAlignment(textAlign),
      child: Bone(
        width: effectiveWidth,
        height: effectiveFontSize,
        borderRadius: effectiveBorderRadius,
        circleRadius: circleRadius,
      ),
    );
  }
}

class _MultiTextBone extends Bone {
  const _MultiTextBone({
    Key? key,
    this.fontSize,
    this.lines = 2,
    this.width,
    this.style,
    this.textAlign = TextAlign.start,
    this.borderRadius,
    this.circleRadius,
  }) : super._(key: key);
  final double? width;
  final int lines;
  final double? fontSize;
  final TextStyle? style;
  final TextAlign textAlign;
  final BorderRadiusGeometry? borderRadius;
  final double? circleRadius;

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
    if (circleRadius == null && effectiveBorderRadius == null) {
      final textBorder = Skeletonizer.of(context).config.textBorderRadius;
      effectiveBorderRadius = (textBorder.usesHeightFactor
              ? BorderRadius.circular(effectiveFontSize * textBorder.heightPercentage!)
              : textBorder.borderRadius)
          ?.resolve(Directionality.of(context));
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        crossAxisAlignment: _mapTextAlignToAlignment(textAlign),
        children: [
          for (var i = 0; i < lines; i++)
            Padding(
              padding: EdgeInsets.symmetric(vertical: (effectiveFontHeight - effectiveFontSize) / 2),
              child: Bone(
                width: _getLineWidth(i, width ?? constraints.maxWidth),
                height: effectiveFontSize,
                borderRadius: effectiveBorderRadius,
                circleRadius: circleRadius,
              ),
            ),
        ],
      );
    });
  }

  double _getLineWidth(int line, double width) {
    if (line == lines - 1) return width * .65;
    return width;
  }
}

class BoneRenderObjectWidget extends SingleChildRenderObjectWidget {
  /// The default constructor
  const BoneRenderObjectWidget({
    super.key,
    super.child,
    required this.decoration,
  });

  final BoxDecoration decoration;

  @override
  RenderObject createRenderObject(BuildContext context) {
    return BoneRenderObject(decoration, Directionality.of(context));
  }

  @override
  void updateRenderObject(BuildContext context, covariant BoneRenderObject renderObject) {
    (renderObject)
      ..decoration = decoration
      ..textDirection = Directionality.of(context);
  }
}

class BoneRenderObject extends RenderProxyBox {
  /// The default constructor
  BoneRenderObject(
    BoxDecoration decoration,
    TextDirection textDirection,
  )   : _decoration = decoration,
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
    assert(context is ManualSkeletonizerPaintingContext, 'Bone must be a child of a Skeletonizer.manual widget');
    final skeletonizerContext = context as ManualSkeletonizerPaintingContext;
    if (_decoration == null) return;
    final painter = _BoneBoxDecorationPainter(_decoration!, skeletonizerContext.shaderPaint);
    painter.paint(context.canvas, offset, ImageConfiguration(size: size, textDirection: _textDirection));
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
          canvas.drawRRect(_decoration.borderRadius!.resolve(textDirection).toRRect(rect), shaderPaint);
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
