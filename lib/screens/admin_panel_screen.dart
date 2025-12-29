// lib/screens/admin_panel_screen.dart

import 'package:flutter/material.dart';
import '../globals.dart'; // Import globalBandData & functions

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  final _formKey = GlobalKey<FormState>();

  // Variabel Form
  String _bandName = '';
  String _genre = 'Rock';
  String _price = '';
  String _location = '';
  String _bio = '';
  String _mainPhoto = '';

  final List<String> genres = ['Rock', 'Pop', 'K-Pop', 'Metal', 'R&B', 'Indie', 'Reggae', 'Punk'];

  void _submitBand() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newBand = {
        'band': _bandName,
        'genre': _genre,
        'date': 'Baru Saja',
        'price': _price,
        'location': _location,
        'bio': _bio,
        'main_photo': _mainPhoto.isEmpty ? 'placeholder.jpg' : _mainPhoto,
        'albums': [],
      };

      setState(() {
        addBandData(newBand); // Menambah ke list global
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil menambahkan konser!'), backgroundColor: Colors.green),
      );
      
      _formKey.currentState!.reset();
      DefaultTabController.of(context).animateTo(0); // Pindah ke tab daftar
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Daftar Konser'),
              Tab(icon: Icon(Icons.add), text: 'Tambah Baru'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildListTab(),
            _buildFormTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildListTab() {
    return ListView.builder(
      itemCount: globalBandData.length,
      itemBuilder: (context, index) {
        final band = globalBandData[index];
        return ListTile(
          title: Text(band['band'] ?? ''),
          subtitle: Text(band['location'] ?? ''),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () {
              setState(() {
                removeBandData(index); // Menghapus dari list global
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildFormTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Band'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
              onSaved: (v) => _bandName = v!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Harga (Contoh: Rp 500.000)'),
              onSaved: (v) => _price = v!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Lokasi'),
              onSaved: (v) => _location = v!,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(labelText: 'URL Foto atau Nama File'),
              onSaved: (v) => _mainPhoto = v!,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitBand,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green, minimumSize: const Size(double.infinity, 50)),
              child: const Text('SIMPAN KONSER', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}