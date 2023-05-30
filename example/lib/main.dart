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
  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   print(_cardKey?.currentContext?.size);
    // });

    return Scaffold(
      appBar: AppBar(),
      body: SkeletonBuilder(
        // widgetName: 'DemoSkeleton',
        child: false
            ? Padding(
                padding: const EdgeInsets.only(top: 100),
                child: CustomScrollView(slivers: [
                  // SliverAppBar(
                  //   expandedHeight: 120,
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  //   leading: const BackButton(),
                  //   flexibleSpace: FlexibleSpaceBar(
                  //     background: Image.network(
                  //       'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80',
                  //       fit: BoxFit.cover,
                  //     ),
                  //     title: Text("Sub title"),
                  //   ),
                  // ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => ListTile(
                        title: Text("Hello"),
                        subtitle: Text("Hello I'm subitiel"),
                        trailing: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FlutterLogo(
                              size: 56,
                            )),
                      ),
                      childCount: 3,
                    ),
                  ),

                  // SliverToBoxAdapter(
                  //   child: SizedBox(
                  //     height: 100,
                  //     width: 100,
                  //     // child: ColoredBox(color: Colors.redAccent,),
                  //     // child: ListView(
                  //     //   children: [Text("Hello World")],
                  //     // ),
                  //   ),
                  // ),
                  // const SliverPadding(
                  //   padding: EdgeInsets.all(23),
                  //   sliver: SliverAppBar(
                  //     title: Text("Hello"),
                  //   ),
                  // ),
                  // const SliverPadding(
                  //   padding: EdgeInsets.all(23),
                  //   sliver: SliverAppBar(
                  //     title: Text("Hello"),
                  //   ),
                  // ),
                  // ),
                ]),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Column(
                  children: [
                    // const Padding(
                    //   padding: EdgeInsets.all(20.0),
                    //   child: Text(
                    //     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                    //     style: TextStyle(fontSize: 20),
                    //   ),
                    // ),
                    // Card(
                    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    //   child: const Text("Hello"),
                    // ),
                    // if (false)
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: ElevatedButton(onPressed: () {}, child: const Text('Hello')),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(8.0),
                    //   child: DecoratedBox(
                    //     decoration: BoxDecoration(
                    //       border: Border.all(),
                    //     ),
                    //     child: Row(
                    //       children: const [
                    //         Text('Hello'),
                    //         SizedBox(
                    //           width: 20,
                    //           height: 100,
                    //         ),
                    //         Text("World"),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // IconButton.outlined(
                    //   onPressed: () {},
                    //   icon: Icon(Icons.ac_unit),
                    // ),
                    // Expanded(
                    //     child: Scaffold(
                    //       floatingActionButton: FloatingActionButton(onPressed: () {  },),
                    //   appBar: AppBar(
                    //     leading: BackButton(),
                    //     title: const Text("Hello"),
                    //     actions: [
                    //       BackButton(),
                    //     ],
                    //   ),
                    //   body: Center(
                    //     child: Text("Body"),
                    //   ),
                    // )),

                    // const Padding(
                    //   padding: EdgeInsets.all(8.0),
                    //   child: Text('Hello'),
                    // ),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: Text('Click me'),
                    // ),
                    // const Divider(
                    //   thickness: 20,
                    //   height: 32,
                    //   color: Colors.redAccent,
                    // ),
                    // Spacer(),
                    // ElevatedButton(
                    //   onPressed: () {},
                    //   child: Text('Click me'),
                    // ),
                    // Text('Click me ' * 10),
                    // if(false)

                    // Table(
                    //   border: TableBorder.all(),
                    //   children: [
                    //   TableRow(children: [Text('Tab1'), Text('Tab2')]),
                    //   TableRow(children: [Text('Tab1'), Text('Tab2')])
                    // ],),
                    // // if (false)
                    // SizedBox(
                    //   height: 44,
                    //   child: PageView(
                    //     scrollDirection: Axis.horizontal,
                    //     padEnds: false,
                    //     controller: PageController(viewportFraction: .8),
                    //     children: [
                    //       for (final i in [0, 2, 3])
                    //         Container(
                    //           color: Colors.blue,
                    //           margin: const EdgeInsets.symmetric(horizontal: 8),
                    //         ),
                    //     ],
                    //   ),
                    // ),

                    const Expanded(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 30,
                              child: Text("hello"),
                            ),
                            PositionedDirectional(
                              start: 40,
                              child: Text("World"),
                            )
                          ],
                        ),
                      ),
                    ),

                    if (false)
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.all(20),
                          itemCount: 2,
                          separatorBuilder: (ctx, index) => const Divider(
                            height: 32,
                            color: Colors.redAccent,
                          ),
                          itemBuilder: (ctx, index) {
                            // return Container(
                            //   color: Colors.grey.shade300,
                            //   margin: const EdgeInsets.symmetric(vertical: 4),
                            //   child:  ListTile(
                            //     title: Text('Im a title'),
                            //     subtitle: Text('Im a subtitle'),
                            //     trailing: Container(
                            //       width: 50,
                            //       height: 50,
                            //       color: Colors.green,
                            //     ),
                            //   ),
                            // );
                            return Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: Column(
                                children: [
                                  AspectRatio(
                                    aspectRatio: 2 / 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1575936123452-b67c3203c357?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1770&q=80',
                                        fit: BoxFit.cover,
                                      ),
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
                                        const Expanded(
                                            child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
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
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
