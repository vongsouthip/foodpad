import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  var query = ''.obs;
  var results = [].obs;
  var isLoading = false.obs;

  void searchRecipes(String keyword) async {
    query.value = keyword.trim().toLowerCase();
    if (query.value.isEmpty) {
      results.clear();
      return;
    }

    isLoading.value = true;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .get();

      final filtered = snapshot.docs
          .map((doc) {
            final data = doc.data();
            data['docId'] = doc.id;
            return data;
          })
          .where((recipe) =>
              (recipe['title'] as String).toLowerCase().contains(query.value))
          .toList();

      results.value = filtered;
    } catch (e) {
      print('🔥 Search error: $e');
    }

    isLoading.value = false;
  }
}
