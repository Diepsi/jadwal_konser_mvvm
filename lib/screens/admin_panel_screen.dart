// lib/screens/admin_panel_screen.dart

import 'dart:io'; 
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Untuk proteksi Web
import 'package:image_picker/image_picker.dart'; 
import 'package:provider/provider.dart';
import '../globals.dart';
import '../UI/viewmodels/main_viewmodel.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _nameController = TextEditingController();
  final _genreController = TextEditingController();
  final _locationController = TextEditingController();
  final _dateController = TextEditingController();
  final _priceController = TextEditingController();
  
  File? _selectedImage;

  // Fungsi ambil gambar dengan proteksi kIsWeb
  Future<void> _pickImage(StateSetter setModalState) async {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih foto belum didukung di mode Web (Edge). Gunakan Emulator/HP.')),
      );
      return;
    }

    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
        setModalState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  void _handleAddNewBand(MainViewModel viewModel) {
    if (_nameController.text.isEmpty || _genreController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan Genre wajib diisi!'), backgroundColor: Colors.orange),
      );
      return;
    }

    addBandData({
      'band': _nameController.text,
      'genre': _genreController.text,
      'location': _locationController.text,
      'date': _dateController.text,
      'price': _priceController.text,
      'title': 'New Live Event',
      'main_photo': _selectedImage != null ? _selectedImage!.path : 'placeholder.jpg',
      'bio': 'Konser baru ditambahkan melalui Admin Panel.',
      'albums': [],
    });

    viewModel.refreshData();

    _nameController.clear();
    _genreController.clear();
    _locationController.clear();
    _dateController.clear();
    _priceController.clear();
    setState(() { _selectedImage = null; });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Konser Berhasil Ditambahkan!'), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A1F),
          appBar: AppBar(
            title: const Text('Admin Control Panel', style: TextStyle(fontWeight: FontWeight.bold)),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Column(
            children: [
              _buildStatHeader(viewModel),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Icon(Icons.layers_outlined, color: Color(0xFFF72585)),
                    SizedBox(width: 10),
                    Text('Kelola Daftar Konser', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: globalBandData.length,
                  itemBuilder: (context, index) {
                    final item = globalBandData[index];
                    return _buildBandCard(item, index, viewModel);
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _showAddBandSheet(context, viewModel),
            backgroundColor: const Color(0xFFF72585),
            icon: const Icon(Icons.add_a_photo_outlined),
            label: const Text('TAMBAH KONSER'),
          ),
        );
      },
    );
  }

  Widget _buildStatHeader(MainViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFF72585), Color(0xFF7209B7)]),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Data', style: TextStyle(color: Colors.white70, fontSize: 14)),
              Text('Live Concerts', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
            ],
          ),
          Text('${globalBandData.length}', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  Widget _buildBandCard(Map<String, dynamic> item, int index, MainViewModel viewModel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: const Color(0xFF1B1B3A), borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 50, height: 50,
            color: const Color(0xFF0A0A1F),
            child: _displayItemImage(item['main_photo']),
          ),
        ),
        title: Text(item['band'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        subtitle: Text('${item['genre']} • ${item['location']}', style: const TextStyle(color: Colors.white54)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_forever_rounded, color: Colors.redAccent),
          onPressed: () {
            removeBandData(index);
            viewModel.refreshData();
          },
        ),
      ),
    );
  }

  // Tampilan gambar dengan proteksi kIsWeb
  Widget _displayItemImage(String? path) {
    if (path == null || path == 'placeholder.jpg') return const Icon(Icons.music_note, color: Colors.pink);
    
    if (kIsWeb) {
      return const Icon(Icons.image, color: Colors.blue); // Ikon pengganti di Edge
    }

    if (path.contains('/') || path.contains('\\')) {
      return Image.file(File(path), fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image));
    }
    return Image.asset('assets/band_photos/$path', fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.broken_image));
  }

  void _showAddBandSheet(BuildContext context, MainViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1B1B3A),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 12),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(10))),
                
                // --- PICK FOTO ---
                GestureDetector(
                  onTap: () => _pickImage(setModalState),
                  child: Container(
                    width: double.infinity, height: 150,
                    decoration: BoxDecoration(color: const Color(0xFF0A0A1F), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white10)),
                    child: _selectedImage != null && !kIsWeb
                      ? ClipRRect(borderRadius: BorderRadius.circular(16), child: Image.file(_selectedImage!, fit: BoxFit.cover))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center, 
                          children: [
                            Icon(kIsWeb ? Icons.no_photography : Icons.add_a_photo, color: Colors.grey, size: 40), 
                            Text(kIsWeb ? "Foto tidak didukung di Web" : "Ketuk untuk Pilih Foto", style: const TextStyle(color: Colors.grey))
                          ]
                        ),
                  ),
                ),
                const SizedBox(height: 20),
                
                _buildTextField(_nameController, 'Nama Band', Icons.person_outline),
                _buildTextField(_genreController, 'Genre', Icons.category_outlined),
                _buildTextField(_locationController, 'Lokasi', Icons.map_outlined),
                _buildTextField(_dateController, 'Tanggal', Icons.event),
                _buildTextField(_priceController, 'Harga', Icons.money),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF72585), minimumSize: const Size(double.infinity, 56), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () => _handleAddNewBand(viewModel),
                  child: const Text('PUBLIKASIKAN SEKARANG', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label, labelStyle: const TextStyle(color: Colors.grey),
          prefixIcon: Icon(icon, color: const Color(0xFF4895EF)),
          filled: true, fillColor: const Color(0xFF0A0A1F),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        ),
      ),
    );
  }
}