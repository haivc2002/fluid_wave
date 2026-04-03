import 'package:flutter/material.dart';

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
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
  bool isBlack = false;
  late FluidWaveController controller;

  @override
  void initState() {
    controller = FluidWaveController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FluidWaveView(
        controller: controller,
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: isBlack ? Colors.black : Colors.white,
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars, size: 50),
                Text("Hello World, fluid_wave is a powerful Flutter "
                    "package designed to create ultra-smooth \"fluid reveal\""
                    " transitions and radial warp distortions",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),),
              ],
            ),
          ),
        )
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          controller.forward(() {
            setState(() {
              isBlack = !isBlack;
            });
          });
        },
        child: Icon(Icons.change_circle_outlined)
      ),
    );
  }
}
