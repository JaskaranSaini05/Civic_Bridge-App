import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import 'home_screen.dart';
import 'complaint_history_screen.dart';
import 'profile_screen.dart';

class RegisterComplaintScreen extends StatefulWidget {
  const RegisterComplaintScreen({super.key});

  @override
  State<RegisterComplaintScreen> createState() =>
      _RegisterComplaintScreenState();
}

class _RegisterComplaintScreenState extends State<RegisterComplaintScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final addressController = TextEditingController();

  String selectedCategory = 'Other';
  int selectedIndex = 1;
  bool loading = false;

  File? selectedImage;
  String? selectedImageName;

  final ImagePicker picker = ImagePicker();

  final List<String> categories = [
    'Road',
    'Water',
    'Electricity',
    'Garbage',
    'Street Light',
    'Traffic',
    'Drainage',
    'Other',
  ];

  void resetForm() {
    titleController.clear();
    descriptionController.clear();
    addressController.clear();
    setState(() {
      selectedCategory = 'Other';
      selectedImage = null;
      selectedImageName = null;
    });
  }

  Future<void> pickImage() async {
    final XFile? image =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
        selectedImageName = image.name;
      });
    }
  }

  Future<String?> uploadImage(String complaintId) async {
    if (selectedImage == null) return null;

    final ref = FirebaseStorage.instance
        .ref()
        .child('complaints')
        .child('$complaintId.jpg');

    await ref.putFile(selectedImage!);
    return await ref.getDownloadURL();
  }

  Future<void> submitComplaint() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    if (titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      final docRef =
          FirebaseFirestore.instance.collection('complaints').doc();

      String? imageUrl = await uploadImage(docRef.id);

      await docRef.set({
        'title': titleController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory,
        'address': addressController.text.trim(),
        'status': 'Pending',
        'userId': user.uid,
        'imageUrl': imageUrl,
        'createdAt': Timestamp.now(),
      });

      resetForm();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ComplaintHistoryScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 26),
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A6D),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: const Center(
                child: Text(
                  'Register New Complaint',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  MediaQuery.of(context).viewInsets.bottom + 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        GestureDetector(
                          onTap: resetForm,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Reset',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: titleController,
                      hint: 'Enter complaint title',
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: descriptionController,
                      hint: 'Enter complaint description',
                      maxLines: 2,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Category',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _dropdownField(),
                    const SizedBox(height: 12),
                    const Text(
                      'Address',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _inputField(
                      controller: addressController,
                      hint: 'Enter complaint address',
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      'Upload Image',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: pickImage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7DBE6A),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Choose Image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    if (selectedImageName != null)
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                selectedImageName!,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImage = null;
                                  selectedImageName = null;
                                });
                              },
                              child: const Icon(
                                Icons.close,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : submitComplaint,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1E3A6D),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Submit Complaint',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HomeScreen()),
              );
            } else if (index == 2) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => const ComplaintHistoryScreen()),
              );
            } else if (index == 3) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            } else {
              setState(() {
                selectedIndex = index;
              });
            }
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: 'New Complaint',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _dropdownField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          isExpanded: true,
          items: categories
              .map(
                (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
              )
              .toList(),
          onChanged: (value) {
            setState(() {
              selectedCategory = value!;
            });
          },
        ),
      ),
    );
  }
}
