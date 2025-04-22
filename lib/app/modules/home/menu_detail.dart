import 'package:flutter/material.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class MenuDetail extends StatelessWidget {
  final Map<String, dynamic> recipe = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final images = List<String>.from(recipe['images'] ?? []);
    final ingredients = List<String>.from(recipe['ingredients'] ?? []);
    final directions = List<String>.from(recipe['directions'] ?? []);
    final cookingTime = recipe['cookingTime'] ?? 0;
    final difficulty = recipe['difficulty'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          Row(
            children: [
              Icon(Icons.favorite_border),
              SizedBox(width: 25),
              Icon(Icons.bookmark_border),
              SizedBox(width: 25),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: CustomColors.mainColor,
          ),
          Container(
            child:
                images.isEmpty
                    ? Image.asset(
                      'assets/images/welcome2.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    )
                    : Image.network(
                      recipe['images'][0],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
          ),

          const SizedBox(height: 12),
          Text(
            recipe['title'] ?? 'No title',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CustomColors.fillColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStat(Icons.timer, "$cookingTime min", "Time"),
                SizedBox(width: 50),
                _buildStat(Icons.local_fire_department, "$difficulty", "Level"),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Ingredients",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // 🥚 Ingredients List
          ...ingredients.mapIndexed(
            (i, ing) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildStepBox("${i + 1}", ing),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Directions",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // 📝 Directions List
          ...directions.mapIndexed(
            (i, step) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _buildStepBox("${i + 1}", step),
            ),
          ),

          const SizedBox(height: 20),
          const Text(
            "Gallery",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // 🖼 Gallery Images
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder:
                  (_, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      images[i],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
              separatorBuilder: (_, __) => const SizedBox(width: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: CustomColors.mainColor, size: 25),
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
