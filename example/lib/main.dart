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
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Skeletonizer Demo'),
      ),
      floatingActionButton: FloatingActionButton(
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
      body: Skeletonizer(
          enabled: _enabled,
          child: ListView(
            children: [
              for (final i in List.generate(20, (index) => index))
                Card(
                  elevation: .3,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text('Item number $i with'),
                        subtitle: const Text('Subtitle here'),
                        trailing: const Skeleton.shade(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.ac_unit),
                              SizedBox(width: 20),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Icon(Icons.access_alarm),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          )),
    );
  }
}
