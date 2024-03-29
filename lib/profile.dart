import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/widgets/custom_button.dart';
import 'package:project1/widgets/custom_input.dart';
import 'package:project1/dot_navigation_bar.dart';
import 'profileShowDetails.dart';

import 'dart:io';

enum _SelectedTab { Home, AddPost, Chat, Profile }

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> with TickerProviderStateMixin {
  String? Name;
  String? Type;
  String? Breed;
  String? Gender;
  String? Description;
  String? selectedType;
  String? selectedGender;
  List<String> selectedColors = [];
  List<PickedFile> selectedImages = [];
  var _selectedTab = _SelectedTab.Profile;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  final List<String> colorOptions = [
    "White",
    "Black",
    "Gray",
    "Orange",
    "Brown",
    "Red",
    "Gold"
  ];

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          selectedImages.add(PickedFile(pickedImage.path));
          print("Selected Images: $selectedImages");
        });
      }
    } catch (e) {
      // Handle the error (show a message or log it)
      print("Error picking image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var anim = AnimationController(
      vsync: this,
      value: 1,
      duration: const Duration(milliseconds: 500),
    );
    return MaterialApp(
      home: Scaffold(
        extendBody: true,
        appBar: AppBar(
          title: const Text(
            "Profile",
          ),
          centerTitle: true,
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: selectedImages.map((PickedFile image) {
                  return Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                width: 50, // Specify the desired width
                height: 50, // Specify the desired height
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Add Image"),
                ),
              ),
              const SizedBox(height: 16),
              CustomInput(
                  hint: "Name...",
                  inputBorder: const OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Name = value;
                    });
                  }),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: "Types",
                  border: OutlineInputBorder(),
                ),
                value: selectedType,
                onChanged: (newValue) {
                  setState(() {
                    selectedType = newValue.toString();
                    Type = selectedType;
                  });
                },
                items: ["Dog", "Cat", "Others"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              CustomInput(
                  hint: "Breed",
                  inputBorder: const OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Breed = value;
                    });
                  }),
              DropdownButtonFormField(
                decoration: const InputDecoration(
                  hintText: "Gender",
                  border: OutlineInputBorder(),
                ),
                value: selectedGender,
                onChanged: (newValue) {
                  setState(() {
                    selectedGender = newValue.toString();
                    Gender = selectedGender;
                  });
                },
                items: ["Male", "Female"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              InputDecorator(
                decoration: const InputDecoration(
                  hintText: "Selected Colors",
                  border: OutlineInputBorder(),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(selectedColors.isEmpty
                          ? "Select Colors"
                          : selectedColors.join(", ")),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: colorOptions.map((String color) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (selectedColors.contains(color)) {
                          selectedColors.remove(color);
                        } else {
                          selectedColors.add(color);
                        }
                      });
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: selectedColors.contains(color)
                              ? const Color.fromARGB(255, 250, 86, 114)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: const Color.fromARGB(
                                255, 34, 17, 112), // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Text(
                          color,
                          style: TextStyle(
                            color: selectedColors.contains(color)
                                ? Colors.white
                                : const Color.fromARGB(255, 34, 17, 112),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              const SizedBox(height: 8),
              const SizedBox(height: 16),
              CustomInput(
                  hint: "Description...",
                  inputBorder: const OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Description = value;
                    });
                  }),
              CustomBtn(
                title: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                callback: () {
                  // Handle the save action, e.g., print the selected colors and images
                  print("Selected colors: $selectedColors");
                  print("Selected images: $selectedImages");
                  print("Gender: $Gender");

                  print("Breed: $Breed");
                  print("Name: $Name");
                  print("Type: $Type");
                  print("Description: $Description");

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => profileShowDetails(
                              selectedColors: selectedColors,
                              selectedImages: selectedImages,
                              gender: Gender ?? "",
                              breed: Breed ?? "",
                              name: Name ?? "",
                              type: Type ?? "",
                              description: Description ?? "",
                            )),
                  );
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: SizedBox(
          height: 160,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: DotNavigationBar(
              margin: const EdgeInsets.only(left: 30, right: 30),
              currentIndex: _SelectedTab.values.indexOf(_selectedTab),
              dotIndicatorColor: const Color.fromARGB(255, 250, 86, 114),
              unselectedItemColor: Colors.grey[300],
              splashBorderRadius: 50,
              //enableFloatingNavBar: false,
              onTap: _handleIndexChanged,
              items: [
                /// Home
                DotNavigationBarItem(
                  icon: const Icon(Icons.home),
                  selectedColor: const Color.fromARGB(255, 250, 86, 114),
                ),

                /// Likes
                DotNavigationBarItem(
                  icon: const Icon(Icons.add_circle),
                  selectedColor: const Color.fromARGB(255, 250, 86, 114),
                ),

                /// Search
                DotNavigationBarItem(
                  icon: const Icon(Icons.chat),
                  selectedColor: const Color.fromARGB(255, 250, 86, 114),
                ),

                /// Profile
                DotNavigationBarItem(
                  icon: const Icon(Icons.person),
                  selectedColor: const Color.fromARGB(255, 250, 86, 114),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
