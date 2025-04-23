import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:foodpad/app/controller/menu_detail_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:share_plus/share_plus.dart';

class MenuDetail extends StatelessWidget {
  final Map<String, dynamic> recipe = Get.arguments;
  final controller = Get.put(MenuDetailController());

  @override
  Widget build(BuildContext context) {
    final docId = recipe['docId'];
    final images = List<String>.from(recipe['images'] ?? []);
    final ingredients = List<String>.from(recipe['ingredients'] ?? []);
    final directions = List<String>.from(recipe['directions'] ?? []);
    final cookingTime = recipe['cookingTime'] ?? 0;
    final difficulty = recipe['difficulty'];

    controller.fetchUserAndData(recipe);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Author Info
          Obx(
            () => Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.grey[200],
                  backgroundImage:
                      controller.profileImageUrl.value.isNotEmpty
                          ? NetworkImage(controller.profileImageUrl.value)
                          : null,
                  child:
                      controller.profileImageUrl.value.isEmpty
                          ? const Icon(Icons.person, color: Colors.teal)
                          : null,
                ),
                const SizedBox(width: 10),
                Text(
                  controller.authorName.value,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  controller.formattedDate.value,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Cover Image with Title
          Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  images.isNotEmpty ? images[0] : '',
                  height: 400,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Image.asset('assets/images/welcome.png'),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(16),
                  ),
                  gradient: LinearGradient(
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Text(
                  recipe['title'] ?? 'No title',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Obx(
                () => IconButton(
                  icon: Icon(
                    size: 30,
                    controller.isLiked.value
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => controller.toggleLike(docId),
                ),
              ),
              Obx(
                () => IconButton(
                  icon: Icon(
                    size: 30,
                    controller.isBookmarked.value
                        ? Icons.bookmark
                        : Icons.bookmark_border,
                    color: CustomColors.mainColor,
                  ),
                  onPressed: () => controller.toggleBookmark(docId),
                ),
              ),
              Spacer(),
              IconButton(
                onPressed: () {
                  final title = recipe['title'] ?? 'My Recipe';
                  final shareText = '$title\n\nCheck out this recipe on FoodPad!';
                  Share.share(shareText);
                },
                icon: Icon(Icons.share, size: 30, color: Colors.teal),
              ),
            ],
          ),

          // Cooking info
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: CustomColors.fillColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat(Icons.timer, "$cookingTime min", "Time"),
                const SizedBox(width: 50),
                _buildStat(Icons.local_fire_department, "$difficulty", "Level"),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Ingredients",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...ingredients.mapIndexed(
            (i, ing) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _buildStepBox("${i + 1}", ing),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Directions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...directions.mapIndexed(
            (i, step) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: _buildStepBox("${i + 1}", step),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: CustomColors.mainColor),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildStepBox(String number, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: CustomColors.mainColor,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
