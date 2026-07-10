import 'package:booksphere_app/core/localization/l10n_extension.dart';
import 'package:flutter/material.dart';

class MainBottomNavigation extends StatelessWidget {
  const MainBottomNavigation({
    required this.currentIndex,
    required this.onDestinationSelected,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return NavigationBar(
      selectedIndex: currentIndex,
      labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(icon: const Icon(Icons.home), label: l10n.home),
        NavigationDestination(
          icon: const Icon(Icons.menu_book),
          label: l10n.books,
        ),
        NavigationDestination(
          icon: const Icon(Icons.library_books),
          label: l10n.myBorrow,
        ),
        NavigationDestination(
          icon: const Icon(Icons.payments),
          label: l10n.fines,
        ),
        NavigationDestination(
          icon: const Icon(Icons.notifications),
          label: l10n.notifications,
        ),
        NavigationDestination(
          icon: const Icon(Icons.person),
          label: l10n.profile,
        ),
      ],
    );
  }
}
