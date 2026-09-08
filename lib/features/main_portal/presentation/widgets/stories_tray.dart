import 'package:flutter/material.dart';

class StoriesTray extends StatelessWidget {
  final void Function(int id)? onStoryTap;

  const StoriesTray({super.key, this.onStoryTap});

  static final List<Map<String, dynamic>> _storiesData = [
    {
      'id': 1,
      'titleEn': 'Latest News',
      'icon': Icons.newspaper_rounded,
      'color': const Color(0xFF64748B),
    },
    {
      'id': 2,
      'titleEn': 'Offers',
      'icon': Icons.local_offer_rounded,
      'color': const Color(0xFFF97316),
    },
    {
      'id': 3,
      'titleEn': 'Shipping',
      'icon': Icons.directions_boat_rounded,
      'color': const Color(0xFF0284C7),
    },
    {
      'id': 4,
      'titleEn': 'China',
      'icon': Icons.temple_buddhist_rounded,
      'color': const Color(0xFFDC2626),
    },
    {
      'id': 5,
      'titleEn': 'Shipments',
      'icon': Icons.local_shipping_rounded,
      'color': const Color(0xFFEA580C),
    },
    {
      'id': 6,
      'titleEn': 'Points',
      'icon': Icons.star_rounded,
      'color': const Color(0xFFF59E0B),
    },
    {
      'id': 7,
      'titleEn': 'More',
      'icon': Icons.more_horiz_rounded,
      'color': const Color(0xFFEA580C),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 94,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _storiesData.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final story = _storiesData[index];
          return _StoryCircleItem(
            story: story,
            onTap: onStoryTap != null ? () => onStoryTap!(story['id'] as int) : null,
          );
        },
      ),
    );
  }
}


class _StoryCircleItem extends StatefulWidget {
  final Map<String, dynamic> story;
  final VoidCallback? onTap;

  const _StoryCircleItem({required this.story, this.onTap});

  @override
  State<_StoryCircleItem> createState() => _StoryCircleItemState();
}

class _StoryCircleItemState extends State<_StoryCircleItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeInOut,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Multi-tone luxury gold-orange gradient ring with inner white gap
              Container(
                width: 64,
                height: 64,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF8C00),
                      Color(0xFFFF5500),
                      Color(0xFFFFA000),
                    ],
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22FF6B00),
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/icons/stories/story_${widget.story['id']}.png',
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.high,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFFFF7ED),
                        child: Center(
                          child: Icon(
                            widget.story['icon'] as IconData,
                            color: widget.story['color'] as Color,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Story label — sharp, elegant typography
              Text(
                widget.story['titleEn'] as String,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
