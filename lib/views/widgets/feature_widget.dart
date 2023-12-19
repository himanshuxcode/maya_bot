import 'package:flutter/material.dart';

class FeatureWidget extends StatelessWidget {
  final String title;
  final String description;
  final Color colour;

  const FeatureWidget({
    super.key,
    required this.title,
    required this.description,
    required this.colour,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: colour,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ).copyWith(top: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 15.0,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Title
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: "Cera Pro",
              color: Color.fromARGB(255, 10,82,94),

            ),
          ),
          //Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: "Cera Pro",
            ),
          ),
          //
        ],
      ),
    );
  }
}
