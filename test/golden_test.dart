import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'dart:async';

import 'helpers.dart';

void main() => testExecutable(runTests);

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
        platformGoldensConfig: PlatformGoldensConfig(
          theme: ThemeData.light(),
        ),
        ciGoldensConfig: const CiGoldensConfig(enabled: false)),
    run: testMain,
  );
}

void runTests() {
  goldenTest(
    'Skeletonize Text successfully',
    fileName: 'text',
    builder: () => SkeletonizerConfig(
      data: const SkeletonizerConfigData.light(
        effect: SoldColorEffect(color: Colors.green),
      ),
      child: GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 500),
        children: [
          GoldenTestScenario(
            name: 'Simple',
            child: const Skeletonizer(child: Text('English')),
          ),
          GoldenTestScenario(
            name: 'No border radius',
            child: const Skeletonizer(
              textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.zero),
              child: Text('English'),
            ),
          ),
          GoldenTestScenario(
            name: ' With TextAlign.center',
            child: const Skeletonizer(
              child: SizedBox(width: double.infinity, child: Text('English', textAlign: TextAlign.center)),
            ),
          ),
          GoldenTestScenario(
            name: ' With TextAlign.right',
            child: const Skeletonizer(
              child: SizedBox(width: double.infinity, child: Text('English', textAlign: TextAlign.right)),
            ),
          ),
          GoldenTestScenario(
            name: 'JustifyMultiLineText on',
            child: const Skeletonizer(
              justifyMultiLineText: true,
              child: SizedBox(
                width: 300,
                child: Text(
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout'),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'JustifyMultiLineText off',
            child: const Skeletonizer(
              justifyMultiLineText: false,
              child: SizedBox(
                width: 300,
                child: Text(
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout'),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Simple RTL text',
            child: const Skeletonizer(
                child: SizedBox(
              width: double.infinity,
              child: Text('نص عربي', textDirection: TextDirection.rtl),
            )),
          ),
          GoldenTestScenario(
            name: 'Icon text',
            child: const Skeletonizer(child: Icon(Icons.ac_unit_outlined)),
          ),
        ],
      ),
    ),
  );

  goldenTest(
    'Skeletonize containers successfully',
    fileName: 'container',
    builder: () => SkeletonizerConfig(
      data: const SkeletonizerConfigData.light(
        effect: SoldColorEffect(color: Colors.green),
      ),
      child: GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 500),
        children: [
          GoldenTestScenario(
            name: 'Card',
            child: Skeletonizer(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Material',
            child: Skeletonizer(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Material(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Container',
            child: Skeletonizer(
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Container with border',
            child: Skeletonizer(
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Container:BoxShape.circle',
            child: Skeletonizer(
              child: Container(
                width: 200,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'DecoratedBox',
            child: Skeletonizer(
              child: SizedBox(
                width: 200,
                height: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ColoredBox',
            child: const Skeletonizer(
              child: SizedBox(
                width: 200,
                height: 100,
                child: ColoredBox(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  goldenTest(
    'Skeletonize containers without drawing them successfully',
    fileName: 'ignored_container',
    builder: () => SkeletonizerConfig(
      data: const SkeletonizerConfigData.light(
        effect: SoldColorEffect(color: Colors.green),
        ignoreContainers: true,
      ),
      child: GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 500),
        children: [
          GoldenTestScenario(
            name: 'Card',
            child: Skeletonizer(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Foo"),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Material',
            child: Skeletonizer(
              child: SizedBox(
                width: 200,
                height: 100,
                child: Material(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Foo"),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Container',
            child: Skeletonizer(
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: const Text("Foo"),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Container:BoxShape.circle',
            child: Skeletonizer(
              child: Container(
                width: 200,
                height: 100,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Text("Foo"),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Container with border',
            child: Skeletonizer(
              child: Container(
                width: 200,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(),
                ),
                child: const Text("Foo"),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'DecoratedBox',
            child: Skeletonizer(
              child: SizedBox(
                width: 200,
                height: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                  child: const Text("Foo"),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ColoredBox',
            child: const Skeletonizer(
              child: SizedBox(
                width: 200,
                height: 100,
                child: ColoredBox(
                  color: Colors.white,
                  child: Text("Foo"),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
  goldenTest(
    'Skeletonize ListTile successfully',
    fileName: 'list_tile',
    builder: () => SkeletonizerConfig(
      data: const SkeletonizerConfigData.light(
        effect: SoldColorEffect(color: Colors.green),
      ),
      child: GoldenTestGroup(
        children: [
          GoldenTestScenario(
            name: 'Regular ListTile',
            child: const Skeletonizer(
              child: SizedBox(
                width: 300,
                child: ListTile(
                  title: Text('ListTile.title'),
                  subtitle: Text('ListTIle.subtitle'),
                  trailing: Icon(Icons.ac_unit_outlined),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ListTile inside a card',
            child: const Skeletonizer(
              child: SizedBox(
                width: 300,
                child: Card(
                  child: ListTile(
                    title: Text('ListTile.title'),
                    subtitle: Text('ListTIle.subtitle'),
                    trailing: Icon(Icons.ac_unit_outlined),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ListTile inside a decoratedBox',
            child: Skeletonizer(
              child: SizedBox(
                width: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: const ListTile(
                    title: Text('ListTile.title'),
                    subtitle: Text('ListTIle.subtitle'),
                    trailing: Icon(Icons.ac_unit_outlined),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ListTile inside a decoratedBox:boxShadow',
            child: Skeletonizer(
              child: SizedBox(
                width: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(3, 3),
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: const ListTile(
                    title: Text('ListTile.title'),
                    subtitle: Text('ListTIle.subtitle'),
                    trailing: Icon(Icons.ac_unit_outlined),
                  ),
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ListTile inside a decoratedBox:border',
            child: Skeletonizer(
              child: SizedBox(
                width: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(),
                  ),
                  child: const ListTile(
                    title: Text('ListTile.title'),
                    subtitle: Text('ListTIle.subtitle'),
                    trailing: Icon(Icons.ac_unit_outlined),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  goldenTest(
    'Skeletonize with annotations successfully',
    fileName: 'skeleton_annotations',
    builder: () => SkeletonizerConfig(
      data: const SkeletonizerConfigData.light(
        effect: SoldColorEffect(color: Colors.green),
      ),
      child: GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 500),
        children: [
          GoldenTestScenario(
            name: 'ignore',
            child: const Skeletonizer(
              child: Skeleton.ignore(
                child: Icon(Icons.ac_unit_outlined),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'replace',
            child: const Skeletonizer(
              child: Skeleton.replace(
                replacement: Text('Replaced'),
                child: Icon(Icons.ac_unit_outlined),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'keep',
            child: const Skeletonizer(
              child: Skeleton.keep(child: Icon(Icons.ac_unit_outlined)),
            ),
          ),
          GoldenTestScenario(
            name: 'shade',
            child: const Skeletonizer(
              effect: SoldColorEffect(color: Colors.red),
              child: Skeleton.shade(
                  child: Icon(
                Icons.ac_unit_outlined,
              )),
            ),
          ),
          GoldenTestScenario(
            name: 'unite',
            child: const Skeletonizer(
              child: Skeleton.unite(
                  child: Row(
                children: [
                  Icon(Icons.ac_unit_outlined),
                  SizedBox(width: 20),
                  Icon(Icons.ac_unit_outlined),
                  Icon(Icons.ac_unit_outlined),
                ],
              )),
            ),
          ),
          GoldenTestScenario(
            name: 'unite:borderRadius',
            child: const Skeletonizer(
              child: Skeleton.unite(
                  annotation: UniteDescendents(borderRadius: BorderRadius.zero),
                  child: Row(
                    children: [
                      Icon(Icons.ac_unit_outlined),
                      SizedBox(width: 20),
                      Icon(Icons.ac_unit_outlined),
                      Icon(Icons.ac_unit_outlined),
                    ],
                  )),
            ),
          )
        ],
      ),
    ),
  );

  goldenTest(
    'Skeletonize clippers successfully',
    fileName: 'clippers',
    builder: () => SkeletonizerConfig(
      data: const SkeletonizerConfigData.light(
        effect: SoldColorEffect(color: Colors.green),
      ),
      child: GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 500),
        children: [
          GoldenTestScenario(
            name: 'ClipRRect',
            child: Skeletonizer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ClipRRect:Clip.none',
            child: Skeletonizer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                clipBehavior: Clip.none,
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ClipOval',
            child: Skeletonizer(
              child: ClipOval(
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ClipOval:Clip.none',
            child: Skeletonizer(
              child: ClipOval(
                clipBehavior: Clip.none,
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ClipPath',
            child: Skeletonizer(
              child: ClipPath(
                clipper: TestPathClipper(),
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'ClipPath:Clip.none',
            child: Skeletonizer(
              child: ClipPath(
                clipper: TestPathClipper(),
                clipBehavior: Clip.none,
                child: Container(
                  color: Colors.green,
                  width: 100,
                  height: 50,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  goldenTest(
    'Skeletonize transformers successfully',
    fileName: 'transformers',
    builder: () => SkeletonizerConfig(
      data: const SkeletonizerConfigData.light(
        effect: SoldColorEffect(color: Colors.green),
      ),
      child: GoldenTestGroup(
        scenarioConstraints: const BoxConstraints(maxWidth: 500),
        children: [
          GoldenTestScenario(
            name: 'Transform.scale',
            child: Skeletonizer(
              child: Transform.scale(
                scale: 1.3,
                child: Container(
                  color: Colors.green,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Transform.translate',
            child: Skeletonizer(
              child: Transform.translate(
                offset: const Offset(50, 0),
                child: Container(
                  color: Colors.green,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'Transform.rotate',
            child: Skeletonizer(
              child: Transform.rotate(
                angle: 1,
                child: Container(
                  color: Colors.green,
                  width: 50,
                  height: 50,
                ),
              ),
            ),
          ),
          GoldenTestScenario(
            name: 'RotatedBox',
            child: Skeletonizer(
              child: RotatedBox(
                quarterTurns: 2,
                child: Container(
                  color: Colors.green,
                  width: 50,
                  height: 70,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
