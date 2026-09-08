import 'package:flutter/material.dart';
import 'package:ahmed_baba/features/main_portal/my_china_box/domain/models/china_box_localization.dart';
import 'package:ahmed_baba/features/splash/presentation/pages/splash_screen_viewport.dart';
import 'product_sourcing_page.dart';

class CategoriesCatalogPage extends StatefulWidget {
  const CategoriesCatalogPage({super.key});

  @override
  State<CategoriesCatalogPage> createState() => _CategoriesCatalogPageState();
}

class _CategoriesCatalogPageState extends State<CategoriesCatalogPage> {
  final _loc = ChinaBoxLocalization();
  static const Color _orange = Color(0xFFFF6B00);

  int _selectedCategoryIndex = 0;

  final List<Map<String, dynamic>> _categories = [
    {
      'nameEn': 'Consumer Electronics',
      'nameAr': 'إلكترونيات واستهلاكية',
      'icon': Icons.devices_rounded,
      'subcategories': [
        {'nameEn': 'Smart Watches', 'nameAr': 'ساعات ذكية', 'icon': Icons.watch_rounded},
        {'nameEn': 'Wireless Earbuds', 'nameAr': 'سماعات بلوتوث', 'icon': Icons.headphones_rounded},
        {'nameEn': 'Phone Accessories', 'nameAr': 'ملحقات الجوال', 'icon': Icons.phone_android_rounded},
        {'nameEn': 'Power Banks & Cables', 'nameAr': 'شواحن وبطاريات', 'icon': Icons.battery_charging_full_rounded},
        {'nameEn': 'Smart Home Tech', 'nameAr': 'أجهزة منزل ذكية', 'icon': Icons.home_mini_rounded},
        {'nameEn': 'Gaming Keyboards', 'nameAr': 'لوحات مفاتيح ألعاب', 'icon': Icons.keyboard_rounded},
      ],
    },
    {
      'nameEn': 'Fashion & Bags',
      'nameAr': 'أزياء وحقائب وأحذية',
      'icon': Icons.shopping_bag_rounded,
      'subcategories': [
        {'nameEn': 'Leather Handbags', 'nameAr': 'حقائب يد جلدية', 'icon': Icons.work_outline_rounded},
        {'nameEn': 'Sneakers & Shoes', 'nameAr': 'أحذية رياضية', 'icon': Icons.roller_skating_rounded},
        {'nameEn': 'Women Dresses', 'nameAr': 'فساتين نسائية', 'icon': Icons.checkroom_rounded},
        {'nameEn': 'Men T-Shirts', 'nameAr': 'تيشيرتات وملابس رجالية', 'icon': Icons.dry_cleaning_rounded},
        {'nameEn': 'Travel Luggage', 'nameAr': 'حقائب سفر وترولي', 'icon': Icons.luggage_rounded},
      ],
    },
    {
      'nameEn': 'Home & Kitchen',
      'nameAr': 'المنزل والمطبخ والديكور',
      'icon': Icons.chair_rounded,
      'subcategories': [
        {'nameEn': 'Coffee Makers & Blenders', 'nameAr': 'أجهزة قهوة وخلاطات', 'icon': Icons.coffee_maker_rounded},
        {'nameEn': 'Cookware Sets', 'nameAr': 'أواني طهي وقدور', 'icon': Icons.soup_kitchen_rounded},
        {'nameEn': 'LED Lighting', 'nameAr': 'إضاءات ولمبات LED', 'icon': Icons.lightbulb_rounded},
        {'nameEn': 'Curtains & Rugs', 'nameAr': 'سجاد ومفروشات', 'icon': Icons.texture_rounded},
      ],
    },
    {
      'nameEn': 'Machinery & Tools',
      'nameAr': 'المعدات والآلات الصناعية',
      'icon': Icons.precision_manufacturing_rounded,
      'subcategories': [
        {'nameEn': 'Laser Cutters & Engravers', 'nameAr': 'ماكينات ليزر وقص', 'icon': Icons.scatter_plot_rounded},
        {'nameEn': 'Packaging Machines', 'nameAr': 'ماكينات تغليف وتعبئة', 'icon': Icons.inventory_rounded},
        {'nameEn': 'Power Tools & Drills', 'nameAr': 'دريلات ومعدات يدوية', 'icon': Icons.build_rounded},
        {'nameEn': '3D Printers', 'nameAr': 'طابعات ثلاثية الأبعاد', 'icon': Icons.print_rounded},
      ],
    },
    {
      'nameEn': 'Beauty & Fragrances',
      'nameAr': 'العطور والعناية الشخصية',
      'icon': Icons.face_retouching_natural_rounded,
      'subcategories': [
        {'nameEn': 'Perfume Glass Bottles', 'nameAr': 'زجاجات عطور فارغة', 'icon': Icons.bubble_chart_rounded},
        {'nameEn': 'Hair Stylers & Dryers', 'nameAr': 'استشوارات وأجهزة شعر', 'icon': Icons.air_rounded},
        {'nameEn': 'Cosmetic Brushes', 'nameAr': 'فرش ومكياج', 'icon': Icons.brush_rounded},
      ],
    },
    {
      'nameEn': 'Toys & Stationery',
      'nameAr': 'الألعاب والقرطاسية',
      'icon': Icons.smart_toy_rounded,
      'subcategories': [
        {'nameEn': 'Educational Wooden Toys', 'nameAr': 'ألعاب خشبية تعليمية', 'icon': Icons.extension_rounded},
        {'nameEn': 'Remote Control RC Cars', 'nameAr': 'سيارات تحكم عن بعد', 'icon': Icons.directions_car_filled_rounded},
        {'nameEn': 'Notebooks & Pens', 'nameAr': 'دفاتر وأقلام جملة', 'icon': Icons.edit_note_rounded},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _loc,
      builder: (context, _) {
        final isRtl = _loc.isRtl;
        final currentCat = _categories[_selectedCategoryIndex];
        final subcats = currentCat['subcategories'] as List<Map<String, dynamic>>;

        return Directionality(
          textDirection: _loc.textDirection,
          child: Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(isRtl ? Icons.arrow_forward_ios_rounded : Icons.arrow_back_ios_new_rounded,
                    color: const Color(0xFF111827), size: 20),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                isRtl ? 'أقسام المنتجات والمصانع' : 'Product Categories',
                style: const TextStyle(fontFamily: 'Inter', fontSize: 17, fontWeight: FontWeight.w900, color: Color(0xFF111827)),
              ),
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProductSourcingPage()),
                  ),
                  icon: const Icon(Icons.saved_search_rounded, color: _orange, size: 18),
                  label: Text(
                    isRtl ? 'طلب خاص' : 'Request',
                    style: const TextStyle(fontWeight: FontWeight.w800, color: _orange),
                  ),
                ),
              ],
            ),
            body: Row(
              children: [
                // ── Left Sidebar (Categories)
                Container(
                  width: 105,
                  color: Colors.white,
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: _categories.length,
                    itemBuilder: (context, idx) {
                      final isSel = idx == _selectedCategoryIndex;
                      final cat = _categories[idx];

                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategoryIndex = idx),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                          decoration: BoxDecoration(
                            color: isSel ? const Color(0xFFFFF7ED) : Colors.white,
                            border: Border(
                              right: BorderSide(
                                color: isSel ? _orange : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(cat['icon'] as IconData, color: isSel ? _orange : const Color(0xFF64748B), size: 24),
                              const SizedBox(height: 5),
                              Text(
                                isRtl ? cat['nameAr'] as String : cat['nameEn'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10.5,
                                  fontWeight: isSel ? FontWeight.w900 : FontWeight.w500,
                                  color: isSel ? _orange : const Color(0xFF334155),
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Right Subcategories Grid
                Expanded(
                  child: Container(
                    color: const Color(0xFFF8FAFC),
                    child: ListView(
                      padding: const EdgeInsets.all(14),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // Category Header Banner
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFF1E6), Color(0xFFFFE4CE)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Icon(currentCat['icon'] as IconData, color: _orange, size: 28),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  isRtl ? currentCat['nameAr'] as String : currentCat['nameEn'] as String,
                                  style: const TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF9A3412),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Subcategories Grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.05,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                          itemCount: subcats.length,
                          itemBuilder: (context, sIdx) {
                            final sub = subcats[sIdx];
                            return GestureDetector(
                              onTap: () {
                                // Open Chinese Alibaba or Product Sourcing directly for this subcategory!
                                Navigator.of(context).push(
                                  MaterialPageRoute(builder: (_) => const SplashViewport()),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFE2E8F0)),
                                  boxShadow: const [
                                    BoxShadow(color: Color(0x04000000), blurRadius: 6, offset: Offset(0, 2)),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(sub['icon'] as IconData, color: const Color(0xFF334155), size: 24),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      isRtl ? sub['nameAr'] as String : sub['nameEn'] as String,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 11.5,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F172A),
                                        height: 1.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                        const SizedBox(height: 16),

                        // Bottom Sourcing Callout
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: const Color(0xFFFFD4B2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isRtl ? 'لم تجد منتجك المطلوب؟' : "Can't find what you need?",
                                style: const TextStyle(fontFamily: 'Inter', fontSize: 13, fontWeight: FontWeight.w800, color: Color(0xFF1E293B)),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                isRtl ? 'فريقنا في الصين يوفره لك من المصنع مباشرة بأفضل سعر.' : 'Our China sourcing team will quote any factory item directly.',
                                style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                width: double.infinity,
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(builder: (_) => const ProductSourcingPage()),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _orange,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  child: Text(
                                    isRtl ? 'طلب توريد خاص بالصورة' : 'Submit Custom Sourcing RFQ',
                                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
