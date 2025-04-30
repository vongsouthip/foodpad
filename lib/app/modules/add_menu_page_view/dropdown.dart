import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:foodpad/app/controller/add_menu_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';

Widget dropDownDifficulty() {
  final controller = Get.put(AddMenuController());
  return Obx(
    () => DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        hint: Text(
          'Difficulty',
        ),
        isExpanded: true,
        value:
            controller.difficulty.value.isNotEmpty
                ? controller.difficulty.value
                : null,
        items:
            ['Easy', 'Medium', 'Hard']
                .map(
                  (cat) => DropdownMenuItem(
                    value: cat,
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
        onChanged: (val) => controller.difficulty.value = val!,
        buttonStyleData: ButtonStyleData(
          height: 80,
          width: 220,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: CustomColors.fillColor,
          ),
          elevation: 2,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 160,
          width: 220,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: CustomColors.fillColor,
          ),
          scrollbarTheme: ScrollbarThemeData(radius: const Radius.circular(40)),
        ),
      ),
    ),
  );
}

  Widget dropDownCategory() {
    final controller = Get.put(AddMenuController());
    return Obx(
      () => DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          hint: Text('Category'),
          isExpanded: true,
          value:
              controller.category.value.isNotEmpty
                  ? controller.category.value
                  : null,
          items:
              ['Desert', 'Main Dish', 'Drink', 'Soup', 'Snack']
                  .map(
                    (cat) => DropdownMenuItem(
                      value: cat,
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (val) => controller.category.value = val!,
          buttonStyleData: ButtonStyleData(
            height: 80,
            width: 220,
            padding: const EdgeInsets.only(left: 14, right: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: CustomColors.fillColor,
            ),
            elevation: 2,
          ),
          dropdownStyleData: DropdownStyleData(
            maxHeight: 160,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: CustomColors.fillColor,
            ),
            scrollbarTheme: ScrollbarThemeData(
              radius: const Radius.circular(40),
            ),
          ),
        ),
      ),
    );
  }
