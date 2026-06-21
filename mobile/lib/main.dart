import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'core/state.dart';
import 'core/preferences_notifier.dart';
import 'core/notifications/push_notification_service.dart';

import 'features/auth/domain/auth_notifier.dart';
import 'features/auth/presentation/screens/login_screen.dart';
import 'features/user/screens/user_main_scaffold.dart';
import 'features/admin/screens/admin_main_scaffold.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

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

  await PreferencesNotifier.instance.loadPreferences();
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
    return ListenableBuilder(
      listenable: Listenable.merge([
        PreferencesNotifier.instance,
        RuangBukuState.instance,
      ]),
      builder: (context, _) {
        return MaterialApp(
          title: 'RuangBuku',
          debugShowCheckedModeBanner: false,
          themeMode: PreferencesNotifier.instance.themeMode,
          theme: RuangBukuTheme.lightTheme.copyWith(
            extensions: [RuangBukuSemanticColors.standard],
          ),
          darkTheme: RuangBukuTheme.darkTheme.copyWith(
            extensions: [RuangBukuSemanticColors.standard],
          ),
          locale: RuangBukuState.instance.currentLocale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('id'),
            Locale('en'),
          ],
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
                if (RuangBukuState.instance.currentRole == UserRole.admin) {
                  return const AdminMainScaffold();
                } else {
                  return const UserMainScaffold();
                }
              }

              return const LoginScreen();
            },
          ),
        );
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RuangBukuColors.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ruangbuku_logo.png',
              width: 200,
            ),
            const SizedBox(height: 40),
            const CircularProgressIndicator(color: RuangBukuColors.primary),
          ],
        ),
      ),
    );
  }
}

