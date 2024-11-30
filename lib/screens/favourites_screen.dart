import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/favourites_provider.dart';
import '../models/course_model.dart';

class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  List<Course> _filteredFavourites = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId != null) {
        // Load favourites from Firebase based on userId
        await Provider.of<FavouritesProvider>(context, listen: false)
            .loadFavourites(userId);
      }

      // Check if the widget is still mounted before calling setState
      if (mounted) {
        setState(() {
          _isLoading = false; // Loading is complete
          _filteredFavourites = Provider.of<FavouritesProvider>(context, listen: false).favourites;
        });
      }
    });

    // Add listener to search field for dynamic search
    _searchController.addListener(() {
      _filterFavourites();
    });
  }

  // Filter favourites based on the search query
  void _filterFavourites() {
    final favourites = Provider.of<FavouritesProvider>(context, listen: false).favourites;
    setState(() {
      _filteredFavourites = favourites.where((course) {
        return course.title.toLowerCase().startsWith(_searchController.text.toLowerCase());
      }).toList();
    });
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                // Header with the color blue
                Container(
                  color: const Color(0xFF4B61DD),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 45),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header top (Polylingo and Translate Icon)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Polylingo',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.g_translate, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Favourites Title
                      const Text(
                        'Favourites',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Search Bar
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search here...',
                          hintStyle: const TextStyle(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Favourites List
                Expanded(
                  child: _filteredFavourites.isEmpty
                      ? Center(
                          child: Text(
                            'No favourites found!',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ListView.builder(
                            itemCount: _filteredFavourites.length, // Count the filtered list
                            itemBuilder: (context, index) {
                              final Course course = _filteredFavourites[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 15),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD6E0FF),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.book, size: 50, color: Colors.grey),
                                    const SizedBox(width: 8), // Give some space
                                    Expanded( // Make sure only text needs flexibility
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            course.title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            course.description,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Delete button
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () {
                                        final userId = FirebaseAuth.instance.currentUser?.uid;
                                        if (userId != null) {
                                          Provider.of<FavouritesProvider>(context, listen: false)
                                              .toggleFavourite(userId, course); // Deletes the course
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}