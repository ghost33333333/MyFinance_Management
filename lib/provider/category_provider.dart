import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CategoryProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<String> _categories = [];

  List<String> get categories => _categories;

  CategoryProvider() {
    _listenToCategories();
  }

  // Stream to listen to user-specific categories in real-time
  Stream<List<String>> get categoriesStream {
    final user = _auth.currentUser;
    if (user == null) {
      return const Stream.empty();
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  // Fetch categories initially and update on changes
  void _listenToCategories() {
    categoriesStream.listen((data) {
      _categories = data;
      notifyListeners();
    }, onError: (error) {
      debugPrint("Error fetching categories: $error");
    });
  }

  // Add a new category for the current user
  Future<void> addCategory(String category) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("No authenticated user found.");
      return;
    }
    if (category.isNotEmpty && !_categories.contains(category)) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('categories')
            .add({'name': category});
        // No need to manually update _categories; the stream will handle it
      } catch (error) {
        debugPrint("Error adding category: $error");
      }
    }
  }

  // Edit an existing category for the current user
  Future<void> editCategory(String oldCategory, String newCategory) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("No authenticated user found.");
      return;
    }
    if (newCategory.isNotEmpty &&
        oldCategory != newCategory &&
        !_categories.contains(newCategory)) {
      try {
        QuerySnapshot snapshot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('categories')
            .where('name', isEqualTo: oldCategory)
            .get();

        if (snapshot.docs.isNotEmpty) {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('categories')
              .doc(snapshot.docs.first.id)
              .update({'name': newCategory});
          // Stream will update _categories automatically
        }
      } catch (error) {
        debugPrint("Error editing category: $error");
      }
    }
  }

  // Delete a category for the current user
  Future<void> deleteCategory(String category) async {
    final user = _auth.currentUser;
    if (user == null) {
      debugPrint("No authenticated user found.");
      return;
    }
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('categories')
          .where('name', isEqualTo: category)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('categories')
            .doc(snapshot.docs.first.id)
            .delete();
        // Stream will update _categories automatically
      }
    } catch (error) {
      debugPrint("Error deleting category: $error");
    }
  }
}
