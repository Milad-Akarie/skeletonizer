import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skeleton_builder/skeleton_builder.dart';
import 'package:skeleton_builder/src/builder/widget_template.dart';

class SkeletonBuilder extends StatefulWidget {
  const SkeletonBuilder({
    Key? key,
    required this.child,
    this.enabled = kDebugMode,
    this.widgetName,
  }) : super(key: key);

  final Widget child;
  final bool enabled;
  final String? widgetName;

  @override
  State<SkeletonBuilder> createState() => SkeletonBuilderState();
}

const double _menuHeight = 40;

class SkeletonBuilderState extends State<SkeletonBuilder> {
  Widget? _skeletonPreview;
  final _scannerKey = GlobalKey();
  bool _menuExpanded = false;
  double _skeletonOpacity = .7;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return Stack(
      children: [
        SkeletonScanner(
          key: _scannerKey,
          child: widget.child,
          onPreviewReady: (preview) {
            setState(() {
              _skeletonPreview = preview;
            });
          },
        ),
        if (_skeletonPreview != null)
          Opacity(
            opacity: _skeletonOpacity,
            child: _skeletonPreview!,
          ),
        AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 200),
            top: _menuExpanded ? 0 : -_menuHeight,
            start: 48,
            child: Material(
              elevation: 1,
              color: Colors.grey,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              child: Container(
                width: 240,
                height: _menuHeight,
                padding: const EdgeInsetsDirectional.only(start: 0),
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: SliderTheme(
                          data: const SliderThemeData(
                            trackHeight: 2,
                          ),
                          child: Slider(
                            value: _skeletonOpacity,
                            thumbColor: Colors.white70,
                            label: 'Active',
                            activeColor: Colors.white30,
                            inactiveColor: Colors.white12,
                            onChanged: (v) {
                              setState(() {
                                _skeletonOpacity = v;
                              });
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: preview,
                        icon: const Icon(
                          Icons.layers_outlined,
                          color: Colors.white,
                        ),
                      ),
                      const VerticalDivider(
                        width: 8,
                        thickness: 2,
                        color: Colors.white12,
                        indent: 8,
                        endIndent: 8,
                      ),
                      IconButton(
                        onPressed: () {
                          Clipboard.setData(
                            ClipboardData(text: getSkeletonAsText()),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Contented copied to clipboard'),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.copy_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )),
        AnimatedPositionedDirectional(
            duration: const Duration(milliseconds: 200),
            top: 0,
            start: 4,
            width: _menuExpanded ? 40 : 32,
            height: _menuExpanded ? _menuHeight : 24,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _menuExpanded = !_menuExpanded;
                });
              },
              style: FilledButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                elevation: 0,
                padding: EdgeInsets.zero,
                backgroundColor: Colors.grey,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(8),
                  ),
                ),
              ),
              child: AnimatedRotation(
                duration: const Duration(milliseconds: 200),
                turns: _menuExpanded ? .5 : 0,
                child: const Icon(Icons.keyboard_arrow_down_rounded),
              ),
            )),
        if (_menuExpanded)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _menuExpanded = false;
                });
              },
            ),
          ),
      ],
    );
  }

  RenderSkeletonScanner? get scannerRenderer {
    return _scannerKey.currentContext?.findRenderObject() as RenderSkeletonScanner?;
  }

  void preview() {
    final renderer = scannerRenderer;
    if (renderer != null) {
      renderer.scan(preview: true);
    }
  }

  String getSkeletonAsText() {
    final renderer = scannerRenderer;
    if (renderer != null) {
      final describer = renderer.scan();
      if (describer != null) {
        if (widget.widgetName != null) {
          return WidgetTemplate.generate(
            widget.widgetName!,
            describer.bluePrint(4),
          );
        }
        return describer.bluePrint(4);
      }
    }
    return '';
  }
}
