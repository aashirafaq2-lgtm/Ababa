import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';
import 'package:ahmed_baba/features/splash/presentation/pages/splash_screen_viewport.dart';
import 'package:ahmed_baba/features/auth/presentation/pages/login_page.dart';
import 'package:ahmed_baba/features/home/presentation/pages/home_shell.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/portal_splash_screen.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/main_home_screen.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';

void main() {
  runApp(const AhmedBabaApp());
}

class AhmedBabaApp extends StatelessWidget {
  const AhmedBabaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = ChinaBoxLocalization();
    return AnimatedBuilder(
      animation: loc,
      builder: (context, _) {
        return MaterialApp(
          title: 'A.BABA',
          locale: loc.locale,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            primaryColor: AhmedBabaTokens.primary,
            scaffoldBackgroundColor: const Color(0xFFFAFAFA),
            colorScheme:
                ColorScheme.fromSeed(seedColor: const Color(0xFFE28500)),
            textTheme: GoogleFonts.interTextTheme(),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: AhmedBabaTokens.textPrimary,
              elevation: 0,
              centerTitle: false,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE28500),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
            ),
          ),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('ur', ''),
            Locale('ar', ''),
          ],
          initialRoute: '/portal_splash',
          routes: {
            // New Main A.BABA Portal routes
            '/portal_splash': (_) => const PortalSplashScreen(),
            '/main_home': (_) => const MainHomeScreen(),
            // Existing untouched Alibaba routes
            '/splash': (_) => const SplashViewport(),
            '/login': (_) => const LoginPage(),
            '/home': (_) => const HomeShell(),
          },
        );
      },
    );
  }
}

