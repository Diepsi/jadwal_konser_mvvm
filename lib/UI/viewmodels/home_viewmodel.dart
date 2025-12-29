import 'package:flutter/material.dart';
import '../../data/models/band_model.dart';
import '../../data/repositories/band_repository.dart';

class HomeViewModel extends ChangeNotifier {
  final BandRepository _repository = BandRepository();

  List<BandModel> _allBands = [];
  String _selectedGenre = 'Semua';

  List<BandModel> get bands {
    if (_selectedGenre == 'Semua') return _allBands;
    return _allBands.where((b) => b.genre == _selectedGenre).toList();
  }

  String get selectedGenre => _selectedGenre;

  void loadBands() {
    _allBands = _repository.getAllBands();
    notifyListeners();
  }

  void setGenre(String genre) {
    _selectedGenre = genre;
    notifyListeners();
  }
}
