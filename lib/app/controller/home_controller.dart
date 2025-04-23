import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var recipes = {}.obs;
  var isLoading = true.obs;
  var imageUrls = [].obs;
  var ingredients = <String>[].obs;
  var directions = <String>[].obs;
  var mostLikedRecipes = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchMostLikedRecipes();
  }

   fetchMostLikedRecipes() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('recipes').get();

      final sorted =
          snapshot.docs.map((doc) {
            final data = doc.data();
            data['docId'] = doc.id;
            data['images'] = data['images'] ??[0];
            final likes =
                (data['likes'] is List)
                    ? List<String>.from(data['likes'])
                    : <String>[];

            return {
              'title': data['title'] ?? '',
              'uid': data['uid'] ?? '',
              'images': List<String>.from(data['images'] ?? []),
              // ignore: equal_keys_in_map
              'image':
                  (data['images'] != null &&
                          data['images'] is List &&
                          (data['images'] as List).isNotEmpty)
                      ? data['images'][0]
                      : '',
              'ingredients': data['ingredients'],
              'directions': data['directions'],
              'difficulty': data['difficulty'],
              'category': data['category'],
              'likesCount': likes.length,
              'cookingTime': data['cookingTime'] ?? 0,
              'docId': doc.id,
            };
          }).toList();

      sorted.sort((a, b) => b['likesCount'].compareTo(a['likesCount']));

      mostLikedRecipes.value = sorted.take(5).toList();
    } catch (e) {
      print("🔥 Error fetching most liked: $e");
    }
  }
}
