import 'package:demo_login/services/store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/profile_controller.dart';
import '../routes/routes.dart';
import '../controllers/logout_controller.dart';
import '../controllers/user_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/profile_img_store.dart';
import 'dart:io';

class ProfileApp extends StatefulWidget {
  const ProfileApp({super.key});

  @override
  State<ProfileApp> createState() => _ProfileAppState();
}

class _ProfileAppState extends State<ProfileApp> {
  final ProfileController controller = Get.put(ProfileController());
  final UserController userController = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      controller.loadProfile();
      controller.loadProfileImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile",
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed(Routes.home);
          },
        ),
        actions: [
          IconButton(
              onPressed: () {
                Get.find<LogoutController>().logout();
              },
              icon: Icon(Icons.logout))
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(15),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white,
              Color.fromARGB(255, 214, 229, 255),
              Color.fromARGB(255, 193, 216, 255),
              Colors.blueAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(controller.avatarPath.value),
            GestureDetector(
              onTap: () async {
                final id = await Store.getUserId();
                final ImagePicker picker = ImagePicker();
                final XFile? image =
                    await picker.pickImage(source: ImageSource.gallery);
                ProfileStore.storeProfileImage(image?.path ?? '', id ?? 0);
              },
              child: Center(
                  child: Obx(() => CircleAvatar(
                        radius: 50,
                        backgroundImage: controller.avatarPath.value.isNotEmpty
                            ? FileImage(File(controller.avatarPath.value))
                            : NetworkImage(controller.avatarController.text)
                                as ImageProvider,
                      ))),
            ),
            const SizedBox(height: 10),
            Text(
              "ID",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: controller.idController,
                enabled: false,
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Name",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: controller.nameController,
                enabled: true,
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Email",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 7),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.blueAccent, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: controller.emailController,
                enabled: true,
                style: GoogleFonts.poppins(
                    color: Colors.black, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final id = await Store.getUserId();

                  print(
                      'THe value 9s ${await ProfileStore.getProfileImage(id ?? 0)}');
                  // userController.updateUser(controller.idController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Update",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  userController.deleteUser(controller.idController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Delete Account",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class ProfileApp extends StatelessWidget {
//   ProfileApp({super.key});

// }
