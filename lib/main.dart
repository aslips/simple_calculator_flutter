import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false;

  ThemeData get lightTheme => ThemeData(
        scaffoldBackgroundColor: const Color(0xFFCCE4F6),
        primaryColor: const Color(0xFF92C9F9),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF92C9F9),
          foregroundColor: Colors.black,
        ),
        textTheme: GoogleFonts.quicksandTextTheme().apply(bodyColor: Colors.black87),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            backgroundColor: const Color(0xFFB3D7F5),
            side: const BorderSide(color: Color(0xFF92C9F9)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
        ),
      );

  ThemeData get darkTheme => ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1D2B40),
        primaryColor: const Color(0xFF324A6D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF324A6D),
          foregroundColor: Colors.white,
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF3A5A89),
            side: const BorderSide(color: Colors.white70),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 20.0),
          ),
        ),
        textTheme: GoogleFonts.quicksandTextTheme(
          ThemeData.dark().textTheme.apply(bodyColor: Colors.white),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aslı\'s Calculator',
      theme: isDarkMode ? darkTheme : lightTheme,
      home: CalculatorPage(
        isDarkMode: isDarkMode,
        onToggleTheme: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class CalculatorPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  CalculatorPage({required this.isDarkMode, required this.onToggleTheme});

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _output = "0";
  String _input = "";
  double _num1 = 0;
  double _num2 = 0;
  String _operand = "";

  void buttonPressed(String buttonText) {
    if (buttonText == "CLEAR") {
      _input = "";
      _output = "0";
      _num1 = 0;
      _num2 = 0;
      _operand = "";
    } else if (buttonText == "⌫") {
      if (_input.isNotEmpty) {
        _input = _input.substring(0, _input.length - 1);
      }
    } else if (buttonText == "+" || buttonText == "-" || buttonText == "/" || buttonText == "x") {
      if (_input.isNotEmpty) {
        if (RegExp(r'[+\-x/]$').hasMatch(_input)) {
          _input = _input.substring(0, _input.length - 1) + buttonText;
        } else {
          _num1 = double.tryParse(_input) ?? 0;
          _input += buttonText;
        }
        _operand = buttonText;
      }
    } else if (buttonText == ".") {
      if (!_input.endsWith(".") && !_input.contains(RegExp(r'[+\-x/]\.?$'))) {
        _input += buttonText;
      }
    } else if (buttonText == "=") {
      List<String> parts = _input.split(RegExp(r'[+\-x/]'));
      if (parts.length == 2) {
        _num2 = double.tryParse(parts[1]) ?? 0;
        switch (_operand) {
          case "+":
            _output = (_num1 + _num2).toString();
            break;
          case "-":
            _output = (_num1 - _num2).toString();
            break;
          case "x":
            _output = (_num1 * _num2).toString();
            break;
          case "/":
            _output = _num2 != 0 ? (_num1 / _num2).toString() : "ERROR";
            break;
        }
        _input = _output;
      }
      _operand = "";
    } else {
      _input += buttonText;
    }

    setState(() {
      _output = _input.isNotEmpty ? _input : _output;
    });
  }

  Widget buildButton(String text) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: OutlinedButton(
          onPressed: () => buttonPressed(text),
          child: Text(
            text,
            style: const TextStyle(fontSize: 22.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Aslı's Calculator",
          style: GoogleFonts.indieFlower(fontSize: 26),
        ),
        actions: [
          IconButton(
            onPressed: widget.onToggleTheme,
            icon: Icon(widget.isDarkMode ? Icons.wb_sunny : Icons.dark_mode),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
            child: Text(
              _output,
              style: const TextStyle(fontSize: 48.0),
            ),
          ),
          const Divider(),
          Column(children: [
            Row(children: [buildButton("7"), buildButton("8"), buildButton("9"), buildButton("/")]),
            Row(children: [buildButton("4"), buildButton("5"), buildButton("6"), buildButton("x")]),
            Row(children: [buildButton("1"), buildButton("2"), buildButton("3"), buildButton("-")]),
            Row(children: [buildButton("."), buildButton("0"), buildButton("⌫"), buildButton("+")]),
            Row(children: [buildButton("CLEAR"), buildButton("=")]),
          ]),
        ],
      ),
    );
  }
}
