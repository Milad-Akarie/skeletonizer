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
      body: Skeletonizer.manual(
        enabled: _enabled,
        // effect: const SoldColorEffect(
        //   color: Colors.red,
        // ),
        child: ListView.builder(
          itemCount: 1,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Column(
              children: [
                const Card(
                  child: ListTile(
                    title: Bone.text(words: 2),
                    subtitle: Bone.text(),
                    trailing: Bone.icon(size: 32),
                  ),
                ),
                FilledButton(
                  onPressed: () {},
                  child: const Text('Hello'),
                ),
                Bone.button()
              ],
            );
          },
        ),
      ),
    );
  }
}
