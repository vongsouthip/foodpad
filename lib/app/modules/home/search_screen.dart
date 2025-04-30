import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodpad/app/controller/search_controller.dart' as custom;
import 'package:foodpad/app/modules/home/menu_detail.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(custom.SearchController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'what do you want to',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              Text(
                'cook today?',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              buildSearchBar(),
              SizedBox(height: 16),
              buildPopularTags(),
              SizedBox(height: 16),
              Obx(
                () =>
                    controller.query.value.isNotEmpty
                        ? Text(
                          'Found ${controller.results.length} results',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        )
                        : const SizedBox.shrink(),
              ),
              SizedBox(height: 8),
              SizedBox(height: 600, child: buildResults()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearchBar() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller.textController,
            decoration: InputDecoration(
              hintText: 'Search for a recipe...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon:
                  controller.query.value.isNotEmpty
                      ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: controller.clearSearch,
                      )
                      : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
            ),
            onChanged: controller.searchRecipes,
          ),
          if (controller.suggestions.isNotEmpty) ...[
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children:
                  controller.suggestions.map((sug) {
                    return GestureDetector(
                      onTap: () {
                        controller.textController.text = sug;
                        controller.searchRecipes(sug);
                      },
                      child: Chip(label: Text(sug)),
                    );
                  }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildPopularTags() {
    // เพิ่ม Popular Tag ไว้เล่น ๆ ดึง user
    final tags = [
      '🍛 Rice',
      '🍜 Noodles',
      '🍰 Cake',
      '🍳 Breakfast',
      '🥗 Salad',
    ];

    return Wrap(
      spacing: 8,
      children:
          tags.map((tag) {
            return GestureDetector(
              onTap:
                  () => controller.searchRecipes(
                    tag.replaceAll(RegExp(r'[^\w\s]+'), ''),
                  ),
              child: Chip(label: Text(tag)),
            );
          }).toList(),
    );
  }

  Widget buildResults() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.query.value.isNotEmpty && controller.results.isEmpty) {
        return buildEmptyState();
      }

      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: ListView.builder(
          key: ValueKey(controller.results.length),
          padding: EdgeInsets.symmetric(vertical: 12),
          itemCount: controller.results.length,
          itemBuilder: (context, index) {
            final recipe = controller.results[index];
            final ingredients = List<String>.from(recipe['ingredients'] ?? []);

            return Card(
              margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              child: ListTile(
                contentPadding: EdgeInsets.all(12),
                leading: Hero(
                  tag: recipe['docId'],
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(
                      (recipe['images'] as List).isNotEmpty
                          ? recipe['images'][0]
                          : 'https://via.placeholder.com/150',
                    ),
                  ),
                ),
                title: Text(
                  recipe['title'] ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle:
                    ingredients.isNotEmpty
                        ? Container(
                          margin: EdgeInsets.only(top: 8),
                          height: 30,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                ingredients.length > 3 ? 3 : ingredients.length,
                            separatorBuilder: (_, __) => SizedBox(width: 6),
                            itemBuilder: (_, i) {
                              return Chip(
                                backgroundColor: Colors.teal.shade50,
                                label: Text(
                                  ingredients[i],
                                  style: TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                        )
                        : const SizedBox.shrink(),
                onTap: () {
                  Get.to(() => MenuDetail(), arguments: recipe);
                },
              ),
            );
          },
        ),
      );
    });
  }

  Widget buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/empty_search.png',
            width: 200,
            height: 200,
          ),
          SizedBox(height: 20),
          Text(
            'No recipes found!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Try another keyword',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
