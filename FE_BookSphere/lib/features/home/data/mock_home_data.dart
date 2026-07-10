enum HomeCategory { programming, novel, science, history, technology }

class HomeBook {
  const HomeBook({
    required this.title,
    required this.author,
    required this.category,
  });

  final String title;
  final String author;
  final HomeCategory category;
}

abstract final class MockHomeData {
  static const featuredBooks = <HomeBook>[
    HomeBook(
      title: 'Clean Code',
      author: 'Robert C. Martin',
      category: HomeCategory.programming,
    ),
    HomeBook(
      title: 'The Pragmatic Programmer',
      author: 'David Thomas',
      category: HomeCategory.programming,
    ),
    HomeBook(
      title: 'A Brief History of Time',
      author: 'Stephen Hawking',
      category: HomeCategory.science,
    ),
  ];

  static const categories = HomeCategory.values;

  static const recommendedBooks = <HomeBook>[
    HomeBook(
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      category: HomeCategory.novel,
    ),
    HomeBook(
      title: 'Sapiens',
      author: 'Yuval Noah Harari',
      category: HomeCategory.history,
    ),
    HomeBook(
      title: 'The Innovators',
      author: 'Walter Isaacson',
      category: HomeCategory.technology,
    ),
  ];
}
