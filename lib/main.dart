import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const TranslationGameApp());
}

// Data structure for the word pairs
const List<Map<String, String>> wordPairs = [
  {'spanish': 'Hola', 'english': 'Hello'},
  {'spanish': 'Adiós', 'english': 'Goodbye'},
  {'spanish': 'Gato', 'english': 'Cat'},
  {'spanish': 'Perro', 'english': 'Dog'},
  {'spanish': 'Casa', 'english': 'House'},
  {'spanish': 'Rojo', 'english': 'Red'},
  {'spanish': 'Azul', 'english': 'Blue'},
  {'spanish': 'Agua', 'english': 'Water'},
];

class TranslationGameApp extends StatelessWidget {
  const TranslationGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translation Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF1D2331),
        fontFamily: 'Poppins',
      ),
      home: const GamePage(),
    );
  }
}

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _score = 0;
  late Map<String, String> _currentWord;
  late List<String> _options;
  String _feedback = '';
  Color _feedbackColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    _nextWord();
  }

  void _nextWord() {
    setState(() {
      _feedback = '';
      _feedbackColor = Colors.transparent;
      // Select a random word
      _currentWord = wordPairs[Random().nextInt(wordPairs.length)];

      // Create options
      _options = [];
      _options.add(_currentWord['english']!); // Add the correct answer

      // Add 2 random wrong answers
      while (_options.length < 3) {
        var randomWord = wordPairs[Random().nextInt(wordPairs.length)]['english']!;
        if (!_options.contains(randomWord)) {
          _options.add(randomWord);
        }
      }

      // Shuffle the options
      _options.shuffle();
    });
  }

  void _checkAnswer(String selectedAnswer) {
    setState(() {
      if (selectedAnswer == _currentWord['english']) {
        _score += 10;
        _feedback = '¡Correcto!';
        _feedbackColor = Colors.green.shade400;
      } else {
        _feedback = 'Incorrecto. La respuesta era "${_currentWord['english']!}"';
        _feedbackColor = Colors.red.shade400;
        if (_score > 0) _score -= 5;
      }
    });
    
    // Wait for a moment before loading the next word
    Future.delayed(const Duration(seconds: 2), () {
      _nextWord();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Score Display
              Text(
                'Puntuación: $_score',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              // Word to Translate
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A344D),
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Column(
                  children: [
                     const Text(
                      'Traduce la palabra:',
                      style: TextStyle(fontSize: 22, color: Colors.white70),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _currentWord['spanish']!,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              // Feedback Message
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _feedbackColor,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                  _feedback,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),

              // Options
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _options.map((option) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A5568),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)
                        )
                      ),
                      onPressed: () => _feedback.isEmpty ? _checkAnswer(option) : null,
                      child: Text(
                        option,
                        style: const TextStyle(fontSize: 22),
                      ),
                    ),
                  );
                }).toList(),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
