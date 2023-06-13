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
      themeMode: ThemeMode.light,
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
  bool _loading = true;
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
                        for (final i in List.generate(20, (index) => index))
                          ClipRect(
                            clipper: PathCliper(),
                            child: Card(
                              elevation: .3,
                              child: Column(
                                children: [
                                  // ElevatedButton(
                                  //   onPressed: () {},
                                  //   child: const Text("Hello"),
                                  // ),
                                  // SizedBox(height: 40,),
                                  // Chip(label: Text("Chip"),backgroundColor: Colors.red,)
                                  ListTile(
                                    title: Text('Item number $i wiht long test that ma2w2222212ss it',maxLines: 1,),
                                    subtitle: const Text('Subtitle here'),
                                    trailing: const Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [Icon(Icons.ac_unit),
                                        SizedBox(width: 20),
                                        Icon(Icons.access_alarm)],),
                                    leading: const SizedBox(
                                        width: 50,
                                        height: 50,
                                        child: CircleAvatar()),
                                  ),
                                ],
                              ),
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
