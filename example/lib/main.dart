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
  final  _links = <int,LayerLink>{};
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
            _enabled
                ? Icons.hourglass_bottom_rounded
                : Icons.hourglass_disabled_outlined,
          ),
          onPressed: () {
            setState(() {
              _enabled = !_enabled;
            });
          },
        ),
      ),
      body: Skeletonizer(
        enabled: _enabled,
        effect: const SoldColorEffect(color: Colors.green),
        child: ListView.builder(
          itemCount: 5,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return CompositedTransformTarget(
              link: _links.putIfAbsent(index, () => LayerLink()),
              child: Card(
                child: ListTile(
                  title: Text('Item number $index as title'),
                  subtitle: const Text('Subtitle here'),
                  trailing: const CircleAvatar(child: Skeleton.ignore(child: Icon(Icons.ac_unit))),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
