import 'package:flutter/material.dart';
import 'package:skeleton_builder/bones.dart';
import 'package:skeleton_builder/src/builder/editors/bone_editors.dart';
import 'package:skeleton_builder/src/builder/editors/editor_config.dart';

class BoxBoneEditor extends StatelessWidget {
  const BoxBoneEditor({
    Key? key,
    required this.child,
    required this.initialConfig,
    required this.onChange,
  }) : super(key: key);
  final Widget child;
  final BoxBoneConfig initialConfig;
  final ValueChanged<BoxBoneConfig> onChange;

  @override
  Widget build(BuildContext context) {
    return BoneConfigLayout<BoxBoneConfig>(
      initialConfig: initialConfig,
      onChange: onChange,
      contentWidth: 250,
      buildOverlay: (context, notifier) {
        final config = notifier.value;
        return OverlayContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
            child: Column(
              children: [
                CheckboxListTile(
                    title: const Text('Include'),
                    value: config.includeBone,
                    onChanged: (v) {
                      notifier.value = config.copyWith(includeBone: v == true);
                    }),
                if (config.includeBone) ...[
                  if (config.canBeContainer)
                    CheckboxListTile(
                      title: const Text('Treat as bone'),
                      value: config.treatAsBone,
                      onChanged: (v) {
                        notifier.value = config.copyWith(treatAsBone: v == true);
                      },
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
