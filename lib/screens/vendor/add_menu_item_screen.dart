import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../providers/menu_provider.dart';
import '../../models/menu_item_model.dart';

class AddMenuItemScreen extends StatefulWidget {
  const AddMenuItemScreen({super.key});

  @override
  State<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends State<AddMenuItemScreen> {

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final descController = TextEditingController();
  final categoryController = TextEditingController();

  File? imageFile;
  String base64Image = "";

  final ImagePicker picker = ImagePicker();

  Future<void> pickImage() async {

    final picked =
        await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {

      imageFile = File(picked.path);

      final bytes = await imageFile!.readAsBytes();

      base64Image = base64Encode(bytes);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    final provider = Provider.of<MenuProvider>(context, listen: false);

    return Scaffold(

      appBar: AppBar(
        title: const Text("Add Food Item"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Card(

          elevation: 4,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),

          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Form(
              key: _formKey,

              child: ListView(

                children: [

                  const Text(
                    "Food Details",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Image Picker

                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey.shade200,
                      ),
                      child: imageFile == null
                          ? const Center(
                              child: Text("Tap to upload image"),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                imageFile!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: "Food Name"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter food name" : null,
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: priceController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: "Price"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter price" : null,
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: categoryController,
                    decoration:
                        const InputDecoration(labelText: "Category"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter category" : null,
                  ),

                  const SizedBox(height: 15),

                  TextFormField(
                    controller: descController,
                    maxLines: 3,
                    decoration:
                        const InputDecoration(labelText: "Description"),
                    validator: (value) =>
                        value!.isEmpty ? "Enter description" : null,
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(

                    onPressed: () async {

                      if (!_formKey.currentState!.validate()) return;

                      if (base64Image.isEmpty) {

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please select an image"),
                          ),
                        );

                        return;
                      }

                      final item = MenuItemModel(
                        id: "",
                        name: nameController.text,
                        price: double.parse(priceController.text),
                        description: descController.text,
                        category: categoryController.text,
                        isAvailable: true,
                        imageBase64: base64Image,
                      );

                      await provider.addItem(item);

                      Navigator.pop(context);
                    },

                    child: const Text("ADD ITEM"),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}