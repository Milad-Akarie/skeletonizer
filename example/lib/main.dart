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
        child: Padding(
          padding: const EdgeInsets.only(bottom: 110),
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
      ),
      body: Skeletonizer(
        enabled: _enabled,
        child: false
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Skeleton.keep(child: Text('Default')),
                    ),
                    SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        title: Text('Item number 1 as title'),
                        subtitle: Text('Subtitle here'),
                        trailing: Icon(Icons.ac_unit, size: 40),
                      ),
                    ),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Skeleton.keep(child: Text('Kept skeleton')),
                    ),
                    SizedBox(height: 8),
                    Card(
                      child: ListTile(
                        title: Text('Item number 1 as title'),
                        subtitle: Text('Subtitle here'),
                        trailing: Skeleton.keep(
                          child: Icon(Icons.ac_unit, size: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                itemCount: 6,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text('Item number $index as title'),
                      subtitle: const Text('Subtitle here'),
                      trailing: const Icon(Icons.ac_unit),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
