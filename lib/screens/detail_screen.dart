// lib/screens/detail_screen.dart

import 'package:flutter/material.dart';
import '../globals.dart';

class DetailScreen extends StatefulWidget {
  final Map<String, String> concertData;

  const DetailScreen({super.key, required this.concertData});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  // Helper untuk gambar (sama dengan di main.dart)
  ImageProvider _getImageProvider(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const AssetImage('assets/images/placeholder.jpg'); //
    }
    if (imagePath.startsWith('http')) {
      return NetworkImage(imagePath); //
    } else {
      // Jika bukan link, anggap aset lokal di folder band_photos
      return AssetImage('assets/band_photos/$imagePath'); //
    }
  }

  // Fungsi refresh lokal untuk detail
  void _handleRefresh() {
    setState(() {}); // Memicu pembangunan ulang widget untuk memperbarui data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Detail Diperbarui'),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFF4895EF),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Mencari data tambahan (seperti album) dari globals berdasarkan nama band
    final fullData = globalBandData.firstWhere(
      (element) => element['band'] == widget.concertData['artist'],
      orElse: () => {},
    );

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1F), //
      body: CustomScrollView(
        slivers: [
          // Header dengan Foto yang bisa mengecil (Parallax)
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            // --- TOMBOL BACK ---
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.5),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context), // Kembali ke halaman sebelumnya
                ),
              ),
            ),
            // --- TOMBOL REFRESH ---
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.black.withOpacity(0.5),
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white),
                    onPressed: _handleRefresh, // Memanggil fungsi refresh
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.concertData['artist'] ?? '', //
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [Shadow(blurRadius: 10, color: Colors.black)],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: _getImageProvider(widget.concertData['image']), //
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0xFF0A0A1F)], //
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Row Info Utama (Harga, Lokasi, Tanggal)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildInfoTile(Icons.confirmation_number_outlined, "Harga", widget.concertData['price'] ?? 'TBA'),
                      _buildInfoTile(Icons.location_on_outlined, "Lokasi", widget.concertData['location'] ?? 'TBA'),
                      _buildInfoTile(Icons.calendar_month_outlined, "Tanggal", widget.concertData['date'] ?? '-'),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Tentang Band
                  const Text(
                    "Tentang Band",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.concertData['description'] ?? 'Tidak ada deskripsi.', //
                    style: TextStyle(color: Colors.grey.shade400, height: 1.5, fontSize: 15),
                  ),
                  const SizedBox(height: 30),

                  // Section Album (Jika ada di globalBandData)
                  if (fullData['albums'] != null && (fullData['albums'] as List).isNotEmpty) ...[
                    const Text(
                      "Album Populer",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: (fullData['albums'] as List).length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: 110,
                            margin: const EdgeInsets.only(right: 15),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1B1B3A), //
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.album, color: Color(0xFFF72585), size: 40), //
                                const SizedBox(height: 8),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                    fullData['albums'][index], //
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 11, color: Colors.white),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 120), // Memberi ruang agar tidak tertutup button bottomSheet
                ],
              ),
            ),
          ),
        ],
      ),
      // Tombol Beli Tiket
      bottomSheet: Container(
        color: const Color(0xFF0A0A1F), //
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: ElevatedButton(
          onPressed: () {
            // Logika pembelian tiket bisa ditambahkan di sini
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFF72585), //
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 55),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 8,
          ),
          child: const Text(
            "BELI TIKET SEKARANG",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF4895EF), size: 28), //
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          value, 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)
        ),
      ],
    );
  }
}