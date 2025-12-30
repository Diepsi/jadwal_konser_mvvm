// lib/globals.dart

import 'dart:convert'; // Wajib untuk jsonEncode & jsonDecode
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- AUTHENTICATION STATE ---
// Variabel global untuk status admin lama (agar kompatibel dengan kode lama)
bool isAdmin = false; 
const String adminUsername = 'admin';
const String adminPassword = '123';

// --- CONFIGURATION & STYLES ---
// Dipindahkan ke sini agar bisa diakses oleh Home, News, dan ViewModel tanpa konflik import
const List<String> genreTags = [
  'Semua', 'Metal', 'Rock', 'R&B', 'Pop', 'K-Pop', 'Indie', 'Reggae', 'Punk',
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
  'Semua': Color(0xFFEEEEEE),
};

// --- WISHLIST SYSTEM WITH PERSISTENCE ---
List<String> globalWishlistItems = [];

/// Memuat data wishlist dari SharedPreferences
Future<void> loadWishlist() async {
  final prefs = await SharedPreferences.getInstance();
  globalWishlistItems = prefs.getStringList('wishlist_key') ?? [];
}

/// Menyimpan data wishlist secara internal
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

// --- BAND DATA WITH PERSISTENCE ---

// Data awal sebagai cadangan jika storage kosong
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
];

List<Map<String, dynamic>> globalBandData = [];

// --- PERSISTENCE FUNCTIONS ---

/// Menyimpan data band ke storage dalam format JSON String
Future<void> saveBandDataToStorage() async {
  final prefs = await SharedPreferences.getInstance();
  String encodedData = jsonEncode(globalBandData);
  await prefs.setString('saved_band_data', encodedData);
}

/// Memuat data band dari storage. Digunakan oleh MainViewModel.refreshData()
Future<void> loadBandDataFromStorage() async {
  final prefs = await SharedPreferences.getInstance();
  String? savedData = prefs.getString('saved_band_data');

  if (savedData != null && savedData.isNotEmpty) {
    Iterable decoded = jsonDecode(savedData);
    globalBandData = decoded.map((item) => Map<String, dynamic>.from(item)).toList();
  } else {
    // Jika storage kosong, gunakan data default
    globalBandData = List.from(defaultBandData);
  }
}

// --- ADMIN FUNCTIONS ---

/// Menambah data band baru dan menyimpannya secara permanen
void addBandData(Map<String, dynamic> newBand) {
  globalBandData.insert(0, newBand);
  saveBandDataToStorage(); 
}

/// Menghapus data band berdasarkan index dan memperbarui storage
void removeBandData(int index) {
  if (index >= 0 && index < globalBandData.length) {
    globalBandData.removeAt(index);
    saveBandDataToStorage();
  }
}