import 'dart:math';

import 'package:flutter/material.dart';

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
        _currentValue = 'Parabéns!! Você jogou com todo o alfabeto';
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _buildLettersLeft(),
          Text(_currentValue ?? 'Nenhuma letra selecionada'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.play_arrow),
        onPressed: () => _play()
      ),
    );
  }

  Wrap _buildLettersLeft() {
    return Wrap(
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
    );
  }
}
