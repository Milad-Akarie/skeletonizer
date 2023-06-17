import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeletonizer/skeletonizer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _enabled = !_enabled;
          });
        },
      ),
      body: false
          ? Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.blue,
              child: ListView(
                children: [
                  for (final i in List.generate(20, (index) => null))
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      child: const ListTile(
                        title: Text('A bit long Title Why is it'),
                        subtitle: Text('Subtitle here'),
                        trailing: Icon(Icons.ac_unit),
                      ),
                    )
                ],
              ),
            )
          : SkeletonizerTheme(
              data: const SkeletonizerThemeData(justifyMultiLineText: true),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Skeletonizer(
                  enabled: _enabled,
                  effect: const ShimmerEffect(highlightColor: Colors.red),
                  child: true
                      ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: double.infinity,
                            height: 100,
                            // RRect.fromLTRBR(8.0, 8.0, 385.0, 108.0, 20.0)
                            child: Material(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.grey,
                              child: Image.network('https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8aW1hZ2V8ZW58MHx8MHx8fDA%3D&w=1000&q=80'),
                            ),
                          ),
                      )
                      : ListView(
                          children: [
                            for (final i in List.generate(20, (index) => index))
                              Card(
                                elevation: .3,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Item number $i with',
                                        maxLines: 2,
                                      ),
                                      subtitle: const Text('Subtitle here'),
                                      trailing: const Skeleton.union(
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
                        ),
                ),
              ),
            ),
    );
  }
}
