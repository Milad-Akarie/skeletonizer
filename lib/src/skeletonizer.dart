import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeleton_builder/skeleton_builder.dart';
import 'package:skeleton_builder/src/builder/widget_template.dart';
import 'package:skeleton_builder/src/skeletonizer_element.dart';

class Skeletonizer extends StatefulWidget {
  const Skeletonizer({
    Key? key,
    required this.child,
    required this.loading,
  }) : super(key: key);

  final Widget child;
  final bool loading;

  @override
  State<Skeletonizer> createState() => SkeletonizerState();
}

class SkeletonizerState extends State<Skeletonizer> {
  Widget? _skeletonLayout;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SkeletonizerElement(
          child: Offstage(
            offstage: widget.loading,
            child: widget.child,
          ),
          onSkeletonReady: (preview) {
            setState(() {
              _skeletonLayout = preview;
            });
          },
        ),
        if (_skeletonLayout != null && widget.loading) _skeletonLayout!
      ],
    );
  }

}
