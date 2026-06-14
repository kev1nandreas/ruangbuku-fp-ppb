import 'package:flutter/material.dart';
import '../../../core/state.dart';
import '../../../l10n/app_localizations.dart';

import 'user_home_page.dart';
import '../../discovery/screens/find_book_page.dart';
import 'user_books_page.dart';
import 'user_borrowing_page.dart';
import 'user_profile_page.dart';

class UserMainScaffold extends StatefulWidget {
  const UserMainScaffold({super.key});

  @override
  State<UserMainScaffold> createState() => _UserMainScaffoldState();
}

class _UserMainScaffoldState extends State<UserMainScaffold> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RuangBukuState.instance.fetchBooks();
      RuangBukuState.instance.fetchBorrowings();
    });
  }

  List<Widget> get _pages => [
    const UserHomePage(),
    const FindBookPage(),
    const UserBooksPage(), // Replaced YourBooksPage
    const UserBorrowingPage(), // Replaced BorrowingListPage
    UserProfilePage(
      onNavigateToTab: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
    ), // Replaced ProfilePage
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final l10n = AppLocalizations.of(context);

        return Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.home_outlined),
                activeIcon: const Icon(Icons.home),
                label: l10n?.home ?? 'Home',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                activeIcon: const Icon(Icons.search),
                label: l10n?.findBook ?? 'Find Book',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.library_books_outlined),
                activeIcon: const Icon(Icons.library_books),
                label: l10n?.yourBooks ?? 'Your Books',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.handshake_outlined),
                activeIcon: const Icon(Icons.handshake),
                label: l10n?.borrowing ?? 'Borrowing',
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.person_outline),
                activeIcon: const Icon(Icons.person),
                label: l10n?.profile ?? 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}
