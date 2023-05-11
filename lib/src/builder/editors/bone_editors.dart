import 'package:flutter/material.dart';
import 'package:skeleton_builder/src/builder/editors/editor_config.dart';

class OverlayContainer extends StatelessWidget {
  const OverlayContainer({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(
            color: Colors.white70,
          ),
          sliderTheme: const SliderThemeData(
            thumbColor: Colors.white70,
            activeTrackColor: Colors.white30,
            inactiveTrackColor: Colors.white12,
          ),
          listTileTheme: const ListTileThemeData(
            textColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(horizontal: 10),
            dense: true,
          ),
          checkboxTheme: CheckboxThemeData(
            checkColor: MaterialStateProperty.all(Colors.white),
            side: const BorderSide(
              color: Colors.white70,
              width: 1.5,
            ),
          ),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(color: Colors.white),
          child: child,
        ),
      ),
    );
  }
}

class BoneConfigLayout<T extends BoneConfig> extends StatefulWidget {
  const BoneConfigLayout({
    Key? key,
    required this.child,
    required this.buildOverlay,
    required this.initialConfig,
    required this.onChange,
    required this.contentWidth,
  }) : super(key: key);

  final Widget child;
  final T initialConfig;
  final ValueChanged<T> onChange;
  final double contentWidth;
  final Widget Function(
    BuildContext context,
    ValueNotifier<T> notifier,
  ) buildOverlay;

  @override
  State<BoneConfigLayout> createState() => _BoneConfigLayoutState<T>();
}

class _BoneConfigLayoutState<T extends BoneConfig> extends State<BoneConfigLayout<T>> {
  OverlayEntry? _overlayEntry;
  final _layoutKey = GlobalKey();
  late final _overlayStateNotifier = ValueNotifier<T>(widget.initialConfig);

  @override
  void initState() {
    super.initState();
    _overlayStateNotifier.addListener(_onChange);
  }

  @override
  void dispose() {
    _overlayStateNotifier.removeListener(_onChange);
    _overlayStateNotifier.dispose();
    super.dispose();
  }

  void _onChange() {
    widget.onChange(_overlayStateNotifier.value);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: _layoutKey,
      onTap: _showOverlay,
      child: Opacity(
        opacity: _overlayStateNotifier.value.includeBone ? 1 : .2,
        child: widget.child,
      ),
    );
  }

  void _showOverlay() async {
    RenderBox? renderBox = _layoutKey.currentContext?.findRenderObject() as RenderBox?;
    Offset offset = renderBox!.localToGlobal(Offset.zero);

    final overlayState = Overlay.of(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final xPos = (offset.dx > screenWidth / 2) ? (offset.dx - widget.contentWidth) + renderBox.size.width : offset.dx;

    _overlayEntry = OverlayEntry(builder: (context) {
      return ValueListenableBuilder(
          valueListenable: _overlayStateNotifier,
          builder: (context, _, __) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _dismiss,
                  ),
                ),
                Positioned(
                  left: xPos,
                  top: offset.dy + renderBox.size.height + 10,
                  width: widget.contentWidth,
                  child: DefaultTextStyle(
                    style: const TextStyle(color: Colors.white70),
                    child: widget.buildOverlay(context, _overlayStateNotifier),
                  ),
                ),
              ],
            );
          });
    });
    overlayState.insert(_overlayEntry!);
  }

  void _dismiss() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }
}

