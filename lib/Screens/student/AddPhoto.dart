import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AddPhoto extends StatefulWidget {
  final String eventId;

  const AddPhoto({Key? key, required this.eventId}) : super(key: key);

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  final description = TextEditingController();

  File? selectedImage;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20).r,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: customBlack,
            ),
          ),
        ),
        title: AppText(
            text: "Add Photo",
            size: 18.sp,
            fontWeight: FontWeight.w500,
            color: customBlack),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h).r,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                      text: "Photo",
                      size: 15,
                      fontWeight: FontWeight.w400,
                      color: customBlack),
                  SizedBox(
                    height: 5.h,
                  ),
                  Container(
                    width: double.infinity,
                    height: 350.h,
                    decoration: BoxDecoration(
                        border: Border.all(color: maincolor),
                        borderRadius: BorderRadius.circular(6).r),
                    child: selectedImage != null
                        ? Image.file(selectedImage!)
                        : InkWell(
                            onTap: () async {
                              final image = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              setState(() {
                                selectedImage = File(image!.path);
                              });
                            },
                            child: const Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 100,
                              color: maincolor,
                            ),
                          ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const AppText(
                      text: "Description",
                      size: 15,
                      fontWeight: FontWeight.w400,
                      color: customBlack),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 15).r,
                    child: TextFormField(
                      controller: description,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 15.w),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6).r),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6).r,
                          borderSide: const BorderSide(color: maincolor),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60.h,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: CustomButton(
                btnname: "Send",
                click: isUploading ? () {} : () => _onSendButtonClicked(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<String> uploadImage(File image) async {
    try {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('events/${widget.eventId}/${DateTime.now().toString()}');

      final UploadTask uploadTask = storageReference.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

      final String imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception("Error uploading image");
    }
  }

  Future<void> addImageToFirestore(String imageUrl) async {
    try {
      await FirebaseFirestore.instance
          .collection(
              'event_photos') // Change this collection name to your desired one
          .add({
        'eventId': widget.eventId,
        'imageUrl': imageUrl,
        'description': description.text,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error adding image to Firestore: $e");
      throw Exception("Error adding image to Firestore");
    }
  }

  void _onSendButtonClicked() async {
    setState(() {
      isUploading = true;
    });

    try {
      if (selectedImage != null) {
        String imageUrl = await uploadImage(selectedImage!);
        await addImageToFirestore(imageUrl);
        Navigator.pop(context);
      } else {
        _showToast("Please select an image.");
      }
    } catch (e) {
      print("Error: $e");
      _showToast("Error: $e");
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
