import 'package:flutter/material.dart';

enum ChinaBoxLanguage { english, arabic }

class ChinaBoxLocalization extends ChangeNotifier {
  static final ChinaBoxLocalization _instance =
      ChinaBoxLocalization._internal();
  factory ChinaBoxLocalization() => _instance;
  ChinaBoxLocalization._internal();

  // Default is English as requested by user ("boht achy sy english main banao")
  ChinaBoxLanguage _currentLanguage = ChinaBoxLanguage.english;

  ChinaBoxLanguage get currentLanguage => _currentLanguage;
  bool get isRtl => _currentLanguage == ChinaBoxLanguage.arabic;
  TextDirection get textDirection =>
      isRtl ? TextDirection.rtl : TextDirection.ltr;
  Locale get locale => isRtl ? const Locale('ar', '') : const Locale('en', '');

  void setLanguage(ChinaBoxLanguage lang) {
    if (_currentLanguage != lang) {
      _currentLanguage = lang;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    setLanguage(
      _currentLanguage == ChinaBoxLanguage.arabic
          ? ChinaBoxLanguage.english
          : ChinaBoxLanguage.arabic,
    );
  }

  // Complete Dictionary for Global Multi-Screen Localization
  static const Map<String, Map<String, String>> _strings = {
    // Top Bar & App
    'my_china_box': {
      'en': 'My China Box',
      'ar': 'صندوق الصين الخاص بي',
    },
    'app_name': {
      'en': 'A.BABA',
      'ar': 'أ.بابا',
    },
    'language_name': {
      'en': 'English',
      'ar': 'العربية',
    },
    // Home Screen
    'welcome_ahmed': {
      'en': 'Welcome Ahmed',
      'ar': 'مرحباً أحمد',
    },
    'serve_you': {
      'en': 'We are here to serve you',
      'ar': 'نحن هنا لخدمتك',
    },
    'notifications': {
      'en': 'Notifications',
      'ar': 'الإشعارات',
    },
    'messages': {
      'en': 'Messages',
      'ar': 'الرسائل',
    },
    'account': {
      'en': 'Account',
      'ar': 'الحساب',
    },
    'profile': {
      'en': 'Profile',
      'ar': 'الملف الشخصي',
    },
    'exclusive_offers': {
      'en': 'Exclusive Offers',
      'ar': 'عروض حصرية',
    },
    'ship_faster_better_prices': {
      'en': 'Ship faster ... Better prices',
      'ar': 'شحن أسرع ... أسعار أفضل',
    },
    'explore_offers': {
      'en': 'Explore Offers',
      'ar': 'استكشف العروض',
    },
    'our_services': {
      'en': 'Our Services',
      'ar': 'خدماتنا',
    },
    'view_all': {
      'en': 'View All',
      'ar': 'عرض الكل',
    },
    // Stories Tray
    'story_news': {
      'en': 'Latest News',
      'ar': 'آخر الأخبار',
    },
    'story_offers': {
      'en': 'Offers',
      'ar': 'العروض',
    },
    'story_shipping': {
      'en': 'Shipping',
      'ar': 'الشحن',
    },
    'story_china': {
      'en': 'China',
      'ar': 'الصين',
    },
    'story_shipments': {
      'en': 'Shipments',
      'ar': 'الشحنات',
    },
    'story_points': {
      'en': 'Points',
      'ar': 'النقاط',
    },
    'story_more': {
      'en': 'More',
      'ar': 'المزيد',
    },
    // 10 Main Services
    'svc_1': {
      'en': 'Chinese\nAlibaba',
      'ar': 'علي بابا\nالصيني',
    },
    'svc_2': {
      'en': 'My China\nBox',
      'ar': 'صندوق\nالصين',
    },
    'svc_3': {
      'en': 'Container\nShipping',
      'ar': 'شحن\nالحاويات',
    },
    'svc_4': {
      'en': 'Customs\nClearance',
      'ar': 'التخليص\nالجمركي',
    },
    'svc_5': {
      'en': 'Add New\nOrder',
      'ar': 'إضافة\nطلب جديد',
    },
    'svc_6': {
      'en': 'Search for\na Specific\nProduct',
      'ar': 'البحث عن\nمنتج معين',
    },
    'svc_7': {
      'en': 'Travel, Residency\n& Immigration',
      'ar': 'السفر والإقامة\nوالهجرة',
    },
    'svc_8': {
      'en': 'Help with\nProblem Solving',
      'ar': 'المساعدة في\nحل المشكلات',
    },
    'svc_9': {
      'en': 'Purchases from\nFutian',
      'ar': 'المشتريات من\nفوتيان',
    },
    'svc_10': {
      'en': 'Verification of\nTrusted Seller',
      'ar': 'التحقق من\nالبائع الموثوق',
    },
    // Dashboard & Flow
    'manage_shipments_subtitle': {
      'en': 'Manage your shipments in our warehouse in China',
      'ar': 'إدارة شحناتك في مستودعنا في الصين',
    },
    'choose_storage_type': {
      'en': 'Choose Your Storage Type',
      'ar': 'اختر نوع التخزين الخاص بك',
    },
    'storage_type_subtitle': {
      'en':
          'We have safe storage and shipping solutions for your products from China',
      'ar': 'لدينا حلول تخزين وشحن آمنة لمنتجاتك من الصين',
    },
    'wholesale': {
      'en': 'Wholesale',
      'ar': 'جملة',
    },
    'wholesale_desc': {
      'en': 'Buy large quantities of the same product from one supplier',
      'ar': 'شراء كميات كبيرة من نفس المنتج من مورد واحد',
    },
    'consolidation': {
      'en': 'Consolidation',
      'ar': 'تجميع',
    },
    'consolidation_desc': {
      'en':
          'Buy multiple products from different suppliers and consolidate them into one shipment',
      'ar': 'شراء منتجات متعددة من موردين مختلفين وتجميعها في شحنة واحدة',
    },
    'enter_wholesale': {
      'en': 'Enter Wholesale Section',
      'ar': 'دخول قسم الجملة',
    },
    'enter_consolidation': {
      'en': 'Enter Consolidation Section',
      'ar': 'دخول قسم التجميع',
    },
    'better_price': {
      'en': 'Better Price',
      'ar': 'سعر أفضل',
    },
    'commercial_quantities': {
      'en': 'Commercial Quantities',
      'ar': 'كميات تجارية',
    },
    'direct_shipping': {
      'en': 'Direct Shipping & Larger Volume',
      'ar': 'شحن مباشر وحجم أكبر',
    },
    'from_one_supplier': {
      'en': 'From One Supplier',
      'ar': 'من مورد واحد',
    },
    'multiple_suppliers': {
      'en': 'Multiple Suppliers',
      'ar': 'موردون متعددون',
    },
    'multiple_products': {
      'en': 'Multiple Products',
      'ar': 'منتجات متعددة',
    },
    'consolidate_one_shipment': {
      'en': 'Consolidate into One Shipment',
      'ar': 'تجميع في شحنة واحدة',
    },
    'one_shipment_one_package': {
      'en': 'One Shipment in One Package',
      'ar': 'شحنة واحدة في طرد واحد',
    },
    'warehouse_in_china': {
      'en': 'Title: Your Warehouse in China',
      'ar': 'عنوان مخزنك في الصين',
    },
    'warehouse_notice': {
      'en': 'You will find every section inside after registering your request',
      'ar': 'ستجد كل قسم بالداخل بعد تسجيل طلبك',
    },
    'copy_address': {
      'en': 'Copy Address',
      'ar': 'نسخ العنوان',
    },
    'view_on_map': {
      'en': 'View on Map',
      'ar': 'عرض على الخريطة',
    },
    'your_boxes_to_consolidate': {
      'en': 'Your Boxes for Consolidation',
      'ar': 'صناديقك للتجميع',
    },
    'all_boxes_waiting': {
      'en':
          'All boxes that arrived at our warehouse waiting to be consolidated and shipped',
      'ar': 'جميع الصناديق التي وصلت إلى مخزننا وتنتظر تجميعها وشحنها',
    },
    'filter': {
      'en': 'Filter',
      'ar': 'فلتر',
    },
    'search': {
      'en': 'Search',
      'ar': 'بحث',
    },
    'select_all': {
      'en': 'Select All',
      'ar': 'تحديد الكل',
    },
    'transfer': {
      'en': 'Transfer',
      'ar': 'نقل',
    },
    'delete': {
      'en': 'Delete',
      'ar': 'حذف',
    },
    'boxes_selected': {
      'en': 'boxes selected',
      'ar': 'صناديق محددة',
    },
    'ready_for_consolidation_and_shipping': {
      'en': 'Ready for consolidation and shipping',
      'ar': 'جاهزة للتجميع والشحن',
    },
    'consolidate_and_ship_selected': {
      'en': 'Consolidate & Ship Selected Boxes',
      'ar': 'تجميع وشحن الصناديق المحددة',
    },
    'in_warehouse': {
      'en': 'In Warehouse',
      'ar': 'في المخزن',
    },
    'ready_to_pack': {
      'en': 'Ready to Pack',
      'ar': 'جاهزة للتجميع',
    },
    'shipped_tab': {
      'en': 'Shipped to',
      'ar': 'تم شحنها إلى',
    },
    'under_review': {
      'en': 'Under Review',
      'ar': 'قيد المراجعة',
    },
    'rejected': {
      'en': 'Rejected',
      'ar': 'مرفوضة',
    },
    'dimensions': {
      'en': 'Dimensions',
      'ar': 'القياس',
    },
    'weight': {
      'en': 'Weight',
      'ar': 'الوزن',
    },
    'arrival_date': {
      'en': 'Arrival Date',
      'ar': 'تاريخ الوصول',
    },
    'tracking_number': {
      'en': 'Tracking Number',
      'ar': 'رقم التتبع',
    },
    // Shipping Method Screen (Matches exact user screenshot)
    'shipping_details': {
      'en': 'Select Shipping Method',
      'ar': 'اختيار طريقة الشحن',
    },
    'select_shipping_method': {
      'en': 'Select Shipping Method',
      'ar': 'اختيار طريقة الشحن',
    },
    'choose_shipping_method_sub': {
      'en': 'Choose the right shipping method for your shipment',
      'ar': 'اختر طريقة الشحن المناسبة لوجبتك',
    },
    'total_weight': {
      'en': 'Total Weight',
      'ar': 'الوزن الإجمالي',
    },
    'total_volume': {
      'en': 'Total Volume',
      'ar': 'الحجم الكلي',
    },
    'carton_count': {
      'en': 'Carton Count',
      'ar': 'عدد الكراتين',
    },
    'carton_unit': {
      'en': 'carton',
      'ar': 'كرتون',
    },
    'kg_unit': {
      'en': 'KG',
      'ar': 'كجم',
    },
    'air_fast_badge': {
      'en': 'Fast & suitable for urgent shipments',
      'ar': 'سريع ومناسب للشحنات العاجلة',
    },
    'sea_eco_badge': {
      'en': 'Economical & suitable for large shipments',
      'ar': 'اقتصادي ومناسب للشحنات الكبيرة',
    },
    'price_per_kg': {
      'en': 'Price / KG',
      'ar': 'سعر الكيلو',
    },
    'price_per_cbm': {
      'en': 'Price / CBM',
      'ar': 'سعر الـ CBM',
    },
    'total_shipping': {
      'en': 'Total Shipping',
      'ar': 'إجمالي الشحن',
    },
    'air_freight': {
      'en': 'Air Freight',
      'ar': 'الشحن الجوي',
    },
    'air_freight_desc': {
      'en': 'Fastest arrival for your goods',
      'ar': 'أسرع وصول لبضاعتك',
    },
    'sea_freight': {
      'en': 'Sea Freight',
      'ar': 'الشحن البحري',
    },
    'sea_freight_desc': {
      'en': 'Most cost-effective',
      'ar': 'الأوفر لتوفير التكلفة',
    },
    'estimated_time': {
      'en': 'Estimated Time',
      'ar': 'المدة المتوقعة',
    },
    'air_days': {
      'en': '3 - 7 Days',
      'ar': '3 - 7 أيام',
    },
    'sea_days': {
      'en': '20 - 35 Days',
      'ar': '20 - 35 يوم',
    },
    'shipping_cost': {
      'en': 'Shipping Cost',
      'ar': 'تكلفة الشحن',
    },
    'shipping_disclaimer': {
      'en':
          'Prices include international shipping only and do not include customs duties in your country.',
      'ar': 'الأسعار تشمل الشحن الدولي فقط ولا تشمل الرسوم الجمركية في بلدك.',
    },
    'continue_btn': {
      'en': 'Continue',
      'ar': 'متابعة',
    },
    // Trust section
    'trust_secure': {
      'en': 'Secure\nYour goods are in safe hands',
      'ar': 'آمن\nبضائعك في أيد أمينة',
    },
    'trust_photos': {
      'en': 'Photos & Inspection\nWhen your products arrive',
      'ar': 'صور وفحص\nعند وصول منتجاتك',
    },
    'trust_warehouse': {
      'en': 'Private Warehouse in China\nJust for you',
      'ar': 'مخزن خاص في الصين\nلك وحدك',
    },
    'trust_support': {
      'en': 'Customer Support\nUntil you receive your order',
      'ar': 'دعم العملاء\nحتى استلام طلبك',
    },
    // Wholesale Screen Keys
    'wholesale_title': {
      'en': 'Wholesale',
      'ar': 'جملة',
    },
    'wholesale_subtitle': {
      'en': 'Select the batches that arrived at the warehouse',
      'ar': 'اختر الوجبات التي وصلت إلى المخزن',
    },
    'air_short': {
      'en': 'Air',
      'ar': 'جوي',
    },
    'sea_short': {
      'en': 'Sea',
      'ar': 'بحري',
    },
    'request_photo': {
      'en': 'Request Photo',
      'ar': 'طلب صورة',
    },
    'request_carton_count': {
      'en': 'Request Carton Count',
      'ar': 'طلب عدد الكراتين',
    },
    'total_volume_cbm': {
      'en': 'Total Volume (CBM)',
      'ar': 'حجم كلي (CBM)',
    },
    'received_carton_count': {
      'en': 'Received Cartons',
      'ar': 'عدد الكراتين المستلمة',
    },
    'receipt_date': {
      'en': 'Receipt Date',
      'ar': 'تاريخ الاستلام',
    },
    'ship_selected_boxes': {
      'en': 'Ship Selected Boxes',
      'ar': 'شحن الصناديق المحددة',
    },
    'box_selected_unit': {
      'en': 'box selected',
      'ar': 'صندوق محدد',
    },
    'boxes_selected_unit': {
      'en': 'boxes selected',
      'ar': 'صناديق محددة',
    },
    // Navigation
    'nav_home': {
      'en': 'Home',
      'ar': 'الرئيسية',
    },
    'nav_consolidation': {
      'en': 'Consolidation',
      'ar': 'تجميع',
    },
    'nav_wholesale': {
      'en': 'Wholesale',
      'ar': 'جملة',
    },
    'nav_tracking': {
      'en': 'Shipments',
      'ar': 'متابعة الشحنات',
    },
    'nav_categories': {
      'en': 'Categories',
      'ar': 'الفئات',
    },
    'nav_my_orders': {
      'en': 'My Orders',
      'ar': 'طلباتي',
    },
    'nav_messages': {
      'en': 'Messages',
      'ar': 'الرسائل',
    },
    'nav_account': {
      'en': 'Account',
      'ar': 'الحساب',
    },
  };

  String tr(String key) {
    final langKey = _currentLanguage == ChinaBoxLanguage.arabic ? 'ar' : 'en';
    return _strings[key]?[langKey] ?? key;
  }
}
