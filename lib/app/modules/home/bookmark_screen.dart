import 'package:flutter/material.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';
import 'package:foodpad/app/controller/bookmark_controller.dart';
import 'package:foodpad/app/modules/home/menu_detail.dart';

class BookmarkScreen extends StatelessWidget {
  final controller = Get.put(BookmarkController());
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Bookmarks',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: CustomColors.mainColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.bookmarkedRecipes.isEmpty) {
          return const Center(child: Text('No bookmarks yet.'));
        }

        return AnimatedList(
          key: _listKey,
          initialItemCount: controller.bookmarkedRecipes.length,
          itemBuilder: (context, index, animation) {
            final recipe = controller.bookmarkedRecipes[index];
            return _buildAnimatedItem(recipe, animation, index);
          },
        );
      }),
    );
  }

  Widget _buildAnimatedItem(
    Map<String, dynamic> recipe,
    Animation<double> animation,
    int index,
  ) {
    final imageUrl =
        (recipe['images'] != null && recipe['images'].isNotEmpty)
            ? recipe['images'][0]
            : 'https://via.placeholder.com/150';

    return SizeTransition(
      sizeFactor: animation,
      axisAlignment: 0.0,
      child: Dismissible(
        key: ValueKey(recipe['docId']),
        background: Container(
          color: Colors.redAccent,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 20),
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          // เอา recipe ที่กำลังจะลบออกจาก list ก่อน
          final removedRecipe = controller.bookmarkedRecipes.removeAt(index);

          // สั่ง AnimatedList ลบออก พร้อม animation
          _listKey.currentState?.removeItem(
            index,
            (context, animation) =>
                _buildAnimatedItem(removedRecipe, animation, index),
            duration: const Duration(milliseconds: 300),
          );

          // แล้วค่อยลบจาก Firebase ทีหลัง (ไม่กระทบ UI ทันที)
          controller.removeBookmark(removedRecipe['docId']);
        },

        child: Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 2,
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              recipe['title'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              "${recipe['cookingTime']} min • ${recipe['difficulty']}",
              style: const TextStyle(fontSize: 12),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Get.to(() => MenuDetail(), arguments: recipe);
            },
          ),
        ),
      ),
    );
  }
}
