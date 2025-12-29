class BandModel {
  final String band;
  final String genre;
  final String title;
  final String date;
  final String price;
  final String location;
  final String mainPhoto;
  final String bio;
  final List<dynamic> albums;

  BandModel({
    required this.band,
    required this.genre,
    required this.title,
    required this.date,
    required this.price,
    required this.location,
    required this.mainPhoto,
    required this.bio,
    required this.albums,
  });

  factory BandModel.fromMap(Map<String, dynamic> map) {
    return BandModel(
      band: map['band'] ?? 'Unknown',
      genre: map['genre'] ?? 'Music',
      title: map['title'] ?? '',
      date: map['date'] ?? '-',
      price: map['price'] ?? 'TBA',
      location: map['location'] ?? 'TBA',
      mainPhoto: map['main_photo'] ?? '',
      bio: map['bio'] ?? 'Tidak ada deskripsi',
      albums: map['albums'] ?? [],
    );
  }
}
