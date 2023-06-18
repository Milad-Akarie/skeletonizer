import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Skeletonizer Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      home: const SkeletonizerDemoPage(),
    );
  }
}

class SkeletonizerDemoPage extends StatefulWidget {
  const SkeletonizerDemoPage({super.key});

  @override
  State<SkeletonizerDemoPage> createState() => _SkeletonizerDemoPageState();
}

class _SkeletonizerDemoPageState extends State<SkeletonizerDemoPage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skeletonizer Demo'),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0, right: 4),
        child: FloatingActionButton(
          child: Icon(
            _enabled ? Icons.hourglass_bottom_rounded : Icons.hourglass_disabled_outlined,
          ),
          onPressed: () {
            setState(() {
              _enabled = !_enabled;
            });
          },
        ),
      ),
      body: true
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Skeleton.keep(child: Text('Fixed Text border radius')),
                  ),
                  Skeletonizer(
                    textBoneBorderRadius: TextBoneBorderRadius(BorderRadius.circular(8)),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Item number 1 as title',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Item number 1 as title',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Skeleton.keep(child: Text('TextBoneBorderRadius.fromHeightFactor(.5)')),
                  ),
                  const Skeletonizer(
                    textBoneBorderRadius: TextBoneBorderRadius.fromHeightFactor(.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Item number 1 as title',
                          style: TextStyle(fontSize: 30),
                        ),
                        Text(
                          'Item number 1 as title',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Skeleton.keep(child: Text('JustifyMultiLine set to true (default)')),
                  ),
                  Skeletonizer(
                    child: Text(
                      'Item number 1 as title Item number 1 as title Item number 1 as title Item number 1 as title Item number 1 as title Item number 1 as title',
                    ),

                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Skeleton.keep(child: Text('JustifyMultiLine set to false')),
                  ),
                  Skeletonizer(
                    justifyMultiLineText: false,
                    child: Text(
                      'Item number 1 as title Item number 1 as title Item number 1 as title Item number 1 as title Item number 1 as title Item number 1 as title',
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: 7,
              padding: const EdgeInsets.all(16),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text('Item number $index as title'),
                    subtitle: const Text('Subtitle here'),
                    trailing: const Icon(Icons.ac_unit, size: 40),
                  ),
                );
              },
            ),
    );
  }
}
