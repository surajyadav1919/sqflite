import 'dart:io';
import 'package:crud_sqflite/db/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserInputForm extends StatefulWidget {
  @override
  _UserInputFormState createState() => _UserInputFormState();
}

class _UserInputFormState extends State<UserInputForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: mobileController,
              decoration: InputDecoration(labelText: 'Mobile'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a mobile number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email';
                }
                return null;
              },
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Select Image'),
            ),
            if (_image != null)
              Image.file(File(_image!.path)),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _saveUser();
                }
              },
              child: Text('Save'),
            ),
            ElevatedButton(
              onPressed: () async {
               getUsers();
               },
              child: Text('get user'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile;
    });
  }

  void _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final String name = nameController.text;
      final String mobile = mobileController.text;
      final String email = emailController.text;

      String? imagePath;
      if (_image != null) {
        // If an image is selected, save it and get the file path.
        final File imageFile = File(_image!.path);
        imagePath = imageFile.path;
      }

      final User user = User(name: name, mobile: mobile, email: email, image: imagePath);

      // Insert the user into the database.
      await insertUser(user);

      // After saving the user, you can clear the form or perform any other actions.
      nameController.clear();
      mobileController.clear();
      emailController.clear();
      setState(() {
        _image = null; // Clear the selected image.
      });
    }
  }
}


