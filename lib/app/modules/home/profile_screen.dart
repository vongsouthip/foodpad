import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:foodpad/app/controller/edit_profile_controller.dart';
import 'package:foodpad/app/controller/login_email_controller.dart';
import 'package:foodpad/app/modules/add_menu_page_view/my_menu_page.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:foodpad/app/modules/home/edit_profile_screen.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class ProfileScreen extends StatelessWidget {
  final editProfileCtrl = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Obx(
                () => Container(
                  height: 250,
                  decoration: BoxDecoration(
                    image:
                        editProfileCtrl.backgroundImage.value.isNotEmpty
                            ? DecorationImage(
                              image: NetworkImage(
                                editProfileCtrl.backgroundImage.value,
                              ),
                              fit: BoxFit.cover,
                            )
                            : null,
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: CustomColors.fillColor.withOpacity(0.8),
                  ),
                  child: IconButton(
                    onPressed:
                        () => showDialog<String>(
                          context: context,
                          builder:
                              (BuildContext context) => AlertDialog(
                                title: const Text('Logout'),
                                content: const Text(
                                  'Are you sure you want to logout?',
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed:
                                        () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Get.put(LoginController()).logout();

                                      Navigator.pop(context, 'OK');
                                      Get.offAllNamed('/login');
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                        ),
                    icon: Icon(
                      Icons.logout,
                      color: CustomColors.mainColor,
                      size: 24,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -50,
                child: Obx(
                  () => CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        editProfileCtrl.profileImage.value.isNotEmpty
                            ? NetworkImage(editProfileCtrl.profileImage.value)
                            : null,
                    backgroundColor: Colors.white,
                    child:
                        editProfileCtrl.profileImage.value.isEmpty
                            ? Icon(Icons.person, size: 50, color: Colors.grey)
                            : null,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 60),
          // show name and address
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 24.w),
              Obx(
                () => Text(
                  '${editProfileCtrl.firstName.value} ${editProfileCtrl.lastName.value}',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.to(() => EditProfilePage());
                },
                icon: Icon(Icons.edit, color: CustomColors.mainColor, size: 24),
              ),
            ],
          ),

          //address
          Obx(
            () => Text(
              editProfileCtrl.address.value,
              style: TextStyle(fontSize: 16, color: CustomColors.mainColor),
            ),
          ),
          Divider(),
          Text(
            'My Recipes',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: buildMyRecipes(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;

  FilterButton({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal.shade100,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class RecipeGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: BouncingScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: 4,
      itemBuilder: (context, index) {
        return RecipeCard();
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Image.asset(
            'assets/images/welcome2.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Text(
              'Chocolate Cake',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// top: 50,
//             width: 80,
//             child: GestureDetector(
//               onTap: () {
//                 Get.back();
//               },
//               child: Container(
//                 width: 50,
//                 height: 50,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: CustomColors.fillColor,
//                 ),
//                 child: const Icon(
//                   Icons.arrow_back,
//                   color: CustomColors.mainColor,
//                   size: 24,
//                 ),
//               ),
//             ),