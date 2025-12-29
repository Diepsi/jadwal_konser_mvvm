// lib/globals.dart

import 'package:shared_preferences/shared_preferences.dart';

// Global Var untuk Auth Admin
bool isAdmin = false;
const String adminUsername = 'admin';
const String adminPassword = '123';

// --- SISTEM WISHLIST DENGAN PERSISTENCE ---
List<String> globalWishlistItems = [];

// Fungsi untuk memuat data wishlist dari storage saat aplikasi dibuka
Future<void> loadWishlist() async {
  final prefs = await SharedPreferences.getInstance();
  // Mengambil list string dengan key 'wishlist_key'
  globalWishlistItems = prefs.getStringList('wishlist_key') ?? [];
}

// Fungsi internal untuk menyimpan setiap perubahan ke storage
Future<void> _saveToPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('wishlist_key', globalWishlistItems);
}

void addToWishlist(String item) {
  if (!globalWishlistItems.contains(item)) {
    globalWishlistItems.add(item);
    _saveToPrefs(); // Simpan perubahan secara permanen
  }
}

void removeFromWishlist(String item) {
  if (globalWishlistItems.contains(item)) {
    globalWishlistItems.remove(item);
    _saveToPrefs(); // Simpan perubahan secara permanen
  }
}

// --- DATA BAND GLOBAL ---
// Keys yang digunakan: 'band', 'genre', 'title', 'date', 'price', 'location', 'main_photo', 'bio', 'albums'
List<Map<String, dynamic>> globalBandData = [
  {
    'band': 'The S.I.G.I.T',
    'genre': 'Rock',
    'date': '10 Des',
    'price': 'Rp 350.000',
    'location': 'Jakarta',
    'title': 'Intimate Concert 2024',
    'main_photo': 'thesgigit.jpeg',
    'excerpt': 'Band rock legendaris asal Bandung.',
    'bio': 'The Super Insurgent Group of Intemperance Talent adalah band rock Indonesia yang dikenal dengan energi panggungnya yang luar biasa.',
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
    'excerpt': 'Konser reuni terbesar tahun ini.',
    'bio': 'Dewa 19 adalah salah satu band rock terbesar dalam sejarah musik Indonesia yang dipimpin oleh Ahmad Dhani.',
    'albums': ['Bintang Lima', 'Pandawa Lima', 'Format Masa Depan'],
  },
  {
    'band': 'Slank',
    'genre': 'Rock',
    'date': '15 Des',
    'price': 'Rp 150.000',
    'location': 'Jakarta',
    'title': 'Slank Nggak Ada Matinya',
    'main_photo': 'slank.jpeg',
    'excerpt': 'Konser ulang tahun Slank ke-40.',
    'bio': 'Slank adalah grup musik rock papan atas Indonesia yang dibentuk pada tahun 1983 di Jakarta.',
    'albums': ['Kampungan', 'Piss', 'Generasi Biru'],
  },
  {
    'band': 'NewJeans',
    'genre': 'K-Pop',
    'date': '20 Des',
    'price': 'Rp 2.500.000',
    'location': 'Jakarta',
    'title': 'World Tour Asia',
    'main_photo': 'newjeans.jpeg',
    'excerpt': 'Girlband K-Pop fenomenal hadir di Jakarta.',
    'bio': 'NewJeans adalah girl grup Korea Selatan yang dibentuk oleh ADOR, anak perusahaan HYBE.',
    'albums': ['Get Up', 'New Jeans', 'OMG'],
  },
  {
    'band': 'Tulus',
    'genre': 'Pop',
    'date': '22 Des',
    'price': 'Rp 400.000',
    'location': 'Yogyakarta',
    'title': 'Tur Manusia',
    'main_photo': 'tulus.jpeg',
    'excerpt': 'Bernyanyi bersama Tulus di kota pelajar.',
    'bio': 'Muhammad Tulus adalah penyanyi-penulis lagu Indonesia yang memiliki karakter vokal yang sangat khas.',
    'albums': ['Gajah', 'Monokrom', 'Manusia'],
  },
  {
    'band': 'NDX AKA',
    'genre': 'Hip-Hop',
    'date': '30 Des',
    'price': 'Rp 100.000',
    'location': 'Semarang',
    'title': 'Ambyar Party',
    'main_photo': 'ndx.jpeg',
    'excerpt': 'Hip-hop dangdut koplo pemersatu bangsa.',
    'bio': 'NDX A.K.A adalah grup musik hip-hop dangdut asal Yogyakarta yang memadukan lirik bahasa Jawa dengan ketukan hip-hop.',
    'albums': ['Best of NDX', 'Pintu Taubat'],
  },
  {
    'band': 'Bring Me The Horizon',
    'genre': 'Metal',
    'title': 'Konser Jakarta 2024',
    'date': '2 jam yang lalu',
    'price': 'Rp 1.200.000',
    'location': 'Jakarta',
    'excerpt': 'Band metalcore asal Inggris siap guncang Jakarta...',
    'bio': 'Bring Me The Horizon adalah band rock Inggris yang dibentuk di Sheffield pada tahun 2004.',
    'main_photo': 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8c/Bring_Me_The_Horizon_-_Rock_am_Ring_2019-2729.jpg/800px-Bring_Me_The_Horizon_-_Rock_am_Ring_2019-2729.jpg',
    'albums': ['Sempiternal', 'That\'s The Spirit', 'AMO'],
  },
  {
    'band': 'Reality Club',
    'genre': 'Indie',
    'title': 'Tur Album Baru',
    'date': '5 jam yang lalu',
    'price': 'Rp 250.000',
    'location': 'Bandung',
    'excerpt': 'Reality Club umumkan jadwal tur keliling Jawa...',
    'bio': 'Reality Club adalah band indie rock asal Jakarta yang telah menembus pasar internasional.',
    'main_photo': 'https://asset.kompas.com/crops/O_w4Z0tW2qFfC84yF6_3p3z9gX8=/0x0:1000x667/750x500/data/photo/2023/06/07/64804c7c8c8c8.jpg',
    'albums': ['Never Get Better', 'What Do You Really Know?'],
  },
];

// FUNGSI ADMIN
void addBandData(Map<String, dynamic> newBand) {
  globalBandData.insert(0, newBand);
}

void removeBandData(int index) {
  if (index >= 0 && index < globalBandData.length) {
    globalBandData.removeAt(index);
  }
}