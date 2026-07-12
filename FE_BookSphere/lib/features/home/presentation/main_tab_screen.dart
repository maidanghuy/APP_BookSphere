import 'package:booksphere_app/core/widgets/app_top_left_actions.dart';
import 'package:booksphere_app/features/auth/presentation/widgets/logout_button.dart';
import 'package:booksphere_app/features/books/presentation/book_list_screen.dart';
import 'package:booksphere_app/features/borrows/presentation/my_borrow_list_screen.dart';
import 'package:booksphere_app/features/fines/presentation/my_fine_list_screen.dart';
import 'package:booksphere_app/features/home/presentation/home_screen.dart';
import 'package:booksphere_app/features/home/widgets/main_bottom_navigation.dart';
import 'package:booksphere_app/features/notification/presentation/notification_list_screen.dart';
import 'package:booksphere_app/features/profile/presentation/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainTabScreen extends ConsumerStatefulWidget {
  const MainTabScreen({super.key});

  @override
  ConsumerState<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends ConsumerState<MainTabScreen> {
  int currentIndex = 0;

  List<Widget> get pages => [
    HomeScreen(
      onViewBooks: () => _selectTab(1),
      onViewBorrows: () => _selectTab(2),
      onViewFines: () => _selectTab(3),
    ),
    const BookListScreen(),
    const MyBorrowListScreen(),
    const MyFineListScreen(),
    NotificationListScreen(
      onOpenBorrow: () => _selectTab(2),
      onOpenFine: () => _selectTab(3),
    ),
    const ProfileScreen(),
  ];

  void _selectTab(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 64),
              child: IndexedStack(index: currentIndex, children: pages),
            ),
          ),
          const AppTopLeftActions(),
          const SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(padding: EdgeInsets.all(8), child: LogoutButton()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MainBottomNavigation(
        currentIndex: currentIndex,
        onDestinationSelected: _selectTab,
      ),
    );
  }
}
