import 'package:flutter/material.dart';
import 'profile_screen.dart'; // Import ProfileScreen jika belum
import 'search_screen.dart'; // Import SearchScreen
import 'favourites_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Daftar layar untuk BottomNavigationBar
  final List<Widget> _screens = [
    const HomeScreenContent(), // Layar utama Home
    const SearchScreen(), // Ganti dengan layar pencarian jika ada
    const FavouritesScreen(), // Ganti dengan layar favorit jika ada
    const ProfileScreen(), // Layar profil
  ];

  // Fungsi untuk mengubah layar berdasarkan pilihan BottomNavigationBar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex], // Menampilkan layar sesuai dengan index yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF4B61DD),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped, // Mengubah layar saat item BottomNavigationBar dipilih
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favourites'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// Konten HomeScreen Anda (seperti yang sudah ada)
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar belakang utama tetap putih
      body: Container(
        child: Column(
          children: [
            // Header Section with Blue Background
            Container(
              color: const Color(0xFF4B61DD), // Warna biru untuk header
              padding: const EdgeInsets.only(top: 45, bottom: 20, left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo dan ikon translate
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Polylingo',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white, // Teks putih
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.g_translate, color: Colors.white), // Ikon putih
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Greeting Section
                  const Text(
                    'Hi, There!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Teks putih
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Courses',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white, // Warna putih untuk kontras dengan latar belakang biru
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Body Content di bawah header
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Circular Icon Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(6, (index) => _buildCircleIcon()),
                    ),
                    const SizedBox(height: 30),

                    // Courses Section Header
                    const Text(
                      'Courses',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4B61DD), // Warna biru untuk teks
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Course Items
                    _buildCourseItem('Japanese', 'assets/japan_flag.png'),
                    const SizedBox(height: 10),
                    _buildCourseItem('English', 'assets/us_flag.png'),
                    const SizedBox(height: 10),
                    _buildCourseItem('Spanish', 'assets/spain_flag.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build circular icons for the icon section
  Widget _buildCircleIcon() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Warna ikon lebih terang untuk kontras dengan latar belakang putih
        shape: BoxShape.circle,
      ),
    );
  }

  // Helper method to build course items with flags and language names
  Widget _buildCourseItem(String language, String flagPath) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[200], // Warna lebih terang untuk kontras dengan latar belakang putih
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(flagPath),
          ),
          const SizedBox(width: 15),
          Text(
            language,
            style: const TextStyle(
              fontSize: 18,
              color: Color(0xFF4B61DD), // Warna teks biru
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
