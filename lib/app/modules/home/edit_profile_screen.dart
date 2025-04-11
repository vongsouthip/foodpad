import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodpad/app/controller/edit_profile_controller.dart';
import 'package:foodpad/app/modules/components/colors.dart';
import 'package:get/get.dart';

class EditProfilePage extends StatefulWidget {
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final editProfileCtrl = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.fillColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.white60,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
        ),
      ),
      body: Obx(
        () =>
            editProfileCtrl.isLoading.value
                ? CircularProgressIndicator()
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // editProfileCtrl.pickAndUploadBackgroundImage(
                            //   isProfile: false,
                            // );
                            showActionSheet(context);
                          },
                          child: Container(
                            height: 300.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              image:
                                  editProfileCtrl
                                          .backgroundImage
                                          .value
                                          .isNotEmpty
                                      ? DecorationImage(
                                        image: NetworkImage(
                                          editProfileCtrl.backgroundImage.value,
                                        ),
                                        fit: BoxFit.cover,
                                      )
                                      : null,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -50.0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () => showActionSheet2(context),
                              child: CircleAvatar(
                                radius: 50.0,
                                backgroundColor: Colors.white,
                                backgroundImage:
                                    editProfileCtrl
                                            .profileImage
                                            .value
                                            .isNotEmpty
                                        ? NetworkImage(
                                          editProfileCtrl.profileImage.value,
                                        )
                                        : null,
                                child:
                                    editProfileCtrl.profileImage.value.isEmpty
                                        ? Icon(
                                          Icons.person,
                                          size: 50.0,
                                          color: Colors.grey[700],
                                        )
                                        : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 50.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            controller: editProfileCtrl.firstNameCtrl.value,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          TextField(
                            controller: editProfileCtrl.lastNameCtrl.value,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),

                          TextField(
                            controller: editProfileCtrl.addressCtrl.value,
                            style: TextStyle(fontSize: 16.0),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0,
                                horizontal: 12.0,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide.none,
                              ),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: Colors.grey[700],
                              ),
                            ),
                          ),
                          SizedBox(height: 24.0),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                editProfileCtrl.updateUser(
                                  FirebaseAuth.instance.currentUser!.uid,
                                );
                                Get.back();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColors.mainColor,
                                padding: EdgeInsets.symmetric(vertical: 14.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: Text(
                                'Save',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
      ),
    );
  }

  void showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoActionSheet(
            message: const Text('Choose background image'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () {
                  editProfileCtrl.pickAndUploadBackgroundImage(
                    isProfile: false,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Camera'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  editProfileCtrl.pickAndUploadBackgroundImage(
                    isProfile: false,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Gallery'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ),
    );
  }

  void showActionSheet2(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder:
          (BuildContext context) => CupertinoActionSheet(
            message: const Text('Choose profile image'),
            actions: <Widget>[
              CupertinoActionSheetAction(
                onPressed: () {
                  editProfileCtrl.pickAndUploadImage(isProfile: true);
                  Navigator.pop(context);
                },
                child: const Text('Camera'),
              ),
              CupertinoActionSheetAction(
                onPressed: () {
                  editProfileCtrl.pickAndUploadImage(isProfile: false);
                  Navigator.pop(context);
                },
                child: const Text('Gallery'),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ),
    );
  }
}
