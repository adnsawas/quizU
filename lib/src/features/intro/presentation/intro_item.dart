import 'package:flutter/material.dart';

class IntroItem extends StatelessWidget {
  const IntroItem(
      {super.key,
      required this.imagePath,
      required this.title,
      required this.description});

  final String imagePath;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Image.asset(imagePath, height: 250),
            const SizedBox(height: 48),
            Text(title,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .headline5!
                    .copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Text(description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline6),
          ],
        ),
      ),
    );
  }
}
