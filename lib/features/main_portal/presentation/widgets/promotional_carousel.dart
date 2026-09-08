import 'dart:async';
import 'package:flutter/material.dart';

class PromotionalCarousel extends StatefulWidget {
  final VoidCallback? onExploreOffers;

  const PromotionalCarousel({super.key, this.onExploreOffers});

  @override
  State<PromotionalCarousel> createState() => _PromotionalCarouselState();
}

class _PromotionalCarouselState extends State<PromotionalCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _autoPlayTimer;
  bool _isUserInteracting = false;

  // 4 slides: first slide uses the ship banner, others re-use same for now
  final int _bannerCount = 4;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = Timer.periodic(const Duration(milliseconds: 4000), (timer) {
      if (!_isUserInteracting && mounted && _pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _bannerCount;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _pauseAutoPlay() {
    _isUserInteracting = true;
    _autoPlayTimer?.cancel();
  }

  void _resumeAutoPlayAfterDelay() {
    _isUserInteracting = false;
    _startAutoPlay();
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0),
          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification is ScrollStartNotification) {
                _pauseAutoPlay();
              } else if (notification is ScrollEndNotification) {
                _resumeAutoPlayAfterDelay();
              }
              return false;
            },
            child: Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF5F0E8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: _bannerCount,
                  itemBuilder: (context, index) {
                    return _buildBannerSlide();
                  },
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        _buildPaginationDots(),
      ],
    );
  }

  Widget _buildBannerSlide() {
    return GestureDetector(
      onTap: widget.onExploreOffers,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Ship photo background — right-aligned
          Positioned.fill(
            child: Image.asset(
              'assets/images/promo_ship_banner.jpg',
              fit: BoxFit.cover,
              alignment: const Alignment(0.8, 0.0),
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFFFF3DC), Color(0xFFFFE5B4)],
                  ),
                ),
              ),
            ),
          ),

          // Left-to-right white-to-transparent gradient
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withOpacity(0.97),
                    Colors.white.withOpacity(0.92),
                    Colors.white.withOpacity(0.55),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: const [0.0, 0.38, 0.60, 1.0],
                ),
              ),
            ),
          ),

          // Text overlay — left side
          Positioned(
            left: 16,
            top: 18,
            bottom: 16,
            right: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Exclusive Offers',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF111827),
                        letterSpacing: -0.5,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Ship faster ... Better prices',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF374151),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A.BABA',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFD97706),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),

                // CTA Button
                GestureDetector(
                  onTap: widget.onExploreOffers,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8C00),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFF8C00).withOpacity(0.38),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chevron_left_rounded,
                            color: Colors.white, size: 16),
                        SizedBox(width: 2),
                        Text(
                          'Explore Offers',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_bannerCount, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 22 : 7,
          height: 7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? const Color(0xFFFF8C00)
                : const Color(0xFFD1D5DB),
          ),
        );
      }),
    );
  }
}
