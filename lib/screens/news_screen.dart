import 'package:flutter/material.dart';
import 'band_detail_screen.dart'; // Import layar BandDetailScreen

// Daftar band yang disaring (Metal, Rock, R&B, Pop, K-Pop, Indie, Reggae, Punk)
const List<Map<String, dynamic>> bandData = [
  // ROCK
  {
    'band': 'The S.I.G.I.T',
    'genre': 'Rock',
    'title': 'The S.I.G.I.T Umumkan Tur Asia Pasifik',
    'date': '01 Nov 2025',
    'excerpt':
        'Band rock asal Bandung ini siap menggebrak panggung internasional.',
    'bio':
        'The S.I.G.I.T (The Super Insurgent Group of Intemperance Talent) adalah band rock beraliran garage/blues.',
    'main_photo': 'sigit_visible.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'All The Time',
        'cover': 'sigitt_visible.jpg',
        'url':
            'https://open.spotify.com/track/60zomg1pGnaSrapCzO6aPG?si=ca5316fa2f794ed0',
      }, // FOTO ALBUM
      {
        'title': 'Owl and Golf',
        'cover': 'sigit_hertz.jpg',
        'url':
            'https://open.spotify.com/track/2nk7JyNBMEXYhtESEpXwai?si=dc73bede66ad4ec8',
      },
    ],
  },
  {
    'band': 'Dewa 19',
    'genre': 'Rock',
    'title': 'Dewa 19 Gelar Konser Spesial di JIS dengan 4 Vokalis',
    'date': '15 Okt 2025',
    'excerpt':
        'Konser ini akan menampilkan semua vokalis legendaris yang pernah bergabung.',
    'bio':
        'Dewa 19 adalah salah satu band rock dan pop paling berpengaruh di Indonesia. Dibentuk di Surabaya, band ini dikenal karena komposisi musiknya yang kaya dan lirik puitis.',
    'main_photo': 'dewa_bintang.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Separuh Napas',
        'cover': 'dewa_bisntang.jpg',
        'url':
            'https://open.spotify.com/track/5n8AhbDbbkH5uRwDvumE72?si=6d15d897040f4e52',
      },
      {
        'title': 'Kangen',
        'cover': 'dewa_pandawa.jpg',
        'url':
            'https://open.spotify.com/track/6VggIDYOnf9C8fJVcMpxAu?si=e90fab585bf5414c',
      },
    ],
  },

  // POP & K-POP
  {
    'band': 'Pop Sensation X',
    'genre': 'Pop',
    'title': 'Video Musik Terbaru PSX Pecahkan Rekor Penonton!',
    'date': '01 Nov 2025',
    'excerpt':
        'Hanya dalam 24 jam, video klip "Neon Dreams" telah ditonton lebih dari 50 juta kali...',
    'bio':
        'Pop Sensation X (PSX) adalah grup pop idola global yang mendominasi tangga lagu dengan lagu-lagu catchy. Mereka dikenal karena koreografi yang rumit dan gaya fesyen yang inovatif.',
    'albums': [
      {'title': 'Neon Dreams (2025)', 'cover': 'psx_neon.jpg'},
      {'title': 'Global Takeover (2024)', 'cover': 'psx_global.jpg'},
    ],
  },
  {
    'band': 'StarLight 5',
    'genre': 'K-Pop',
    'title': 'StarLight 5 Umumkan Kolaborasi dengan Produser Amerika',
    'date': '25 Jan 2026',
    'excerpt': 'Kolaborasi ini diharapkan mendobrak pasar musik Barat.',
    'bio':
        'Girlband K-Pop yang fokus pada konsep ceria dan lagu-lagu yang membangkitkan semangat.',
    'albums': [
      {'title': 'Summer Magic (2024)', 'cover': 'sl5_summer.jpg'},
      {'title': 'Shine Bright (2022)', 'cover': 'sl5_shine.jpg'},
    ],
  },

  // R&B
  {
    'band': 'Elephant Kind',
    'genre': 'R&B',
    'title':
        'Elephant Kind Rilis Album "The Greatest Ever" dengan Sentuhan R&B Baru',
    'date': '10 Des 2025',
    'excerpt': 'Trio ini memadukan R&B, pop, dan sedikit jazz.',
    'bio':
        'Band indie pop/R&B asal Jakarta yang dikenal dengan lirik berbahasa Inggris yang mendalam dan produksi musik yang halus.',
    'main_photo': 'ek_circus.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Better Days',
        'cover': 'ek_greatest.jpg',
        'url':
            'https://open.spotify.com/track/0P5b1NOiH7ptjklmz9cdio?si=0d35a098790c45bd',
      },
      {
        'title': 'I believe In You',
        'cover': 'ek_circuss.jpg',
        'url':
            'https://open.spotify.com/track/6Bdi5dVkMxXUSqvWzDGgTV?si=9d1e4e6946be40da',
      },
    ],
  },
  {
    'band': 'Gamaliél Audrey Cantika',
    'genre': 'R&B',
    'title': 'GAC Kembali Reuni dengan Single Balada Manis',
    'date': '01 Feb 2026',
    'excerpt': 'Trio vokal ini kembali dengan harmoni R&B khas mereka.',
    'bio':
        'Trio vokal R&B-pop yang terkenal karena harmoni yang luar biasa dan interpretasi lagu yang kuat.',
    'main_photo': 'gac_stronger.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Berlari Tanpa Kaki',
        'cover': 'gac_gac.jpg',
        'url':
            'https://open.spotify.com/track/70iyP9x2e2vx2XYiCU7OQW?si=487bcd349c06437b',
      },
      {
        'title': 'Bahagia',
        'cover': 'gaac_stronger.jpg',
        'url':
            'https://open.spotify.com/track/31swUEisRXt0oEz3iM6MOy?si=1bf2b70f9b494f32',
      },
    ],
  },

  // INDIE
  {
    'band': 'Efek Rumah Kaca',
    'genre': 'Indie',
    'title': 'ERK Gelar Konser Perdana Pasca Pandemi di Jakarta',
    'date': '05 Des 2025',
    'excerpt':
        'Band ini membawakan lagu-lagu dari album terbaru mereka, Sinestesia.',
    'bio':
        'Band indie rock dari Jakarta yang dikenal karena liriknya yang filosofis dan kritis terhadap isu sosial.',
    'main_photo': 'erk_kamar.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Sebelah Mata',
        'cover': 'erk_sinestesia.jpg',
        'url':
            'https://open.spotify.com/track/3M0RfjqAJZ1f6qXJkP1Uej?si=c82f4ec5459a4297',
      },
      {
        'title': 'Balerina',
        'cover': 'erk_kamaar.jpg',
        'url':
            'https://open.spotify.com/track/04Opv95YdaTL2OU4tooVyQ?si=d46b2b29745e449c',
      },
    ],
  },
  {
    'band': 'Reality Club',
    'genre': 'Indie',
    'title': 'Reality Club Menggebrak Pasar Asia dengan Album Baru',
    'date': '19 Des 2025',
    'excerpt': 'Album baru mereka memenangkan nominasi Album of the Year.',
    'bio':
        'Band indie rock yang kental dengan nuansa pop rock 90-an dan lirik yang bercerita tentang kisah cinta modern.',
    'main_photo': 'rc_never.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Anything You Want',
        'cover': 'rc_know.jpg',
        'url':
            'https://open.spotify.com/track/2QB8FwOszur18Ai7t2XnNi?si=054d1349b1284d93',
      },
      {
        'title': '2112',
        'cover': 'rc_nesver.jpg',
        'url':
            'https://open.spotify.com/track/5Gxwk3TSekI4GVMpFvPBEc?si=c2667c71290e40ac',
      },
    ],
  },

  // REGGAE
  {
    'band': 'Dhyo Haw',
    'genre': 'Reggae',
    'title': 'Dhyo Haw Merilis Album Akustik Eksklusif di Bali',
    'date': '15 Jan 2026',
    'excerpt': 'Album ini penuh dengan getaran pantai yang menenangkan.',
    'bio':
        'Penyanyi reggae solo yang populer dengan lagu-lagu bernuansa santai, damai, dan penuh semangat positif.',
    'main_photo': 'dh_positive.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Ada Aku Disini',
        'cover': 'dh_disini.jpg',
        'url':
            'https://open.spotify.com/track/6uG9abKGpUTs0435EWd3d5?si=49f2c75e73ac43a2',
      },
      {
        'title': 'Sekeras Batu',
        'cover': 'dh_posisstive.jpg',
        'url':
            'https://open.spotify.com/track/75YGH57QJ9T6IVwnJ1qtqa?si=dac64f9f5c184006',
      },
    ],
  },

  // PUNK
  {
    'band': 'Rocket Rockers',
    'genre': 'Punk',
    'title': 'Rocket Rockers Pimpin Festival Musik Punk di Bandung',
    'date': '10 Feb 2026',
    'excerpt':
        'Band ini menampilkan set list yang padat dari era awal hingga kini.',
    'bio':
        'Band pop-punk/punk rock asal Bandung yang telah menjadi ikon subkultur remaja sejak awal 2000-an.',
    'main_photo': 'rr_cheers.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Ingin Hilang Ingatan',
        'cover': 'rr_better.jpg',
        'url':
            'https://open.spotify.com/track/2m4F1e8aNRPkTUUzgETnvU?si=2dcb030e29624930',
      },
      {
        'title': 'Dia',
        'cover': 'rr_cheeres.jpg',
        'url':
            'https://open.spotify.com/track/0z7pODXwd9kc8FpgQi6N0y?si=21a57a95cf6e477f',
      },
    ],
  },

  // METAL
  {
    'band': 'DeadSquad',
    'genre': 'Metal',
    'title': 'DeadSquad Umumkan Album Baru dengan Konsep Gore yang Lebih Gelap',
    'date': '20 Feb 2026',
    'excerpt':
        'Album ini menampilkan kolaborasi dengan gitaris metal internasional.',
    'bio':
        'Band technical death metal dari Jakarta yang dikenal dengan teknik gitar yang rumit dan struktur lagu yang agresif.',
    'main_photo': 'ds_tyranation.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Manufaktur Replika Baptis',
        'cover': 'ds_profanatik.jpg',
        'url':
            'https://open.spotify.com/track/0ur7RJ4dYfF4WBreJLZLoA?si=139dd19523124559',
      },
      {
        'title': 'IL SOGNO feat Isyana Sarasvati',
        'cover': 'ds_tyranatzion.jpg',
        'url':
            'https://open.spotify.com/track/2NYkIrz2FYU6KvTUOajlQh?si=f476e2fbe50840ec',
      },
    ],
  },
  {
    'band': 'Burgerkill',
    'genre': 'Metal',
    'title': 'Burgerkill Peringati 25 Tahun Karir dengan Konser Tunggal Akbar',
    'date': '05 Mar 2026',
    'excerpt': 'Konser ini akan menjadi tribut untuk mendiang personel mereka.',
    'bio':
        'Band metalcore legendaris dari Bandung. Dikenal karena energi panggung yang masif dan lirik yang mengangkat isu personal dan sosial.',
    'main_photo': 'bk_venomous.jpg', // FOTO UTAMA BAND
    'albums': [
      {
        'title': 'Tiga Titik Hitam',
        'cover': 'bk_beyond.jpg',
        'url':
            'https://open.spotify.com/track/7Fi3EyFExj8iIumylN29ne?si=3f36c6732fd9458a',
      },
      {
        'title': 'En Elgy',
        'cover': 'bk_venomsous.jpg',
        'url':
            'https://open.spotify.com/track/3pLIT3iAnEBCaDYZsCqOM9?si=43ee2cc1526e4755',
      },
    ],
  },
];

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  // Fungsi untuk mendapatkan warna aksen berdasarkan genre
  Color _getGenreColor(String genre) {
    switch (genre) {
      case 'Metal':
        return const Color(0xFF9E9E9E);
      case 'Rock':
        return const Color(0xFFFF5252);
      case 'R&B':
        return const Color(0xFF4CAF50);
      case 'Pop':
      case 'K-Pop':
        return const Color(0xFF40C4FF);
      case 'Indie':
        return const Color(0xFF7C4DFF);
      case 'Reggae':
        return const Color(0xFFFFC107);
      case 'Punk':
        return const Color(0xFFE91E63);
      default:
        return Colors.white;
    }
  }

  // Fungsi navigasi ke Band Detail Screen
  void _navigateToBandDetail(BuildContext context, Map<String, dynamic> data) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BandDetailScreen(bandData: data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Berita Band & Gig'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: ListView.separated(
        itemCount: bandData.length,
        padding: const EdgeInsets.all(16),
        separatorBuilder: (context, index) =>
            const Divider(color: Color(0xFF333355), height: 20),
        itemBuilder: (context, index) {
          final news = bandData[index];
          final bandColor = _getGenreColor(news['genre']!);

          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: bandColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: bandColor, width: 1.5),
              ),
              alignment: Alignment.center,
              child: Icon(Icons.article, color: bandColor),
            ),
            title: Text(
              news['title']!,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            subtitle: Text(
              '${news['band']} - ${news['date']}',
              style: TextStyle(color: Colors.grey.shade400),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () => _navigateToBandDetail(context, news),
          );
        },
      ),
    );
  }
}
