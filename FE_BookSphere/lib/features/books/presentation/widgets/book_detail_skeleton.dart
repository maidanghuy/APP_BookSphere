import 'package:flutter/material.dart';

class BookDetailSkeleton extends StatelessWidget {
  const BookDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final base = colorScheme.surfaceContainerHighest.withValues(alpha: 0.7);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            width: 160,
            height: 220,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 20),
          _Bar(width: 220, height: 22, color: base),
          const SizedBox(height: 10),
          _Bar(width: 160, height: 16, color: base),
          const SizedBox(height: 8),
          _Bar(width: 120, height: 14, color: base),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 72,
            decoration: BoxDecoration(
              color: base,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 20),
          for (var i = 0; i < 4; i++) ...[
            _Bar(width: double.infinity, height: 16, color: base),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 12),
          _Bar(width: double.infinity, height: 80, color: base),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width, required this.height, required this.color});

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
