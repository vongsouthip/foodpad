import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class BookmarkController extends GetxController {
  var bookmarkedRecipes = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  StreamSubscription? _subscription;

  @override
  void onInit() {
    super.onInit();
    listenToBookmarks();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    bookmarkedRecipes.clear(); // 🧹 เคลียร์ข้อมูลเก่า
    super.onClose();
  }

  void listenToBookmarks() {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      isLoading.value = false;
      return;
    }

    _subscription = FirebaseFirestore.instance
        .collection('recipes')
        .where('bookmarkedBy', arrayContains: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
          (snapshot) {
            bookmarkedRecipes.value =
                snapshot.docs.map((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  data['docId'] = doc.id;
                  return data;
                }).toList();
            isLoading.value = false;
          },
          onError: (error) {
            print('🔥 Firestore listen error: $error');
            isLoading.value = false;
          },
        );
  }

  Future<void> removeBookmark(String docId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    try {
      final ref = FirebaseFirestore.instance.collection('recipes').doc(docId);
      await ref.update({
        'bookmarkedBy': FieldValue.arrayRemove([uid]),
      });
    } catch (e) {
      print('🔥 Error removing bookmark: $e');
    }
  }
}
