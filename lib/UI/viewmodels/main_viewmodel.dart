// lib/ui/viewmodels/main_viewmodel.dart

import 'package:flutter/material.dart';
import '../../data/models/band_model.dart';
import '../../data/repositories/band_repository.dart';
import '../../globals.dart'; // Akses globalBandData, globalWishlistItems, loadBandDataFromStorage, loadWishlist

class MainViewModel extends ChangeNotifier {
  final BandRepository _repository = BandRepository();

  List<BandModel> _allBands = [];
  String _selectedGenre = 'Semua';
  bool _isLoading = false;

  MainViewModel() {
    refreshData();
  }

  // --- GETTERS ---
  List<BandModel> get allBands => _allBands;
  String get selectedGenre => _selectedGenre;
  bool get isLoading => _isLoading;

  // Mengambil data yang sudah difilter berdasarkan genre
  List<BandModel> get filteredBands {
    if (_selectedGenre == 'Semua') {
      return _allBands;
    }
    return _allBands.where((band) => band.genre == _selectedGenre).toList();
  }

  // --- LOGIKA BISNIS ---

  /// Fungsi utama untuk menyegarkan data dari penyimpanan lokal ke dalam aplikasi.
  /// Dipanggil saat app terbuka, refresh manual, atau setelah Admin menambah/menghapus data.
  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Muat ulang data mentah dari SharedPreferences ke variabel global
      await loadBandDataFromStorage();
      await loadWishlist();

      // 2. Konversi data mentah di globals menjadi List of Model melalui Repository
      _allBands = _repository.getAllBands();
      
    } catch (e) {
      debugPrint("Error refreshData pada ViewModel: $e");
    } finally {
      _isLoading = false;
      // 3. Memberitahu UI (Consumer) untuk menggambar ulang dengan data terbaru
      notifyListeners();
    }
  }

  // Mengubah filter genre
  void setGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  // --- LOGIKA WISHLIST ---

  /// Cek status favorit berdasarkan kunci unik (Nama + Genre + Lokasi)
  bool isFavorite(BandModel band) {
    final wishlistKey = '${band.band} - ${band.genre} ${band.location}';
    return globalWishlistItems.contains(wishlistKey);
  }

  /// Tambah/Hapus dari wishlist. 
  /// Karena fungsi di globals.dart sudah memanggil _saveToPrefs, 
  /// kita hanya perlu memicu notifyListeners() agar UI berubah.
  void toggleWishlist(BandModel band) {
    final wishlistKey = '${band.band} - ${band.genre} ${band.location}';

    if (globalWishlistItems.contains(wishlistKey)) {
      removeFromWishlist(wishlistKey); // Otomatis simpan ke SharedPreferences
    } else {
      addToWishlist(wishlistKey); // Otomatis simpan ke SharedPreferences
    }

    // Memicu rebuild pada ikon di Home dan list di Wishlist Screen secara real-time
    notifyListeners();
  }
}