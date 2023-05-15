import 'package:flutter/material.dart';
import 'package:skeleton_builder/bones.dart';
import 'package:skeleton_builder/src/builder/editors/bone_editors.dart';
import 'package:skeleton_builder/src/builder/editors/editor_config.dart';

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
      contentWidth: 250,
      buildOverlay: (context, notifier) {
        final config = notifier.value;
        return OverlayContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                    title: const Text('Include'),
                    value: config.includeBone,
                    onChanged: (v) {
                      notifier.value = config.copyWith(includeBone: v == true);
                    }),
                if (config.includeBone) ...[
                  if (config.canHaveFixedWidth)
                    CheckboxListTile(
                      title: const Text('Fixed width'),
                      value: config.fixedWidth,
                      onChanged: (v) {
                        notifier.value = config.copyWith(fixedWidth: v == true);
                      },
                    ),
                  if (config.fixedWidth)
                    ListTile(
                      title: Text('Width (${config.width.toStringAsFixed(0)})'),
                      trailing: SizedBox(
                        width: 120,
                        child: Slider(
                          value: config.width,
                          min: 1,
                          max: 1000,
                          onChanged: (v) {
                            notifier.value = config.copyWith(width: v);
                          },
                        ),
                      ),
                    )
                  else
                    ListTile(
                      title: Text('Indent (${config.indent.toStringAsFixed(0)})'),
                      trailing: SizedBox(
                        width: 120,
                        child: Slider(
                          value: config.indent,
                          min: 0,
                          max: 150,
                          onChanged: (v) {
                            notifier.value = config.copyWith(indent: v);
                          },
                        ),
                      ),
                    ),
                  ListTile(
                    title: Text('Radius (${config.radius.toStringAsFixed(0)})'),
                    trailing: SizedBox(
                      width: 120,
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
                  ),
                ],
              ],
            ),
          ),
        );
      },
      child: child,
    );
  }
}
