import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:foodpad/app/controller/bookmark_controller.dart';
import 'package:foodpad/app/modules/home/menu_detail.dart';

class BookmarkScreen extends StatelessWidget {
  final controller = Get.put(BookmarkController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // สามารถเพิ่มหมวดหมู่ bookmark ได้ในอนาคต
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder:
              (context, _) => [
                SliverAppBar(
                  title: const Text('My Bookmarks'),
                  backgroundColor: Colors.teal,
                  floating: true,
                  pinned: true,
                  bottom: const TabBar(
                    tabs: [Tab(text: 'All'), Tab(text: 'Favorites')],
                  ),
                ),
              ],
          body: TabBarView(
            children: [
              Obx(() => _buildBookmarkList()),
              Center(child: Text('Favorites Tab (optional)')),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.bookmarkedRecipes.isEmpty) {
        return const Center(child: Text('No bookmarks yet.'));
      }

      return ListView.builder(
        itemCount: controller.bookmarkedRecipes.length,
        itemBuilder: (context, index) {
          final recipe = controller.bookmarkedRecipes[index];
          final imageUrl =
              (recipe['images'] != null && recipe['images'].isNotEmpty)
                  ? recipe['images'][0]
                  : 'https://via.placeholder.com/150';

          return Dismissible(
            key: Key(recipe['docId']),
            background: Container(
              color: Colors.redAccent,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              controller.removeBookmark(recipe['docId']);
              Get.snackbar("Bookmark removed", recipe['title']);
            },
            child: ListTile(
              leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
              title: Text(recipe['title'] ?? ''),
              subtitle: Text(
                "${recipe['cookingTime']} min • ${recipe['difficulty']}",
              ),
              onTap: () {
                Get.to(() => MenuDetail(), arguments: recipe);
              },
            ),
          );
        },
      );
    });
  }
}
