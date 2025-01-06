import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';

class CoverImageUploader extends StatefulWidget {
  final String? url;
  final Function(String fileName, Uint8List? fileBytes, String)? onFileSelected;

  const CoverImageUploader({Key? key, this.onFileSelected, this.url})
      : super(key: key);

  @override
  _CoverImageUploaderState createState() => _CoverImageUploaderState();
}

class _CoverImageUploaderState extends State<CoverImageUploader> {
  String? selectedFileName;
  Uint8List? selectedFileBytes;
  bool isDragging = false;

  Future<void> _pickFile() async {
    try {
      if (kIsWeb) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
            allowMultiple: false,
            // Set to true if you want to pick multiple files
            type: FileType.image);

        final XFile? image = result?.xFiles.first;
        if (image != null) {
          final bytes = await image.readAsBytes();

          setState(() {
            selectedFileName = image.name;
            selectedFileBytes = bytes;
          });

          if (widget.onFileSelected != null) {
            widget.onFileSelected!(
                selectedFileName!, selectedFileBytes, image.path ?? '');
          }
        } else {
          print("No file selected");
        }
      } else {}
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
      child: DragTarget<XFile>(
        onWillAccept: (data) {
          setState(() {
            isDragging = true;
          });
          return true;
        },
        onAccept: (file) async {
          final bytes = await file.readAsBytes();
          setState(() {
            selectedFileName = file.name;
            selectedFileBytes = bytes;
            isDragging = false;
          });

          if (widget.onFileSelected != null) {
            widget.onFileSelected!(
                selectedFileName!, selectedFileBytes, file.path);
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
                if (selectedFileBytes == null && widget.url == null) ...[
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
                  if (selectedFileBytes != null)
                  GestureDetector(
                    onTap: _pickFile,
                    child:   Image.memory(
                      selectedFileBytes!,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  )
                  else
                    GestureDetector(
                      onTap: _pickFile,
                      child: Image.network(
                        widget.url!,
                        height: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  const SizedBox(height: 10),
                    Text(
                      'Click on image to select a new one',
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
