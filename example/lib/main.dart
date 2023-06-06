import 'package:flutter/material.dart';
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
      theme: ThemeData.light(
          // primarySwatch: Colors.blue,
          ),
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
      body: Skeletonizer(
        key: _scannerKey,
        loading: _loading,
        child: ListView(
          children: [
            for (final i in List.generate(10, (index) => null))
              Card(
                elevation: .3,
               shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(20)
               ),
                child: const ListTile(
                  title: Text('A bit long Title Why is it'),
                  subtitle: Text('Subtitle here'),
                  trailing: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.ac_unit),
                  )
                ),
              )
          ],
        ),
      ),
    );
  }
}
