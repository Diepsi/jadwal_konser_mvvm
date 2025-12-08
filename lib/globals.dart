// lib/globals.dart

// List yang akan menyimpan nama band/konser yang di-wishlist
List<String> globalWishlistItems = [
  'Mangu - EDM Jakarta',
  'The Luminaries - Rock Bandung',
];

// Fungsi untuk menambahkan item ke wishlist
void addToWishlist(String item) {
  if (!globalWishlistItems.contains(item)) {
    globalWishlistItems.add(item);
  }
}

// Fungsi untuk menghapus item dari wishlist
void removeFromWishlist(String item) {
  globalWishlistItems.remove(item);
}

// Fungsi untuk menghapus semua item
void clearWishlist() {
  globalWishlistItems.clear();
}
