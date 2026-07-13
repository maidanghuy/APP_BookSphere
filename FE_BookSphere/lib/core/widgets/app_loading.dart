import 'package:flutter/material.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.message, this.size = 28});

  final String? message;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(
              dimension: size,
              child: const CircularProgressIndicator(),
            ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
