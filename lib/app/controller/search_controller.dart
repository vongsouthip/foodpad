import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var query = ''.obs;
  var results = [].obs;
  var isLoading = false.obs;
  var suggestions = [].obs;
  var recentSearches = <String>[].obs;

  final textController = TextEditingController();

  void searchRecipes(String keyword) async {
    final search = keyword.trim().toLowerCase();
    query.value = search;
    if (search.isEmpty) {
      results.clear();
      suggestions.clear();
      return;
    }

    isLoading.value = true;
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('recipes').get();
      final allRecipes =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['docId'] = doc.id;
            return data;
          }).toList();

      suggestions.value =
          allRecipes
              .where(
                (r) => (r['title'] as String).toLowerCase().startsWith(search),
              )
              .map((r) => r['title'] as String)
              .toSet()
              .toList();

      results.value =
          allRecipes
              .where(
                (r) => (r['title'] as String).toLowerCase().contains(search),
              )
              .toList();

      if (!recentSearches.contains(search)) {
        recentSearches.insert(0, search);
        if (recentSearches.length > 5) recentSearches.removeLast();
      }
    } catch (e) {
      print('🔥 Search error: $e');
    }
    isLoading.value = false;
  }

  void clearSearch() {
    textController.clear();
    query.value = '';
    results.clear();
    suggestions.clear();
  }
}
