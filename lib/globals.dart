import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// =======================
// AUTHENTICATION STATE
// =======================
bool isAdmin = false;
const String adminUsername = 'admin';
const String adminPassword = '123';

// =======================
// CONFIGURATION & STYLES
// =======================
const List<String> genreTags = [
  'Semua',
  'Metal',
  'Rock',
  'R&B',
  'Pop',
  'K-Pop',
  'Indie',
  'Reggae',
  'Punk',
  'Electronic',
  'Jazz',
];

const Map<String, Color> genreColors = {
  'Metal': Color(0xFF9E9E9E),
  'Rock': Color(0xFFFF5252),
  'R&B': Color(0xFF4CAF50),
  'Pop': Color(0xFF40C4FF),
  'K-Pop': Color(0xFFFF4081),
  'Indie': Color(0xFF7C4DFF),
  'Reggae': Color(0xFFFFC107),
  'Punk': Color(0xFFE91E63),
  'Electronic': Color(0xFF00E5FF),
  'Jazz': Color(0xFF8D6E63),
  'Semua': Color(0xFFEEEEEE),
};

// =======================
// WISHLIST SYSTEM
// =======================
List<String> globalWishlistItems = [];

Future<void> loadWishlist() async {
  final prefs = await SharedPreferences.getInstance();
  globalWishlistItems = prefs.getStringList('wishlist_key') ?? [];
}

Future<void> _saveWishlistToPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('wishlist_key', globalWishlistItems);
}

void addToWishlist(String item) {
  if (!globalWishlistItems.contains(item)) {
    globalWishlistItems.add(item);
    _saveWishlistToPrefs();
  }
}

void removeFromWishlist(String item) {
  if (globalWishlistItems.contains(item)) {
    globalWishlistItems.remove(item);
    _saveWishlistToPrefs();
  }
}

// =======================
// BAND DATA (DEFAULT)
// =======================
List<Map<String, dynamic>> defaultBandData = [
  {
    'band': 'The S.I.G.I.T',
    'genre': 'Rock',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'location': 'Jakarta',
    'title': 'Intimate Concert 2024',
    'main_photo': 'thesgigit.jpeg',
    'bio': 'Band rock legendaris asal Bandung.',
    'albums': ['Visible Idea of Perfection', 'Detourn'],
  },
  {
    'band': 'Dewa 19',
    'genre': 'Rock',
    'date': '12 Des',
    'price': 'Rp 550.000',
    'location': 'Surabaya',
    'title': 'Pesta Rakyat',
    'main_photo': 'dewa.jpeg',
    'bio': 'Dewa 19 adalah salah satu band rock terbesar dalam sejarah musik Indonesia.',
    'albums': ['Bintang Lima', 'Pandawa Lima'],
  },
  {
    'band': 'NewJeans',
    'genre': 'K-Pop',
    'date': '20 Des',
    'price': 'Rp 2.500.000',
    'location': 'Jakarta',
    'title': 'World Tour Asia',
    'main_photo': 'newjeans.jpeg',
    'bio': 'NewJeans adalah girl grup Korea Selatan.',
    'albums': ['Get Up', 'OMG'],
  },

  // =======================
  // BAND TAMBAHAN (BARU)
  // =======================
  {
    'band': 'Colorcode',
    'genre': 'Electronic',
    'date': '12 Jul',
    'price': 'Rp 150.000',
    'location': 'Jakarta',
    'title': 'Colorcode Live Session',
    'main_photo': 'colorcode.jpeg',
    'bio': 'Colorcode adalah band electronic-pop Indonesia dengan nuansa futuristik.',
    'albums': ['Future Echoes'],
  },
  {
    'band': 'Eleventwelfth',
    'genre': 'Indie',
    'date': '18 Jul',
    'price': 'Rp 120.000',
    'location': 'Bandung',
    'title': 'Eleventwelfth Indie Night',
    'main_photo': 'eleventwelfth.jpeg',
    'bio': 'Eleventwelfth dikenal dengan musik indie pop-rock yang catchy.',
    'albums': ['Lucky Number', 'When We Were Young'],
  },
  {
    'band': 'Stars and Rabbit',
    'genre': 'Indie',
    'date': '25 Jul',
    'price': 'Rp 130.000',
    'location': 'Yogyakarta',
    'title': 'Stars and Rabbit Live',
    'main_photo': 'starsandrabbit.jpeg',
    'bio': 'Stars and Rabbit adalah duo indie folk dengan nuansa eksperimental.',
    'albums': ['Elysian'],
  },
  {
    'band': 'Vierra',
    'genre': 'Pop',
    'date': '02 Agu',
    'price': 'Rp 200.000',
    'location': 'Jakarta',
    'title': 'Vierra Reunion Concert',
    'main_photo': 'vierra.jpeg',
    'bio': 'Vierra adalah band pop legendaris Indonesia dengan lagu-lagu romantis.',
    'albums': ['My First Love'],
  },
  {
    'band': 'Sore Ze Band',
    'genre': 'Jazz',
    'date': '10 Agu',
    'price': 'Rp 180.000',
    'location': 'Jakarta',
    'title': 'Sore Live at Sunset',
    'main_photo': 'sore.jpeg',
    'bio': 'Sore dikenal dengan musik jazz-pop yang unik dan lirik puitis.',
    'albums': ['Centralismo'],
  },
  {
    'band': 'Kangen Band',
    'genre': 'Pop',
    'date': '15 Agu',
    'price': 'Rp 100.000',
    'location': 'Lampung',
    'title': 'Kangen Band Nostalgia Night',
    'main_photo': 'kangen_band.jpeg',
    'bio': 'Kangen Band adalah ikon pop Melayu Indonesia.',
    'albums': ['Tentang Aku, Kau dan Dia'],
  },
];

// =======================
// GLOBAL BAND DATA
// =======================
List<Map<String, dynamic>> globalBandData = [];

// =======================
// PERSISTENCE FUNCTIONS
// =======================
Future<void> saveBandDataToStorage() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('saved_band_data', jsonEncode(globalBandData));
}

Future<void> loadBandDataFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  String? savedData = prefs.getString('saved_band_data');

  if (savedData != null && savedData.isNotEmpty) {
    Iterable decoded = jsonDecode(savedData);
    globalBandData =
        decoded.map((e) => Map<String, dynamic>.from(e)).toList();
  } else {
    globalBandData = List.from(defaultBandData);
  }
}

// =======================
// ADMIN FUNCTIONS
// =======================
void addBandData(Map<String, dynamic> newBand) {
  globalBandData.insert(0, newBand);
  saveBandDataToStorage();
}

void removeBandData(int index) {
  if (index >= 0 && index < globalBandData.length) {
    globalBandData.removeAt(index);
    saveBandDataToStorage();
  }
}
