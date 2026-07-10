import 'package:booksphere_app/core/widgets/app_top_left_actions.dart';
import 'package:booksphere_app/features/auth/presentation/widgets/logout_button.dart';
import 'package:booksphere_app/features/home/screens/borrow_placeholder_screen.dart';
import 'package:booksphere_app/features/home/screens/category_placeholder_screen.dart';
import 'package:booksphere_app/features/home/screens/home_placeholder_screen.dart';
import 'package:booksphere_app/features/home/screens/notification_placeholder_screen.dart';
import 'package:booksphere_app/features/home/screens/profile_placeholder_screen.dart';
import 'package:booksphere_app/features/home/widgets/main_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainTabScreen extends ConsumerStatefulWidget {
  const MainTabScreen({super.key});

  @override
  ConsumerState<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends ConsumerState<MainTabScreen> {
  int currentIndex = 0;

  static const pages = <Widget>[
    HomePlaceholderScreen(),
    CategoryPlaceholderScreen(),
    BorrowPlaceholderScreen(),
    NotificationPlaceholderScreen(),
    ProfilePlaceholderScreen(),
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
              child: Padding(
                padding: EdgeInsets.all(8),
                child: LogoutButton(),
              ),
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
