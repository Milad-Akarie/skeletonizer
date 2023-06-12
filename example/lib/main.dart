import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:skeleton_builder/skeleton_builder.dart';

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
      themeMode: ThemeMode.dark,
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
  bool _loading = false;
  final _scannerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _loading = !_loading;
            _scannerKey.currentState?.setState(() {});
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
          : Skeletonizer(
            enabled: _loading,
            child: false
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRect(
                      clipper: PathCliper(),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: const BoxDecoration(
                          color: Colors.grey,
                        ),
                        // child: const Text(
                        //   'A very long text that goes mulitple line here so yes that ',
                        //   style: TextStyle(fontSize: 18),
                        // ),
                      ),
                    ),
                  )
                : ListView(
                    children: [
                      for (final i in List.generate(20, (index) => null))
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 4),
                          child: Column(
                            children: [
                              AspectRatio(
                                aspectRatio: 1.5,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Skeleton.shade(
                                    child: Image.network(
                                        'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2940&q=80'),
                                  ),
                                ),
                              ),
                              ListTile(
                                title: Text('A bit long Title Why'),
                                subtitle: Text('Subtitle here'),
                                trailing: ElevatedButton(onPressed: () {}, child: Text('Hello')),
                              ),
                            ],
                          ),
                        )
                    ],
                  ),
          ),
    );
  }
}

class PathCliper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return const Rect.fromLTWH(0, 0, 50, 50);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }
}
