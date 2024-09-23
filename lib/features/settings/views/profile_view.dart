import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:freelancerApp/core/widgets/Custom_button.dart';
import 'package:freelancerApp/core/widgets/custom_textformfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:freelancerApp/features/settings/controllers/settings_controller.dart';
import 'package:freelancerApp/features/settings/models/user.dart' as AppUser;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SettingsController _settingsController = Get.find();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  String imageUrl = '';
  @override
  void initState() {
    super.initState();
    _settingsController.getUserData().then((_) {
      final user = _settingsController.userData.isNotEmpty
          ? _settingsController.userData[0]
          : null;
      if (user != null) {
        _nameController.text = user.name;
        _emailController.text = user.email;
        _phoneController.text = user.phone;
        setState(() {
          imageUrl = user.image; // Use user.image to show current image
          _image = user.image.isNotEmpty ? File(user.image) : null;
        });
      }
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
      _uploadImage();
    }
  }

  Future<void> _uploadImage() async {
    if (_image != null) {
      final userId = firebase_auth.FirebaseAuth.instance.currentUser!.uid;
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('$userId.jpg');
      try {
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();

        setState(() {});
      } catch (e) {
        print("Error uploading image: $e");
      }
    }
  }

  Future<void> _updateUserData() async {
    log(imageUrl);
    log(_nameController.text);
    log(_emailController.text);
    log(_phoneController.text);
    await _settingsController.updateUserData(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      image: imageUrl,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الحساب'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: imageUrl.isNotEmpty
                        ? NetworkImage(imageUrl) as ImageProvider<
                            Object>? // Cast to ImageProvider<Object> explicitly
                        : _image != null
                            ? FileImage(_image!) as ImageProvider<
                                Object>? // Cast to ImageProvider<Object> explicitly
                            : null,
                    child: imageUrl.isEmpty && _image == null
                        ? const Icon(Icons.person, size: 50)
                        : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: _pickImage,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      'الأسم',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _nameController,
                hint: 'ادخل الاسم',
                obs: false,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      'البريد الالكتروني',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _emailController,
                hint: 'ادخل البريد الالكتروني',
                obs: false,
              ),
              const SizedBox(height: 10),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Text(
                      'الهاتف',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: _phoneController,
                hint: 'ادخل رقم الهاتف',
                obs: false,
              ),
              const SizedBox(height: 20),
              CustomButton(text: 'تحديث', onPressed: _updateUserData)
            ],
          ),
        ),
      ),
    );
  }
}
