import 'package:flutter/material.dart';
import 'package:skeleton_builder/bones.dart';

class TextBoneEditor extends StatelessWidget {
  const TextBoneEditor({
    Key? key,
    required this.child,
    required this.initialConfig,
    required this.onChange,
  }) : super(key: key);
  final TextBone child;
  final TextBoneConfig initialConfig;
  final ValueChanged<TextBoneConfig> onChange;

  @override
  Widget build(BuildContext context) {
    return BoneConfigLayout<TextBoneConfig>(
      initialConfig: initialConfig,
      onChange: onChange,
      contentWidth: 240,
      buildOverlay: (context, notifier) {
        final config = notifier.value;
        return OverlayContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Fixed width')),
                    Checkbox(
                      value: config.fixedWidth,
                      onChanged: (v) {
                        notifier.value = config.copyWith(fixedWidth: v == true);
                      },
                    )
                  ],
                ),
                Row(
                  children: [
                     Text('Radius (${config.radius.toStringAsFixed(0)})'),
                    Expanded(
                      child: Slider(
                        value: config.radius,
                        min: 0,
                        max: 50,
                        divisions: 25,
                        onChanged: (v) {
                          notifier.value = config.copyWith(radius: v);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: child,
    );
  }
}

class TextBoneConfig {
  final double radius;
  final bool fixedWidth;

  const TextBoneConfig({
    this.radius = 0,
    this.fixedWidth = false,
  });

  TextBoneConfig copyWith({
    double? radius,
    bool? fixedWidth,
  }) {
    return TextBoneConfig(
      radius: radius ?? this.radius,
      fixedWidth: fixedWidth ?? this.fixedWidth,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextBoneConfig &&
          runtimeType == other.runtimeType &&
          radius == other.radius &&
          fixedWidth == other.fixedWidth;

  @override
  int get hashCode => radius.hashCode ^ fixedWidth.hashCode;
}

class BoneConfigLayout<T> extends StatefulWidget {
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

class _BoneConfigLayoutState<T> extends State<BoneConfigLayout<T>> {
  bool _hovering = false;
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
  }

  @override
  Widget build(BuildContext context) {
    // print(_hovering);
    return MouseRegion(
      onEnter: (_) {
        print('enter');
        setState(() {
          _hovering = true;
        });
      },
      onHover: (_) {
        print('onhover');
      },
      onExit: (_) {
        setState(() {
          _hovering = false;
        });
      },
      child: GestureDetector(
        onTap: _showOverlay,
        child: DecoratedBox(
          key: _layoutKey,
          decoration: BoxDecoration(
            border: _hovering ? Border.all() : null,
          ),
          child: widget.child,
        ),
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
