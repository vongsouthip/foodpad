import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodpad/app/controller/search_controller.dart' as custom;
import 'package:foodpad/app/modules/home/menu_detail.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(custom.SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search for a recipe...',
            border: InputBorder.none,
          ),
          onChanged: controller.searchRecipes,
        ),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.query.isNotEmpty && controller.results.isEmpty) {
          return const Center(child: Text('No results found'));
        }

        return ListView.builder(
          itemCount: controller.results.length,
          itemBuilder: (context, index) {
            final recipe = controller.results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(
                  (recipe['images'] as List).isNotEmpty
                      ? recipe['images'][0]
                      : 'https://via.placeholder.com/150',
                ),
              ),
              title: Text(recipe['title'] ?? ''),
              onTap: () {
                Get.to(() => MenuDetail(), arguments: recipe);
              },
            );
          },
        );
      }),
    );
  }
}
