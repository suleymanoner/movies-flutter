import 'package:flutter/material.dart';

class GenreItem extends StatelessWidget {
  const GenreItem({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: const Color.fromARGB(205, 255, 140, 140),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          name,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      ),
    );
  }
}
