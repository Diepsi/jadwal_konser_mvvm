// lib/ui/viewmodels/main_viewmodel.dart

import 'package:flutter/material.dart';
import '../../data/models/band_model.dart';
import '../../data/repositories/band_repository.dart';
import '../../globals.dart'; 

class MainViewModel extends ChangeNotifier {
  final BandRepository _repository = BandRepository();

  List<BandModel> _allBands = [];
  String _selectedGenre = 'Semua';
  bool _isLoading = false;

  // --- STATE AUTENTIKASI ---
  // Pastikan variabel ini ada untuk mengatasi error 'undefined_getter'
  bool _isLoggedIn = false;
  bool _isAdminMode = false;

  MainViewModel() {
    refreshData();
  }

  // --- GETTERS ---
  List<BandModel> get allBands => _allBands;
  String get selectedGenre => _selectedGenre;
  bool get isLoading => _isLoading;
  
  // Getter yang dicari oleh main.dart
  bool get isLoggedIn => _isLoggedIn; 
  bool get isAdminMode => _isAdminMode;

  List<BandModel> get filteredBands {
    if (_selectedGenre == 'Semua') {
      return _allBands;
    }
    return _allBands.where((band) => band.genre == _selectedGenre).toList();
  }

  // --- LOGIKA AUTENTIKASI ---

  void loginAsUser() {
    _isLoggedIn = true;
    _isAdminMode = false;
    notifyListeners();
  }

  void loginAsAdmin() {
    _isLoggedIn = true;
    _isAdminMode = true;
    isAdmin = true; // Sinkronisasi ke variabel global lama jika diperlukan
    notifyListeners();
  }

  // Method logout yang dicari oleh ProfileWrapper di main.dart
  void logout() {
    _isLoggedIn = false;
    _isAdminMode = false;
    isAdmin = false;
    notifyListeners();
  }

  // --- LOGIKA BISNIS ---

  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Pastikan fungsi ini tersedia di globals.dart
      await loadBandDataFromStorage();
      await loadWishlist();
      _allBands = _repository.getAllBands();
    } catch (e) {
      debugPrint("Error refreshData pada ViewModel: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }

  // --- LOGIKA WISHLIST ---

  bool isFavorite(BandModel band) {
    final wishlistKey = '${band.band} - ${band.genre} ${band.location}';
    return globalWishlistItems.contains(wishlistKey);
  }

  void toggleWishlist(BandModel band) {
    final wishlistKey = '${band.band} - ${band.genre} ${band.location}';
    if (globalWishlistItems.contains(wishlistKey)) {
      removeFromWishlist(wishlistKey);
    } else {
      addToWishlist(wishlistKey);
    }
    notifyListeners();
  }
}