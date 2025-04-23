import 'package:flutter/material.dart';
import 'package:foodpad/app/controller/add_menu_controller.dart';
import 'package:foodpad/app/controller/home_controller.dart';
import 'package:foodpad/app/modules/add_menu_page_view/add_direction_page.dart';
import 'package:foodpad/app/modules/add_menu_page_view/info_page.dart';
import 'package:foodpad/app/modules/add_menu_page_view/ingredients_page.dart';
import 'package:foodpad/app/modules/add_menu_page_view/title_page.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';

class AddMenu extends StatelessWidget {
  final controller = Get.put(AddMenuController());
  final formKey = GlobalKey<FormState>();
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.delete<AddMenuController>();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(title: const Text('Add Recipe'), elevation: 0),
        body: Obx(
          () => Column(
            children: [
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildTitlePage(),
                    buildInfoPage(),
                    buildIngredientsPage(),
                    buildDirectionsPage(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (controller.currentStep.value > 0)
                      ElevatedButton(
                        onPressed: () {
                          controller.currentStep.value--;
                          pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.fillColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 20,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "<  Back",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: CustomColors.mainColor,
                          ),
                        ),
                      ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CustomColors.mainColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 80,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (controller.currentStep.value < 3) {
                          controller.currentStep.value++;
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          controller.submitRecipe();
                          Get.offAllNamed('/main_nav_screen');
                          // Get.find<HomeController>().fetchMostLikedRecipes();
                          // Get.back();
                        }
                      },
                      child: Text(
                        controller.currentStep.value < 3 ? "Next  >" : "Submit",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
