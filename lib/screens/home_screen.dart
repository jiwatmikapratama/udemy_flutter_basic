import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String qoute = "";
  String author = "";
  Timer? timer;
  static const maxDuration = 60 * 60 * 24;
  int _duration = maxDuration;
  // int _duration = maxDuration;

  void cooldown() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (_duration > 0) {
        setState(() {
          _duration--;
        });
      } else {
        stop_cooldown();
      }
    });
  }

  void stop_cooldown() {
    timer?.cancel();
  }

  void reset_cooldown() {
    // stop_cooldown();
    setState(() {
      _duration = maxDuration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Qoute Today"),
          ),
        ),
        body: Column(
          children: [
            Padding(padding: EdgeInsets.only(top: 5)),
            // Text(_duration.toString()),
            if (qoute == "" || _duration == 0)
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  var url = Uri.parse(
                      'https://api.quotable.io/random?tags=technology%2Cfamous-quotes');
                  var response = await http.get(url);
                  // print('Response Status:${response.statusCode}');
                  // print('Response Body:${response.body}');
                  var data = jsonDecode(response.body);
                  print(data['content']);
                  print(data['author']);
                  qoute = data['content'];
                  author = data['author'];
                  cooldown();
                  reset_cooldown();

                  print(_duration);
                  setState(() {});
                },
                child: Text("Generate Today Qoute"),
              ),
            CardQoute(
              qoute: qoute,
              author: author,
            ),
          ],
        ),
      ),
    );
  }
}

class CardQoute extends StatelessWidget {
  String qoute;
  String author;
  CardQoute({super.key, required this.qoute, required this.author});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Card(
            clipBehavior: Clip.hardEdge,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  Text(
                    qoute,
                    style: TextStyle(
                      fontSize: 25,
                    ),
                  ),
                  Text(
                    "- $author",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
