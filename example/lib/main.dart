import 'package:material_ui/material_ui.dart';
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
      home: const SkeletonizerDemoPage(),
      builder: (context, child) => SkeletonizerConfig(
        data: SkeletonizerConfigData(
          brightness: Theme.of(context).brightness,
          // this is already the default, just showing usage of the effectResolver
          effectResolver: (brightness) => switch (brightness) {
            Brightness.light => const ShimmerEffect(),
            Brightness.dark => const ShimmerEffect.dark(),
          },
        ),
        child: child!,
      ),
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
      appBar: AppBar(title: const Text('Skeletonizer Demo')),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 0, right: 4),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 110),
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
      ),
      body: Skeletonizer(
        enabled: _enabled,
        enableSwitchAnimation: true,
        child: ListView.builder(
          itemCount: 6,
          padding: const EdgeInsets.all(16),
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text('Item number $index as title'),
                subtitle: const Text('Subtitle here'),
                trailing: const Icon(
                  Icons.ac_unit,
                  size: 32,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
