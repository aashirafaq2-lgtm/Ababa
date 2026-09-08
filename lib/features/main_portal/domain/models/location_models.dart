import 'package:flutter/foundation.dart';

class CityItem {
  final String id;
  final String nameEn;
  final String nameAr;

  const CityItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
  });
}

class CountryItem {
  final String id;
  final String nameEn;
  final String nameAr;
  final String flagEmoji;
  final List<CityItem> cities;

  const CountryItem({
    required this.id,
    required this.nameEn,
    required this.nameAr,
    required this.flagEmoji,
    required this.cities,
  });
}

class LocationState extends ChangeNotifier {
  static final LocationState _instance = LocationState._internal();
  factory LocationState() => _instance;
  LocationState._internal();

  // All supported countries and cities (extensible by future backend/admin)
  final List<CountryItem> availableCountries = const [
    CountryItem(
      id: 'CN',
      nameEn: 'China',
      nameAr: 'الصين',
      flagEmoji: '🇨🇳',
      cities: [
        CityItem(id: 'CN_GZ', nameEn: 'Guangzhou', nameAr: 'قوانزو'),
        CityItem(id: 'CN_YW', nameEn: 'Yiwu', nameAr: 'إيو'),
        CityItem(id: 'CN_SZ', nameEn: 'Shenzhen', nameAr: 'شنجن'),
        CityItem(id: 'CN_SH', nameEn: 'Shanghai', nameAr: 'شنغهاي'),
        CityItem(id: 'CN_BJ', nameEn: 'Beijing', nameAr: 'بكين'),
      ],
    ),
    CountryItem(
      id: 'US',
      nameEn: 'USA',
      nameAr: 'الولايات المتحدة',
      flagEmoji: '🇺🇸',
      cities: [
        CityItem(id: 'US_NY', nameEn: 'New York', nameAr: 'نيويورك'),
        CityItem(id: 'US_LA', nameEn: 'Los Angeles', nameAr: 'لوس أنجلوس'),
        CityItem(id: 'US_CH', nameEn: 'Chicago', nameAr: 'شيكاغو'),
        CityItem(id: 'US_HO', nameEn: 'Houston', nameAr: 'هيوستن'),
        CityItem(id: 'US_MI', nameEn: 'Miami', nameAr: 'ميامي'),
      ],
    ),
    CountryItem(
      id: 'GB',
      nameEn: 'UK',
      nameAr: 'المملكة المتحدة',
      flagEmoji: '🇬🇧',
      cities: [
        CityItem(id: 'GB_LON', nameEn: 'London', nameAr: 'لندن'),
        CityItem(id: 'GB_MAN', nameEn: 'Manchester', nameAr: 'مانشستر'),
        CityItem(id: 'GB_BIR', nameEn: 'Birmingham', nameAr: 'برمنغهام'),
        CityItem(id: 'GB_LIV', nameEn: 'Liverpool', nameAr: 'ليفربول'),
      ],
    ),
    CountryItem(
      id: 'IQ',
      nameEn: 'Iraq',
      nameAr: 'العراق',
      flagEmoji: '🇮🇶',
      cities: [
        CityItem(id: 'IQ_BG', nameEn: 'Baghdad', nameAr: 'بغداد'),
        CityItem(id: 'IQ_ER', nameEn: 'Erbil', nameAr: 'أربيل'),
        CityItem(id: 'IQ_BS', nameEn: 'Basra', nameAr: 'البصرة'),
        CityItem(id: 'IQ_MS', nameEn: 'Mosul', nameAr: 'الموصل'),
      ],
    ),
    CountryItem(
      id: 'TR',
      nameEn: 'Türkiye',
      nameAr: 'تركيا',
      flagEmoji: '🇹🇷',
      cities: [
        CityItem(id: 'TR_IST', nameEn: 'Istanbul', nameAr: 'إسطنبول'),
        CityItem(id: 'TR_ANK', nameEn: 'Ankara', nameAr: 'أنقرة'),
        CityItem(id: 'TR_IZM', nameEn: 'Izmir', nameAr: 'إزمير'),
        CityItem(id: 'TR_BUR', nameEn: 'Bursa', nameAr: 'بورصة'),
      ],
    ),
    CountryItem(
      id: 'AE',
      nameEn: 'UAE',
      nameAr: 'الإمارات',
      flagEmoji: '🇦🇪',
      cities: [
        CityItem(id: 'AE_DXB', nameEn: 'Dubai', nameAr: 'دبي'),
        CityItem(id: 'AE_AUH', nameEn: 'Abu Dhabi', nameAr: 'أبو ظبي'),
        CityItem(id: 'AE_SHJ', nameEn: 'Sharjah', nameAr: 'الشارقة'),
      ],
    ),
    CountryItem(
      id: 'SA',
      nameEn: 'Saudi Arabia',
      nameAr: 'السعودية',
      flagEmoji: '🇸🇦',
      cities: [
        CityItem(id: 'SA_RUH', nameEn: 'Riyadh', nameAr: 'الرياض'),
        CityItem(id: 'SA_JED', nameEn: 'Jeddah', nameAr: 'جدة'),
        CityItem(id: 'SA_DMM', nameEn: 'Dammam', nameAr: 'الدمام'),
      ],
    ),
    CountryItem(
      id: 'QA',
      nameEn: 'Qatar',
      nameAr: 'قطر',
      flagEmoji: '🇶🇦',
      cities: [
        CityItem(id: 'QA_DOH', nameEn: 'Doha', nameAr: 'الدوحة'),
      ],
    ),
    CountryItem(
      id: 'DE',
      nameEn: 'Germany',
      nameAr: 'ألمانيا',
      flagEmoji: '🇩🇪',
      cities: [
        CityItem(id: 'DE_BER', nameEn: 'Berlin', nameAr: 'برلين'),
        CityItem(id: 'DE_MUN', nameEn: 'Munich', nameAr: 'ميونخ'),
        CityItem(id: 'DE_FRA', nameEn: 'Frankfurt', nameAr: 'فرانكفورت'),
        CityItem(id: 'DE_HAM', nameEn: 'Hamburg', nameAr: 'هامبورغ'),
      ],
    ),
    CountryItem(
      id: 'CA',
      nameEn: 'Canada',
      nameAr: 'كندا',
      flagEmoji: '🇨🇦',
      cities: [
        CityItem(id: 'CA_TOR', nameEn: 'Toronto', nameAr: 'تورونتو'),
        CityItem(id: 'CA_VAN', nameEn: 'Vancouver', nameAr: 'فانكوفر'),
        CityItem(id: 'CA_MTL', nameEn: 'Montreal', nameAr: 'مونتريال'),
        CityItem(id: 'CA_CAL', nameEn: 'Calgary', nameAr: 'كالغاري'),
      ],
    ),
  ];

  // DEFAULT LOCATION: China - Guangzhou (Strict requirement)
  late CountryItem _selectedCountry = availableCountries.first;
  late CityItem _selectedCity = availableCountries.first.cities.first;

  CountryItem get selectedCountry => _selectedCountry;
  CityItem get selectedCity => _selectedCity;

  String get displayTextEn => '${_selectedCountry.nameEn} - ${_selectedCity.nameEn}';
  String get displayTextAr => '${_selectedCountry.nameAr} - ${_selectedCity.nameAr}';

  void setLocation(CountryItem country, CityItem city) {
    _selectedCountry = country;
    _selectedCity = city;
    notifyListeners();
  }
}
