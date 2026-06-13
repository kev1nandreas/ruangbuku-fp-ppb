import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/state.dart';
import 'core/notifications/push_notification_service.dart';

import 'features/auth/domain/auth_notifier.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/discovery/screens/home_page.dart';
import 'features/discovery/screens/find_book_page.dart';
import 'features/inventory/screens/your_books_page.dart';
import 'features/borrowing/screens/borrowing_list_page.dart';
import 'features/profile/screens/profile_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set up Firebase Messaging (listeners, channel, background handler) before
  // the app renders. Best-effort: a Firebase failure must not block startup.
  bool firebaseReady = false;
  try {
    await PushNotificationService.instance.initialize();
    firebaseReady = true;
  } catch (e) {
    debugPrint('main: push init failed: $e');
  }

  await AuthNotifier.instance.checkAuthStatus();

  // Already-signed-in users (token restored from storage) re-register their
  // device so a token rotated while the app was closed reaches the backend.
  if (AuthNotifier.instance.isAuthenticated) {
    PushNotificationService.instance.registerDevice();
  }

  if (firebaseReady) {
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };
    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

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
      home: ListenableBuilder(
        listenable: AuthNotifier.instance,
        builder: (context, _) {
          final status = AuthNotifier.instance.status;

          // Only the one-time startup auth check shows the splash. A `loading`
          // status during a login attempt must keep the LoginScreen mounted so
          // it can show its in-button spinner and surface error messages.
          if (status == AuthStatus.initial) {
            return const _SplashScreen();
          }

          if (status == AuthStatus.authenticated) {
            return const MainScaffold();
          }

          return const LoginScreen();
        },
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: RuangBukuColors.surface,
      body: Center(
        child: CircularProgressIndicator(color: RuangBukuColors.primary),
      ),
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RuangBukuState.instance.fetchBooks();
      RuangBukuState.instance.fetchBorrowings();
    });
  }

  final List<Widget> _pages = const [
    HomePage(),
    FindBookPage(),
    YourBooksPage(),
    BorrowingListPage(),
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
                icon: Icon(
                  isAdmin ? Icons.gavel_outlined : Icons.library_books_outlined,
                ),
                activeIcon: Icon(isAdmin ? Icons.gavel : Icons.library_books),
                label: isAdmin ? 'Curation' : 'Your Books',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.handshake_outlined),
                activeIcon: Icon(Icons.handshake),
                label: 'Borrowing',
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
