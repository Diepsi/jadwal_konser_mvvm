// lib/data/services/band_service.dart
import '../../globals.dart';

class BandService {
  // Mengambil data list mentah dari globals
  List<Map<String, dynamic>> fetchRawBands() {
    return globalBandData;
  }
}
