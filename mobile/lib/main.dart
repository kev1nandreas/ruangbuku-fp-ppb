import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/state.dart';

import 'features/discovery/screens/home_page.dart';
import 'features/discovery/screens/find_book_page.dart';
import 'features/inventory/screens/your_books_page.dart';
import 'features/notifications/screens/notification_page.dart';
import 'features/profile/screens/profile_page.dart';

void main() {
  runApp(const RuangBukuApp());
}

class RuangBukuApp extends StatelessWidget {
  const RuangBukuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RuangBuku',
      debugShowCheckedModeBanner: false,
      theme: RuangBukuTheme.lightTheme.copyWith(
        extensions: [RuangBukuSemanticColors.standard],
      ),
      home: const MainScaffold(),
    );
  }
}

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    FindBookPage(),
    YourBooksPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: RuangBukuState.instance,
      builder: (context, _) {
        final state = RuangBukuState.instance;
        final isAdmin = state.currentRole == UserRole.admin;

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
              const BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.search),
                activeIcon: Icon(Icons.search),
                label: 'Find Book',
              ),
              BottomNavigationBarItem(
                icon: Icon(isAdmin ? Icons.gavel_outlined : Icons.library_books_outlined),
                activeIcon: Icon(isAdmin ? Icons.gavel : Icons.library_books),
                label: isAdmin ? 'Curation' : 'Your Books',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
                label: 'Notification',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Profile',
              ),
            ],
          ),
        );
      },
    );
  }
}

