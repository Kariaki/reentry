import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';

class ReusableEditModal extends StatefulWidget {
  final String name;
  final String dob;
  final String phone;
  final String address;
  final Function(String name, String dob, String phone, String address) onSave;
  final VoidCallback onCancel;

  const ReusableEditModal({
    Key? key,
    required this.name,
    required this.dob,
    required this.onSave,
    required this.phone,
    required this.address,
    required this.onCancel,
  }) : super(key: key);

  @override
  State<ReusableEditModal> createState() => _ReusableEditModalState();
}

class _ReusableEditModalState extends State<ReusableEditModal> {
  late TextEditingController _nameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _addressController;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _phoneNumberController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
    _selectedDate = DateTime.parse(widget.dob);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double modalWidth = screenWidth * 0.8;
    return Container(
      width: kIsWeb ? 400 : null,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Edit Profile',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
          ),
          const SizedBox(height: 20),
          InputField(
            controller: _nameController,
            hint: 'Enter Name',
            radius: 10.0,
          ),
          const SizedBox(height: 20),
          InputField(
            controller: _phoneNumberController,
            hint: 'Phone number',
            radius: 10.0,
          ),
          const SizedBox(height: 20),
          InputField(
            controller: _addressController,
            hint: 'Address',
            radius: 10.0,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _selectDate(context),
            child: InputField(
              hint: _selectedDate.toLocal().toString().split(' ')[0],
              radius: 10.0,
              // enabled: false,
              preffixIcon:
                  const Icon(Icons.calendar_today, color: AppColors.greyWhite),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomIconButton(
                label: 'Cancel',
                backgroundColor: AppColors.red,
                textColor: AppColors.white,
                onPressed: () {
                  context.popBack();
                },
              ),
              CustomIconButton(
                label: 'Save',
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
                onPressed: () {
                  widget.onSave(
                      _nameController.text,
                      _selectedDate.toIso8601String(),
                      _phoneNumberController.text,
                      _addressController.text);
                  context.popBack();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
