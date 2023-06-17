import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'dart:async';

import 'package:skeletonizer/src/widgets/skeletonizer.dart';

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
    pumpBeforeTest: (tester) => tester.pump(),
    fileName: 'text',
    builder: () => GoldenTestGroup(
      scenarioConstraints: const BoxConstraints(maxWidth: 600),
      children: [
        GoldenTestScenario(
          name: 'Simple English text',
          child: const Skeletonizer(child: Text('English')),
        ),
        GoldenTestScenario(
          name: ' English text with TextAlign.center',
          child: const Skeletonizer(
            child: SizedBox(width: double.infinity, child: Text('English', textAlign: TextAlign.center)),
          ),
        ),
        GoldenTestScenario(
          name: ' English text with TextAlign.right',
          child: const Skeletonizer(
            child: SizedBox(width: double.infinity, child: Text('English', textAlign: TextAlign.right)),
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
  );
  goldenTest(
    'Skeletonize ListTile successfully',
    pumpBeforeTest: (tester) => tester.pump(),
    constraints: const BoxConstraints(maxWidth: 300),
    fileName: 'list_tile',
    builder: () => GoldenTestScenario(
      name: 'Regular ListTile',
      child: const Skeletonizer(
        child: ListTile(
          title: Text('ListTile.title'),
          subtitle: Text('ListTIle.subtitle'),
          trailing: Icon(Icons.ac_unit_outlined),
        ),
      ),
    ),
  );
}
