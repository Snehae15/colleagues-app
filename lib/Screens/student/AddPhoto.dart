import 'dart:io';
import 'package:college_app/constants/colors.dart';
import 'package:college_app/widgets/AppText.dart';
import 'package:college_app/widgets/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class AddPhoto extends StatefulWidget {
  const AddPhoto({super.key});

  @override
  State<AddPhoto> createState() => _AddPhotoState();
}

class _AddPhotoState extends State<AddPhoto> {
  final description = TextEditingController();

  File? selectImg;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20).r,
          child: InkWell(
            onTap: () {
              Navigator.pop(context); // back arrow Function...........
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
                      child: selectImg != null
                          ? Image.file(selectImg!)
                          : InkWell(
                              onTap: () async {
                                final img = await ImagePicker().pickImage(
                                    source: ImageSource
                                        .gallery); // image picker............................
                                setState(() {
                                  selectImg = File(img!.path);
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
                        controller: description, // controller........
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 15.w),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6).r),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6).r,
                                borderSide:
                                    const BorderSide(color: maincolor))),
                      ),
                    ),
                    SizedBox(
                      height: 60.h,
                    ),
                  ]),
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                    btnname: "Send",
                    click: () {
                      // image send button..................
                    }))
          ],
        ),
      ),
    );
  }
}
