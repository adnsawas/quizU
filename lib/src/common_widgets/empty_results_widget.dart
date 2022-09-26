import 'package:flutter/material.dart';

class EmptyResultsWidget extends StatelessWidget {
  const EmptyResultsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding:
            const EdgeInsets.only(top: 12.0, right: 16, bottom: 20, left: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              '📭',
              style: TextStyle(fontSize: 70),
            ),
            SizedBox(height: 4),
            Text(
              'No Results',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
