import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class MenuDetailController extends GetxController {
  var authorName = ''.obs;
  var profileImageUrl = ''.obs;
  var formattedDate = ''.obs;
  var isLiked = false.obs;
  var isBookmarked = false.obs;

  final String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future<void> fetchUserAndData(Map<String, dynamic> recipe) async {
    final userId = recipe['uid'];
    final timestamp = recipe['createdAt'];
    final docId = recipe['docId'];

    if (userId != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .get();
      if (doc.exists) {
        final data = doc.data()!;
        authorName.value = "${data['firstName']} ${data['lastName']}";
        profileImageUrl.value = data['profileImage'] ?? '';
      }
    }

    if (timestamp != null && timestamp is Timestamp) {
      final dt = timestamp.toDate();
      formattedDate.value =
          "${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    }

    if (docId != null) {
      final doc =
          await FirebaseFirestore.instance
              .collection('recipes')
              .doc(docId)
              .get();
      if (doc.exists) {
        final data = doc.data()!;
        isLiked.value = List<String>.from(data['likes'] ?? []).contains(uid);
        isBookmarked.value = List<String>.from(
          data['bookmarkedBy'] ?? [],
        ).contains(uid);
      }
    }
  }

  Future<void> toggleLike(String docId) async {
    if (uid.isEmpty || docId.isEmpty) return;
    final ref = FirebaseFirestore.instance.collection('recipes').doc(docId);
    final doc = await ref.get();
    List<String> likes = List<String>.from(doc.data()?['likes'] ?? []);
    isLiked.value ? likes.remove(uid) : likes.add(uid);
    await ref.update({'likes': likes});
    isLiked.toggle();
  }

  Future<void> toggleBookmark(String docId) async {
    if (uid.isEmpty || docId.isEmpty) return;
    final ref = FirebaseFirestore.instance.collection('recipes').doc(docId);
    final doc = await ref.get();
    List<String> bookmarks = List<String>.from(doc.data()?['bookmarkedBy'] ?? []);
    isBookmarked.value ? bookmarks.remove(uid) : bookmarks.add(uid);
    await ref.update({'bookmarkedBy': bookmarks});
    isBookmarked.toggle();
  }
}
