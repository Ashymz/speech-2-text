import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  stt.SpeechToText _speech = stt.SpeechToText();
  String _recognizedText = '';
  bool islistening = false;

  @override
  void initState() {
    super.initState();
    _initSpeechState();
  }

  void _initSpeechState() async {
    bool available = await _speech.initialize();
    if (!mounted) return;
    setState(() {
      islistening = available;
    });
  }

  void _startlistening() {
    _speech.listen(onResult: (result) {
      setState(() {
        _recognizedText = result.recognizedWords;
      });
    });
    setState(() {
      islistening = true;
    });
  }

  void _copyText() {
    if (!_recognizedText.isEmpty) {
      Clipboard.setData(ClipboardData(text: _recognizedText));
      _showSnackBar("Text Copied");
    }
  }

  void _clearText() {
    setState(() {
      _recognizedText = '';
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text("Speech Recongition",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w500,
          )),
      SizedBox(
        height: 40,
      ),
      IconButton(
        onPressed: _startlistening,
        icon: Icon(islistening ? Icons.mic : Icons.mic_none),
        iconSize: 100,
        color: islistening ? Colors.red : Colors.grey,
      ),
      SizedBox(
        height: 20,
      ),
      Container(
        height: MediaQuery.of(context).size.height / 4,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black45,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          _recognizedText.isNotEmpty ? _recognizedText : "Result here...",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
      SizedBox(
        height: 20,
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        InkWell(
            onTap: _recognizedText.isNotEmpty ? _copyText : null,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Copy",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    )))),
        SizedBox(
          width: 10,
        ),
        InkWell(
            onTap: _recognizedText.isNotEmpty ? _clearText : null,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text("Clear",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ))))
      ])
    ])));
  }
}
