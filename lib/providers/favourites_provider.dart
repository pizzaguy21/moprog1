import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/course_model.dart';

class FavouritesProvider with ChangeNotifier {
  final List<Course> _favourites = [];
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Course> get favourites => _favourites;

  // Memuat data favorit dari Firebase berdasarkan userId
  Future<void> loadFavourites(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favourites')
          .get();

      _favourites.clear();
      for (var doc in snapshot.docs) {
        _favourites.add(Course(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          isFavourite: true,
        ));
      }
      notifyListeners();
    } catch (error) {
      print('Error loading favourites: $error');
    }
  }

  // Menyimpan atau menghapus favorit ke Firebase
  Future<void> toggleFavourite(String userId, Course course) async {
    try {
      final favouriteRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('favourites')
          .doc(course.id);

      if (_favourites.contains(course)) {
        // Remove from the local list
        _favourites.remove(course);

        // Remove from Firebase
        await favouriteRef.delete();
      } else {
        // Add to the local list
        _favourites.add(course);

        // Add to Firebase
        await favouriteRef.set({
          'title': course.title,
          'description': course.description,
        });
      }

      // Immediately notify listeners to update the UI
      notifyListeners();
    } catch (error) {
      print('Error toggling favourite: $error');
    }
  }
}