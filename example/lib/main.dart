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
      body: Skeletonizer(
        enabled: _enabled,
        effect: const SoldColorEffect(color: Colors.green),
        // effect: const ShimmerEffect(
        //   highlightColor: Colors.green,
        // ),
        child: true
            ? Center(
                child: Card(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Container(
                       color: Colors.purple,
                         width: 100,
                         height: 200,
                         // child: const Column(
                         //   mainAxisSize: MainAxisSize.min,
                         //   children: [
                         //     Text(
                         //       'Hello World! how are you?',
                         //       style: TextStyle(fontSize: 20),
                         //     ),
                         //     SizedBox(height: 8),
                         //     Text('Hello World! how are '),
                         //   ],
                         // ),
                       ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              )),
                          child: const Center(child: Text('Hello')),
                        ),
                      ),
                    ],
                  ),
                )),
              )
            : false
                ? Column(
                    children: [
                      for (int i = 0; i < 7; i++)
                        const Card(
                          child: ListTile(
                            title: Text('Item number as title'),
                            subtitle: Text('Subtitle here'),
                            trailing: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.red),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Skeleton.ignore(
                                  child: Icon(Icons.ac_unit),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  )
                : ListView.builder(
                    itemCount: 7,
                    padding: const EdgeInsets.all(16),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text('Item number $index as title'),
                          subtitle: const Text('Subtitle here'),
                          trailing: const Skeleton.unite(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            child: CircleAvatar(
                              child: Icon(Icons.ac_unit, size: 32),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // draw a circle with defined paint
    final paint = Paint()..color = Colors.red;

    canvas.drawCircle(const Offset(50, 50), 40, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
