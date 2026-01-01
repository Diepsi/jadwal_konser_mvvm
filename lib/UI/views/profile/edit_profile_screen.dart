import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/main_viewmodel.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _nameController;
  String _selectedGenre = 'Rock';

  final List<String> genres = [
    'Rock',
    'Pop',
    'Jazz',
    'Hip Hop',
    'Electronic',
    'Indie',
  ];

  @override
  void initState() {
    super.initState();
    final vm = context.read<MainViewModel>();
    _nameController = TextEditingController(text: vm.userName);
    _selectedGenre = vm.favoriteGenre;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nama'),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            const Text('Genre Musik Favorit'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedGenre,
              items: genres
                  .map(
                    (g) => DropdownMenuItem(
                      value: g,
                      child: Text(g),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedGenre = value!);
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await context.read<MainViewModel>().updateUserProfile(
                        name: _nameController.text,
                        genre: _selectedGenre,
                      );
                  Navigator.pop(context);
                },
                child: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
