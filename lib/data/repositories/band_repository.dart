// lib/data/repositories/band_repository.dart

import '../../globals.dart';
import '../models/band_model.dart';

class BandRepository {
  // PERBAIKAN: Menghapus field _service karena tidak lagi digunakan (unused_field)
  // Data sekarang diambil langsung dari globals.dart untuk reaktivitas admin.

  /// MENGAMBIL SEMUA DATA BAND
  /// Mengambil langsung dari globalBandData agar perubahan dari Admin 
  /// (Tambah/Hapus) langsung terdeteksi oleh ViewModel.
  List<BandModel> getAllBands() {
    return globalBandData.map((map) => BandModel.fromMap(map)).toList();
  }

  /// FUNGSI UNTUK MENAMBAH DATA BAND BARU
  /// Mengonversi objek BandModel kembali ke Map untuk disimpan di globals
  void addNewBand(BandModel band) {
    addBandData({
      'band': band.band,
      'genre': band.genre,
      // PERBAIKAN: Menghapus ?? '' karena properti band.title didefinisikan 
      // sebagai non-nullable di model (dead_null_aware_expression)
      'title': band.title,
      'date': band.date,
      'price': band.price,
      'location': band.location,
      'main_photo': band.mainPhoto,
      'bio': band.bio,
      // PERBAIKAN: Menghapus ?? [] karena band.albums sudah pasti List (bukan null)
      'albums': band.albums,
    });
  }

  /// FUNGSI UNTUK MENGHAPUS DATA BAND
  /// Terhubung ke fungsi removeBandData di globals.dart
  void deleteBand(int index) {
    removeBandData(index);
  }
}