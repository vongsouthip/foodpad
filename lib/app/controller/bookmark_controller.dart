import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BookmarkController extends GetxController {
  var bookmarkedRecipes = [].obs;
  var isLoading = false.obs;

  final uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    fetchBookmarkedRecipes();
  }

  void fetchBookmarkedRecipes() async {
    isLoading.value = true;
    if (uid == null) return;

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('recipes')
          .where('bookmarkedBy', arrayContains: uid)
          .orderBy('createdAt', descending: true)
          .get();

      bookmarkedRecipes.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['docId'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("🔥 Error fetching bookmarks: $e");
    }

    isLoading.value = false;
  }

  Future<void> removeBookmark(String docId) async {
    if (uid == null || docId.isEmpty) return;

    try {
      final ref = FirebaseFirestore.instance.collection('recipes').doc(docId);
      await ref.update({
        'bookmarkedBy': FieldValue.arrayRemove([uid])
      });

      bookmarkedRecipes.removeWhere((item) => item['docId'] == docId);
    } catch (e) {
      print("🔥 Error removing bookmark: $e");
    }
  }
}
