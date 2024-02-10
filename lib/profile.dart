import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project1/widgets/custom_button.dart';
import 'package:project1/widgets/custom_input.dart';
import 'package:project1/dot_navigation_bar.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';

enum _SelectedTab { Home, AddPost, Chat, Profile }

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

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
      final pickedImage = await picker.getImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          selectedImages.add(pickedImage);
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
              Container(
                width: 100, // Specify the desired width
                height: 200, // Specify the desired height
                child: ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text("Add Image"),
                ),
              ),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: selectedImages.map((PickedFile image) {
                  return Container(
                    width: 100,
                    height: 500,
                    child: Image.file(
                      File(image.path),
                      fit: BoxFit.cover,
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              CustomInput(
                  hint: "Name...",
                  inputBorder: OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Name = value;
                    });
                  }),
              DropdownButtonFormField(
                decoration: InputDecoration(
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
              SizedBox(height: 16),
              CustomInput(
                  hint: "Breed",
                  inputBorder: OutlineInputBorder(),
                  onChanged: (value) {
                    setState(() {
                      Breed = value;
                    });
                  }),
              DropdownButtonFormField(
                decoration: InputDecoration(
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
              SizedBox(height: 16),
              InputDecorator(
                decoration: InputDecoration(
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
              SizedBox(height: 16),
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
                              ? Color.fromARGB(255, 250, 86, 114)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(
                            color: Color.fromARGB(
                                255, 34, 17, 112), // Border color
                            width: 2.0, // Border width
                          ),
                        ),
                        child: Text(
                          color,
                          style: TextStyle(
                            color: selectedColors.contains(color)
                                ? Colors.white
                                : Color.fromARGB(255, 34, 17, 112),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              SizedBox(height: 8),
              SizedBox(height: 8),
              SizedBox(height: 16),
              CustomInput(
                  hint: "Description...",
                  inputBorder: OutlineInputBorder(),
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
                },
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 160,
          child: Padding(
            padding: EdgeInsets.only(bottom: 0),
            child: DotNavigationBar(
              margin: EdgeInsets.only(left: 30, right: 30),
              currentIndex: _SelectedTab.values.indexOf(_selectedTab),
              dotIndicatorColor: Color.fromARGB(255, 250, 86, 114),
              unselectedItemColor: Colors.grey[300],
              splashBorderRadius: 50,
              //enableFloatingNavBar: false,
              onTap: _handleIndexChanged,
              items: [
                /// Home
                DotNavigationBarItem(
                  icon: Icon(Icons.home),
                  selectedColor: Color.fromARGB(255, 250, 86, 114),
                ),

                /// Likes
                DotNavigationBarItem(
                  icon: Icon(Icons.favorite),
                  selectedColor: Color.fromARGB(255, 250, 86, 114),
                ),

                /// Search
                DotNavigationBarItem(
                  icon: Icon(Icons.search),
                  selectedColor: Color.fromARGB(255, 250, 86, 114),
                ),

                /// Profile
                DotNavigationBarItem(
                  icon: Icon(Icons.person),
                  selectedColor: Color.fromARGB(255, 250, 86, 114),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
