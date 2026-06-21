import 'package:flutter/material.dart';
import '../../../core/state.dart';
import '../../../l10n/app_localizations.dart';

import 'admin_home_page.dart';
import '../../discovery/screens/find_book_page.dart';
import 'admin_curation_page.dart';
import 'admin_transaction_page.dart';
import 'admin_profile_page.dart';

class AdminMainScaffold extends StatefulWidget {
  const AdminMainScaffold({super.key});

  @override
  State<AdminMainScaffold> createState() => _AdminMainScaffoldState();
}

class _AdminMainScaffoldState extends State<AdminMainScaffold> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RuangBukuState.instance.fetchBooks();
      RuangBukuState.instance.fetchBorrowings();
    });
  }

  final List<Widget> _pages = const [
    AdminHomePage(),
    FindBookPage(),
    AdminCurationPage(), // Replaced YourBooksPage
    AdminTransactionPage(), // Replaced BorrowingListPage
    AdminProfilePage(), // Replaced ProfilePage
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
                icon: const Icon(Icons.gavel_outlined),
                activeIcon: const Icon(Icons.gavel),
                label: l10n?.curation ?? 'Curation',
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
