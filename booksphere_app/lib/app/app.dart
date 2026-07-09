import 'package:booksphere_app/app/theme.dart';
import 'package:booksphere_app/core/config/app_config.dart';
import 'package:flutter/material.dart';

class BookSphereApp extends StatelessWidget {
  const BookSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _BookSphereFoundationPage(),
    );
  }
}

class _BookSphereFoundationPage extends StatelessWidget {
  const _BookSphereFoundationPage();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BookSphere Mobile',
                  textAlign: TextAlign.center,
                  style: textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                const Text('Flutter'),
                const SizedBox(height: 16),
                const Text('Task:'),
                const Text('BS-APP-01'),
                const SizedBox(height: 16),
                const Text('Coder:'),
                const Text('maidanghuy'),
                const SizedBox(height: 16),
                const Text('Material 3 Ready'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
