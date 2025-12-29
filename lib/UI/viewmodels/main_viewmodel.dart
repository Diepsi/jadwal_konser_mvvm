import 'package:flutter/material.dart';
import '../../data/models/band_model.dart';
import '../../data/repositories/band_repository.dart';
import '../../globals.dart'; // Untuk mengakses globalWishlistItems

class MainViewModel extends ChangeNotifier {
  final BandRepository _repository = BandRepository();

  List<BandModel> _allBands = [];
  String _selectedGenre = 'Semua';

  MainViewModel() {
    refreshData();
  }

  // --- GETTERS ---

  List<BandModel> get allBands => _allBands;

  String get selectedGenre => _selectedGenre;

  // Mengambil data yang sudah difilter berdasarkan genre
  List<BandModel> get filteredBands {
    if (_selectedGenre == 'Semua') {
      return _allBands;
    }
    return _allBands.where((band) => band.genre == _selectedGenre).toList();
  }

  // --- LOGIKA BISNIS ---

  // Sinkronisasi data dari Repository
  void refreshData() {
    // Memanggil getAllBands sesuai dengan yang ada di Repository Anda
    _allBands = _repository.getAllBands();
    notifyListeners();
  }

  // Mengubah filter genre
  void setGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  // --- LOGIKA WISHLIST ---

  // Mengecek apakah band ada di wishlist
  bool isFavorite(BandModel band) {
    final wishlistKey = '${band.band} - ${band.genre} ${band.location}';
    return globalWishlistItems.contains(wishlistKey);
  }

  // Menambah atau menghapus dari wishlist
  void toggleWishlist(BandModel band) {
    final wishlistKey = '${band.band} - ${band.genre} ${band.location}';

    if (globalWishlistItems.contains(wishlistKey)) {
      removeFromWishlist(wishlistKey);
    } else {
      addToWishlist(wishlistKey);
    }

    // Memberitahu UI untuk update ikon bintang
    notifyListeners();
  }
}
