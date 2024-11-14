import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class CoverImageUploader extends StatefulWidget {
  final Function(String fileName, Uint8List? fileBytes)? onFileSelected;

  const CoverImageUploader({Key? key, this.onFileSelected}) : super(key: key);

  @override
  _CoverImageUploaderState createState() => _CoverImageUploaderState();
}

class _CoverImageUploaderState extends State<CoverImageUploader> {
  String? selectedFileName;
  Uint8List? selectedFileBytes;
  bool isDragging = false;

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final PlatformFile file = result.files.first;

        setState(() {
          selectedFileName = file.name;
          selectedFileBytes = file.bytes;
        });

        if (widget.onFileSelected != null) {
          widget.onFileSelected!(selectedFileName!, selectedFileBytes);
        }
      } else {
        print("No file selected");
      }
    } catch (e) {
      print("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: Colors.grey,
      strokeWidth: 1,
      dashPattern: [6, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(10),
      child: DragTarget<PlatformFile>(
        onWillAccept: (data) {
          setState(() {
            isDragging = true;
          });
          return true;
        },
        onAccept: (file) {
          setState(() {
            selectedFileName = file.name;
            selectedFileBytes = file.bytes;
            isDragging = false;
          });

          if (widget.onFileSelected != null) {
            widget.onFileSelected!(selectedFileName!, selectedFileBytes);
          }
        },
        onLeave: (data) {
          setState(() {
            isDragging = false;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            color: isDragging ? Colors.grey[800] : Colors.grey[900],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedFileBytes == null) ...[
                  const Icon(
                    Icons.cloud_upload_outlined,
                    size: 30,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 10),
                  Text('Browse and choose your cover image',
                      style: context.textTheme.bodySmall?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w400,
                          fontSize: 12)),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _pickFile,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),
                  ),
                ] else ...[
                  Image.memory(
                    selectedFileBytes!,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Selected: $selectedFileName',
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
