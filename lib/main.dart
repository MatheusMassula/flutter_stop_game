import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stop_game/widgets/timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STOP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> _alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];
  List<String> _playedLetters = [];
  String _currentValue;

  void _reset() {
    setState(() {
      _currentValue = null;
      _playedLetters = [];
    });
  }
  
  void _play() {
    Random randomValue = Random();
    bool alreadyPlayed = true;
    String newValue;

    if(_alphabet.length > _playedLetters.length) {
      while (alreadyPlayed) {
      newValue = _alphabet[randomValue.nextInt(_alphabet.length)];
      alreadyPlayed = _playedLetters.contains(newValue);
      }

      setState(() {
        _currentValue = newValue;
        _playedLetters.add(newValue);
      });
    }
    else {
      setState(() {
        _currentValue = null;
        _playedLetters = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('STOP'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => _reset()
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: _buildLettersLeft(),
          ),

          Align(
            child: _buildLetter(),
            alignment: Alignment.center,
          )
        ],
      ),
      floatingActionButton: GestureDetector(
        child: Container(
          height: 61,
          width: 61,
          child: CircularTimer(
            seconds: 5,
            onTap: () => _play()
          )
        ),
      )
    );
  }

  Widget _buildLetter() {
    return Text(
      _currentValue ?? 'Nenhuma letra selecionada',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: _currentValue != null ? 400 : 40,
      ),
    );
  }

  Widget _buildLettersLeft() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        children: _alphabet.map((letter) {
          return Chip(
            label: Text(
              letter,
              style: TextStyle(color: Colors.white)
            ),
            backgroundColor: _playedLetters.contains(letter) ? Colors.grey : Colors.green,
          );
        }).toList(),
      ),
    );
  }
}
