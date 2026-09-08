import 'package:flutter/material.dart';
import 'package:ahmed_baba/core/theme/design_tokens.dart';
import 'dart:async';

class SplashViewport extends StatefulWidget {
  const SplashViewport({super.key});

  @override
  State<SplashViewport> createState() => _SplashViewportState();
}

class _SplashViewportState extends State<SplashViewport> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textSlide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _logoScale = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
    );

    _logoFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
    );

    _textSlide = Tween<double>(begin: 40, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    _controller.forward();

    Timer(const Duration(milliseconds: 3500), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    // Use the real official A.BABA brand logo asset
                    child: Image.asset(
                      'assets/branding/logo.png',
                      width: 180,
                      height: 180,
                      fit: BoxFit.contain,
                      filterQuality: FilterQuality.high,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                AnimatedBuilder(
                  animation: _textSlide,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _textSlide.value),
                      child: Opacity(
                        opacity: (1 - (_textSlide.value / 40)).clamp(0.0, 1.0),
                        child: Column(
                          children: [
                            Text(
                              'Ababa',
                              style: AhmedBabaTokens.displayLarge.copyWith(
                                color: AhmedBabaTokens.primary,
                                fontSize: 36,
                                letterSpacing: -1.5,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'GLOBAL SOURCE • B2B TRADE',
                              style: AhmedBabaTokens.labelSmall.copyWith(
                                color: Colors.black38,
                                letterSpacing: 2.5,
                                fontWeight: FontWeight.w900,
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
          // Progressive Loading Bar
          Positioned(
            bottom: 80,
            left: 100, right: 100,
            child: FadeTransition(
              opacity: _logoFade,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  backgroundColor: AhmedBabaTokens.primary.withOpacity(0.1),
                  color: AhmedBabaTokens.primary,
                  minHeight: 2,
                ),
              ),
            ),
          ),
          // Corporate trademark footer
          Positioned(
            bottom: 40,
            left: 0, right: 0,
            child: Center(
              child: Text(
                'ALB POWERED ECOSYSTEM',
                style: AhmedBabaTokens.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey[400],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
