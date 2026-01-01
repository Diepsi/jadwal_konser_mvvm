import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/band_model.dart';
import '../../data/repositories/band_repository.dart';
import '../../globals.dart';

class MainViewModel extends ChangeNotifier {
  final BandRepository _repository = BandRepository();

  // =======================
  // DATA BAND & FILTER
  // =======================
  List<BandModel> _allBands = [];
  String _selectedGenre = 'Semua';
  bool _isLoading = false;

  // =======================
  // AUTH STATE
  // =======================
  bool _isLoggedIn = false;
  bool _isAdminMode = false;

  // =======================
  // USER PROFILE (BARU)
  // =======================
  String _userName = 'User';
  String _favoriteGenre = 'Rock';

  MainViewModel() {
    refreshData();
  }

  // =======================
  // GETTERS
  // =======================
  List<BandModel> get allBands => _allBands;
  String get selectedGenre => _selectedGenre;
  bool get isLoading => _isLoading;

  bool get isLoggedIn => _isLoggedIn;
  bool get isAdminMode => _isAdminMode;

  String get userName => _userName;
  String get favoriteGenre => _favoriteGenre;

  List<BandModel> get filteredBands {
    if (_selectedGenre == 'Semua') {
      return _allBands;
    }
    return _allBands.where((band) => band.genre == _selectedGenre).toList();
  }

  // =======================
  // AUTH LOGIC
  // =======================
  void loginAsGuest() async {
    _isLoggedIn = true;
    _isAdminMode = false;
    isAdmin = false;
    await loadUserProfile(); // load profil user
    notifyListeners();
  }

  void loginAsUser() => loginAsGuest();

  void loginAsAdmin() async {
    _isLoggedIn = true;
    _isAdminMode = true;
    isAdmin = true;
    await loadUserProfile();
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _isAdminMode = false;
    isAdmin = false;
    notifyListeners();
  }

  // =======================
  // DATA & BUSINESS LOGIC
  // =======================
  Future<void> refreshData() async {
    _isLoading = true;
    notifyListeners();

    try {
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

  // =======================
  // WISHLIST LOGIC
  // =======================
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

  int get wishlistCount => globalWishlistItems.length;

  // =======================
  // USER PROFILE LOGIC (BARU)
  // =======================
  Future<void> loadUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _userName = prefs.getString('user_name') ?? 'User';
    _favoriteGenre = prefs.getString('favorite_genre') ?? 'Rock';
    notifyListeners();
  }

  Future<void> updateUserProfile({
    required String name,
    required String genre,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('favorite_genre', genre);

    _userName = name;
    _favoriteGenre = genre;
    notifyListeners();
  }
}
