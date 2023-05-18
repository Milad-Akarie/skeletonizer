import 'package:flutter/material.dart';

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
          child: child,
          // child: ShaderMask(
          //   shaderCallback: (Rect bounds) {
          //     return const LinearGradient(colors: [
          //       Colors.red,
          //       Colors.blue,
          //     ], begin: Alignment.topRight, end: Alignment.bottomLeft)
          //         .createShader(Offset.zero & MediaQuery.of(context).size);
          //   },
          //   child: child,
          // ),
        ),
      ),
    );
  }
}
