import 'package:flutter/material.dart';
import 'stream.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stream Erwan Majid',
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const StreamHomePage(),
    );
  }
}

class StreamHomePage extends StatefulWidget {
  const StreamHomePage({super.key});

  @override
  State<StreamHomePage> createState() => _StreamHomePageState();
}

class _StreamHomePageState extends State<StreamHomePage> {
  late StreamSubscription subscription2;
  late StreamSubscription subscription;
  String values = "";
  late StreamTransformer transformer;
  int lastNumber = 0;
  late StreamController numberstreamController;
  late NumberStream numberStream;

  Color bgColor = Colors.blueGrey;
  late ColorStream colorStream;

  @override
  void initState() {
    super.initState();

    numberStream = NumberStream();
    numberstreamController = numberStream.controller;

    Stream stream = numberstreamController.stream.asBroadcastStream();

    // Listener pertama
    subscription = stream.listen((event) {
      setState(() {
        lastNumber = event; // Update UI dengan hasil stream
      });
    });

    // Listener kedua (menambahkan event ke values dua kali)
    subscription2 = stream.listen((event) {
      setState(() {
        values += '$event - '; // Menambahkan event ke values
      });
    });
  }

  void addRandomNumber() {
    Random random = Random();
    int myNum = random.nextInt(10);

    // Menambahkan angka dua kali
    numberStream.addNumberToSink(myNum); // Pertama kali
    numberStream.addNumberToSink(myNum); // Kedua kali
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stream Erwan Majid')),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Tampilkan hanya 1 angka baru setiap klik
            Text(lastNumber.toString()),

            // Menambahkan values untuk event-stream
            Text(values),

            // Tombol untuk menghasilkan angka acak
            ElevatedButton(
              onPressed: () => addRandomNumber(),
              child: const Text('New Random Number'),
            ),

            // Tombol untuk menghentikan stream
            ElevatedButton(
              onPressed: () => stopStream(),
              child: const Text('Stop Stream'),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk menghentikan stream
  void stopStream() {
    subscription.cancel();
    subscription2.cancel();
  }
}
