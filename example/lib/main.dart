import 'dart:math';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  Widget? overlay;
  final _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   print(_cardKey?.currentContext?.size);
    // });
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                final renderBox = _key.currentContext?.findRenderObject() as RenderSkeletonScanner;
                renderBox.visitAll();
              },
              icon: const Icon(Icons.layers_outlined))
        ],
      ),
      body: Stack(
        children: [
          // if(overlay == null)

          Opacity(
            opacity: overlay == null ? 1 : .2,
            child: SkeletonScanner(
              key: _key,
              onLayout: (layout) {
                setState(() {
                  overlay = layout;
                });
              },
              child: Column(
                children: [
                  // const Padding(
                  //   padding: EdgeInsets.all(20.0),
                  //   child: Text(
                  //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                  //       style: TextStyle(fontSize: 20),
                  //   ),
                  // ),
                  // Card(
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //   child: const Text("Hello"),
                  // ),
                  // if (false)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: () {}, child: const Text('Hello')),
                  ),
                  Expanded(
                    child: ListView(
                      children: [
                        for (var i in [0, 1, 2])
                          Card(
                            margin: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 2 / 1,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Container(
                                          width: 65,
                                          height: 65,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: const [
                                          Text(
                                            'Hello there that is kinda long',
                                            textAlign: TextAlign.end,
                                            textDirection: TextDirection.rtl,
                                          ),
                                          SizedBox(height: 8),
                                          Text("Im a subtitle"),
                                        ],
                                      )),
                                      const SizedBox(width: 20)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

class TextBone extends StatelessWidget {
  const TextBone({
    Key? key,
    required this.lineHeight,
    required this.lineLength,
    required this.lineSpacing,
    this.width,
    this.height,
    this.maxLines,
  }) : super(key: key);

  final double lineHeight;
  final double lineSpacing;
  final double lineLength;
  final double? width;
  final double? height;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: LayoutBuilder(builder: (context, constrains) {
        final width = constrains.maxWidth;
        final actualLineCount = (lineLength / width).ceil();
        var lineCount = maxLines == null ? actualLineCount : min(maxLines!, actualLineCount);
        if (constrains.hasBoundedHeight && lineCount * (lineHeight + lineSpacing) > constrains.maxHeight) {
          lineCount = (constrains.maxHeight / (lineHeight * lineSpacing)).round();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < lineCount; i++)
              Container(
                width: i == lineCount - 1 && lineCount > 1 ? width / 2 : width,
                margin: EdgeInsets.only(bottom: lineSpacing),
                height: lineHeight,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              )
          ],
        );
      }),
    );
  }
}
