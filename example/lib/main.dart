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
  bool _loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _loading = !_loading;
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
            data: const SkeletonizerThemeData(
              justifyMultiLineText: true
            ),
            child: Skeletonizer(
                enabled: _loading,
                effect: const ShimmerEffect(highlightColor: Colors.red),
                child: true ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('However, now I am trying to test howowlkwlkjwlkjwlsdlkfjsldkfj the intrinsic sof the underlying render object.'),
                ): ListView(
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
