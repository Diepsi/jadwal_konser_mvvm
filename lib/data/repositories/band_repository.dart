// lib/data/repositories/band_repository.dart
import '../../globals.dart';
import '../models/band_model.dart';
import '../services/band_service.dart';

class BandRepository {
  final BandService _service = BandService();

  // Mengambil semua data band dan mengubahnya menjadi List<BandModel>
  List<BandModel> getAllBands() {
    final rawData = _service.fetchRawBands();
    return rawData.map((map) => BandModel.fromMap(map)).toList();
  }

  // Fungsi untuk menambah data band baru ke globals
  void addNewBand(BandModel band) {
    addBandData({
      'band': band.band,
      'genre': band.genre,
      'title': band.title,
      'date': band.date,
      'price': band.price,
      'location': band.location,
      'main_photo': band.mainPhoto,
      'bio': band.bio,
      'albums': band.albums,
    });
  }
}
