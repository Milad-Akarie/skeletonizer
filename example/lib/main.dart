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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Skeleton.keep(child: Text('Shimmer effect')),
                  ),
                  Skeletonizer(
                    child: Column(
                      children: [
                        for (final i in [0, 1])
                          const Card(
                            child: ListTile(
                              title: Text('Item number 1 as title'),
                              subtitle: Text('Subtitle here'),
                              trailing: Icon(Icons.ac_unit, size: 32),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Skeleton.keep(child: Text('Pulse effect')),
                  ),
                  Skeletonizer(
                    effect: PulseEffect(from: Colors.grey.shade300, to: Colors.grey.shade200),
                    child: Column(
                      children: [
                        for (final i in [0, 1])
                          const Card(
                            child: ListTile(
                              title: Text('Item number 1 as title'),
                              subtitle: Text('Subtitle here'),
                              trailing: Icon(Icons.ac_unit, size: 32),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Skeleton.keep(child: Text('Sold color effect')),
                  ),
                  Skeletonizer(
                    effect: SoldColorEffect(color: Colors.grey.shade300),
                    child: Column(
                      children: [
                        for (final i in [0, 1])
                          const Card(
                            child: ListTile(
                              title: Text('Item number 1 as title'),
                              subtitle: Text('Subtitle here'),
                              trailing: Icon(Icons.ac_unit, size: 32),
                            ),
                          ),
                      ],
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
