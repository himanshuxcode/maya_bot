import 'package:flutter/material.dart';
import 'package:maya_bot/views/screens/home_screen.dart';

class ResultScreen extends StatelessWidget {
  final String question;
  final String answer;

  const ResultScreen({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 153, 187, 197),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 153, 187, 197),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ));
          },
          icon: const Icon(Icons.keyboard_arrow_left),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ///Question
              Text(
                question,
                style: const TextStyle(
                  fontSize: 24,
                  color: Color.fromARGB(255, 2, 50, 62),
                  fontFamily: "Cera Pro",
                  fontWeight: FontWeight.w500,
                ),
              ),

              ///Answer
              if (answer.contains("https"))
                Image.network(
                  answer,
                  fit: BoxFit.cover,
                  height: size.width,
                  width: size.width,
                ),

              if (!answer.contains("https"))
                Text(
                  answer,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: "Cera Pro",
                  ),
                ),

              ///
            ],
          ),
        ),
      ),
    );
  }
}
