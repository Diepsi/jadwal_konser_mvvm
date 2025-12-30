// lib/data/repositories/band_repository.dart

import '../../globals.dart';
import '../models/band_model.dart';
import '../services/band_service.dart';

class BandRepository {
  final BandService _service = BandService();

  /// MENGAMBIL SEMUA DATA BAND
  /// Perbaikan: Mengambil langsung dari globalBandData agar perubahan dari Admin 
  /// (Tambah/Hapus) langsung terdeteksi oleh ViewModel.
  List<BandModel> getAllBands() {
    // Pastikan menggunakan globalBandData dari globals.dart
    return globalBandData.map((map) => BandModel.fromMap(map)).toList();
  }

  /// FUNGSI UNTUK MENAMBAH DATA BAND BARU
  /// Mengonversi objek BandModel kembali ke Map untuk disimpan di globals
  void addNewBand(BandModel band) {
    addBandData({
      'band': band.band,
      'genre': band.genre,
      'title': band.title ?? '',
      'date': band.date,
      'price': band.price,
      'location': band.location,
      'main_photo': band.mainPhoto,
      'bio': band.bio,
      'albums': band.albums ?? [],
    });
  }

  /// FUNGSI UNTUK MENGHAPUS DATA BAND
  /// Terhubung ke fungsi removeBandData di globals.dart
  void deleteBand(int index) {
    removeBandData(index);
  }
}