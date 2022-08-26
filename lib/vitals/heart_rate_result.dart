import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  final int BpmResult;

  ResultPage({required this.BpmResult});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Material(
              color: Colors.orange,
              child: MaterialButton(
                onPressed: () {},
                child: const Text(
                  "Heart Rate",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.BpmResult.toString(),
              style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w400,
                  color: Colors.orange),
            ),
            const SizedBox(
              height: 30,
            ),
            Material(
              color: Colors.green,
              child: MaterialButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  "Okay",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
