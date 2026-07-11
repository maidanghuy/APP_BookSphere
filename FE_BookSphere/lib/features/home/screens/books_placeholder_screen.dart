import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BooksPlaceholderScreen extends StatelessWidget {
  const BooksPlaceholderScreen({super.key});

  // Mock list of books corresponding to IDs in backend database init script (data.sql)
  static const List<Map<String, dynamic>> _mockBooks = [
    {
      'id': 1,
      'title': 'Clean Code',
      'author': 'Robert C. Martin',
      'isbn': '9780132350884',
    },
    {
      'id': 2,
      'title': 'Effective Java',
      'author': 'Joshua Bloch',
      'isbn': '9780134685991',
    },
    {
      'id': 3,
      'title': 'Spring Microservices in Action',
      'author': 'John Carnell',
      'isbn': '9781617293986',
    },
    {
      'id': 4,
      'title': 'Designing Data-Intensive Applications',
      'author': 'Martin Kleppmann',
      'isbn': '9781449373320',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _mockBooks.length,
        itemBuilder: (context, index) {
          final book = _mockBooks[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: colorScheme.primaryContainer,
                child: Icon(Icons.book, color: colorScheme.onPrimaryContainer),
              ),
              title: Text(
                book['title'] as String,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                book['author'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              trailing: ElevatedButton(
                onPressed: () {
                  context.push('/borrows/create?bookId=${book['id']}');
                },
                child: const Text('Borrow'),
              ),
            ),
          );
        },
      ),
    );
  }
}
