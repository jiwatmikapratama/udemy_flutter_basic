import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String qoute = "";
  String author = "";
  // Timer? timer;
  // static const maxDuration = 10;
  // int _duration = maxDuration;
  // // int _duration = maxDuration;

  // void load_qoute() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     qoute = (prefs.getString('qoute')) ?? "";
  //     author = (prefs.getString('author')) ?? "";
  //     _duration = (prefs.getInt('duration')) ?? maxDuration;
  //   });
  // }

  // void cooldown() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('qoute', qoute);
  //   prefs.setString('author', author);
  //   timer = Timer.periodic(Duration(seconds: 1), (_) {
  //     if (_duration > 0) {
  //       setState(() {
  //         _duration--;
  //       });
  //       prefs.setInt("duration", _duration);
  //     } else {
  //       stop_cooldown();
  //     }
  //   });
  // }

  // void stop_cooldown() {
  //   timer?.cancel();
  // }

  // void reset_cooldown() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.remove(qoute);
  //   prefs.remove(author);
  //   setState(() {
  //     _duration = maxDuration;
  //   });
  // }

  void load_qoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      qoute = (prefs.getString('qoute')) ?? "";
      author = (prefs.getString('author')) ?? "";
    });
    // }
  }

  void set_qoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('qoute', qoute);
    prefs.setString('author', author);
  }

  void reset_qoute() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    qoute = "";
    author = "";
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // cooldown();
    load_qoute();
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
            // ElevatedButton(
            //   onPressed: () async {
            //     load_qoute();
            //     // print(_duration);
            //     print(qoute);
            //     print(author);
            //   },
            //   child: Text('test'),
            // ),
            Padding(padding: EdgeInsets.only(top: 5)),
            // Text(_duration.toString()),
            // if (qoute == "" || _duration == 0)
            if (qoute == "")
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: () async {
                  var url = Uri.parse('https://api.quotable.io/random?tags');
                  var response = await http.get(url);
                  // print('Response Status:${response.statusCode}');
                  // print('Response Body:${response.body}');
                  var data = jsonDecode(response.body);
                  print(data['content']);
                  print(data['author']);
                  qoute = data['content'];
                  author = data['author'];

                  set_qoute();
                  // cooldown();
                  // reset_cooldown();
                  // print(_duration);
                  setState(() {});
                },
                child: Text("Generate Qoute"),
              ),
            Padding(padding: EdgeInsets.only(top: 5)),

            if (qoute != "")
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                onPressed: () {
                  reset_qoute();
                  print(qoute);
                  print(author);
                  setState(() {});
                },
                child: Text("Reset Qoute"),
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
