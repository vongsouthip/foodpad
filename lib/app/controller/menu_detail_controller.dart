import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MenuDetailController extends GetxController {
  var isLoading = true.obs;
  var recipeData = <String, dynamic>{}.obs;
  var isLiked = false.obs;
  var isBookmarked = false.obs;

  String get uid => FirebaseAuth.instance.currentUser?.uid ?? '';

  void fetchRecipe(String docId) async {
    isLoading.value = true;
    try {
      final doc =
          await FirebaseFirestore.instance
              .collection('recipes')
              .doc(docId)
              .get();
      if (doc.exists) {
        recipeData.value = doc.data()!;
        isLiked.value = List<String>.from(
          recipeData['likes'] ?? [],
        ).contains(uid);
        isBookmarked.value = List<String>.from(
          recipeData['bookmarkedBy'] ?? [],
        ).contains(uid);
      }
    } catch (e) {
      print("🔥 Error fetching recipe: $e");
    }
    isLoading.value = false;
  }

  Future<void> toggleLike(String docId) async {
    final docRef = FirebaseFirestore.instance.collection('recipes').doc(docId);
    final currentLikes = List<String>.from(recipeData['likes'] ?? []);

    if (isLiked.value) {
      currentLikes.remove(uid);
    } else {
      currentLikes.add(uid);
    }

    await docRef.update({'likes': currentLikes});
    recipeData['likes'] = currentLikes;
    isLiked.toggle();
  }

  Future<void> toggleBookmark(String docId) async {
    final docRef = FirebaseFirestore.instance.collection('recipes').doc(docId);
    final currentBookmarks = List<String>.from(
      recipeData['bookmarkedBy'] ?? [],
    );

    if (isBookmarked.value) {
      currentBookmarks.remove(uid);
    } else {
      currentBookmarks.add(uid);
    }

    await docRef.update({'bookmarkedBy': currentBookmarks});
    recipeData['bookmarkedBy'] = currentBookmarks;
    isBookmarked.toggle();
  }
}
