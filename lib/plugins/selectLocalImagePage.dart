// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_wallet/plugins/publicData.dart';
import 'package:flutter_wallet/plugins/publicUtils.dart';
import 'package:image_picker/image_picker.dart';

class SelectLocalImagePage extends StatefulWidget {
  const SelectLocalImagePage({super.key});

  @override
  State<SelectLocalImagePage> createState() => _SelectLocalImagePageState();
}

class _SelectLocalImagePageState extends State<SelectLocalImagePage> {
  File? _image;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '选择图片',
          style: TextStyle(
            color: PublicData.color131313,
            fontWeight: FontWeight.bold,
            fontSize: PublicData.textSize_16,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: getBackLastInterfaceButton(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text(
                    '尚未选择图片',
                    style: TextStyle(
                      color: PublicData.color131313,
                      fontWeight: FontWeight.w600,
                      fontSize: PublicData.textSize_16,
                    ),
                  )
                : Image.file(
                    _image!,
                    width: 300.w,
                    height: 300.w,
                  ),
            SizedBox(
              height: 20.h,
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text(
                '选择图片',
                style: TextStyle(
                  color: PublicData.color131313,
                  fontSize: PublicData.textSize_16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
