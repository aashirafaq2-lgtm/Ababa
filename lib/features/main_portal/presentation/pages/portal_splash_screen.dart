import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/presentation/pages/main_home_screen.dart';
import 'package:ahmed_baba/features/main_portal/presentation/widgets/ababa_monogram.dart';

class PortalSplashScreen extends StatefulWidget {
  const PortalSplashScreen({super.key});

  @override
  State<PortalSplashScreen> createState() => _PortalSplashScreenState();
}

class _PortalSplashScreenState extends State<PortalSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _glowOpacity;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOutBack),
    );

    _logoOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
    );

    _glowOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.75, curve: Curves.easeInOut),
    );

    _textSlide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 0.85, curve: Curves.fastOutSlowIn),
      ),
    );

    _controller.forward();

    // Smooth native crossfade transition into MainHomeScreen after brand animation completes
    _navigationTimer = Timer(const Duration(milliseconds: 2700), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const MainHomeScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 450),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background soft ambient glow
          Center(
            child: FadeTransition(
              opacity: _glowOpacity,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFFFBBF24).withOpacity(0.18),
                      const Color(0xFFEA580C).withOpacity(0.04),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Central Monogram & Typography
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoOpacity,
                    child: Container(
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFE28500).withOpacity(0.15),
                            blurRadius: 28,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const ABabaMonogram(size: 72),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _textSlide,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Opacity(
                        opacity: (1 - (_textSlide.value / 30)).clamp(0.0, 1.0),
                        child: Column(
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xFFE28500),
                                  Color(0xFFF59E0B),
                                  Color(0xFFD97706),
                                ],
                              ).createShader(bounds),
                              child: const Text(
                                'A.BABA',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.8,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              'GLOBAL COMMERCE & LOGISTICS',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 2.2,
                                color: Color(0xFF9CA3AF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Minimalist bottom loader
          Positioned(
            bottom: 48,
            left: 120,
            right: 120,
            child: FadeTransition(
              opacity: _glowOpacity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: const LinearProgressIndicator(
                  minHeight: 2.5,
                  backgroundColor: Color(0xFFF3F4F6),
                  color: Color(0xFFE28500),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
