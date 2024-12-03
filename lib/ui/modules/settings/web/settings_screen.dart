// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:country_picker/country_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/components/input/dropdownField.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:country_picker/country_picker.dart' as countryPicker;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final List<String> userList = ["User 1", "User 2", "User 3", "User 4"];
  Uint8List? _selectedImageBytes;
  String? selectedUser;
  String? _imageUrl;

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );

    if (result != null) {
      setState(() {
        _selectedImageBytes = result.files.single.bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyDark,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Personal info',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.greyWhite,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                      ),
                      8.height,
                      Text(
                        'Update your photo and personal details.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.greyWhite,
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                      ),
                    ],
                  ),
                ),
                32.height,
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "First name",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.greyWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                InputField(
                                  // controller: ,
                                  hint: 'Jane',
                                  radius: 8.0,
                                ),
                              ],
                            ),
                          ),
                          16.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Last name",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.greyWhite,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                InputField(
                                  hint: 'Doe',
                                  radius: 8.0,
                                  // controller: ,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          8.height,
                          InputField(
                            hint: 'janedoe@mail.com',
                            radius: 10.0,
                            preffixIcon: const Icon(Icons.email_outlined,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: _pickImage,
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.transparent,
                                  backgroundImage: _selectedImageBytes != null
                                      ? MemoryImage(_selectedImageBytes!)
                                      : AssetImage(Assets.citiImg)
                                          as ImageProvider,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Container(
                                  height: 150,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                            onTap: _pickImage,
                                            child: SvgPicture.asset(
                                                Assets.upload)),
                                        const SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            children: [
                                              TextSpan(
                                                text: 'Click to upload',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppColors.primary,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: ' or drag and drop',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color:
                                                          AppColors.greyWhite,
                                                      fontSize: 14,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text(
                                          'SVG, PNG, JPG or GIF (max. 800x400px)',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.gray2,
                                                fontSize: 12,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Country",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          8.height,
                          // InputField(
                          //   hint: 'United State',
                          //   radius: 8.0,
                          //   // controller: ,
                          // ),
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green),
                            ),
                            child: const Text("Select Country"),
                            onPressed: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                showSearch: true,
                                onSelect: (countryPicker.Country country) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        country.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.greyWhite,
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                            ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Timezone",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          InputField(
                            hint: 'Time Zone',
                            radius: 8.0,
                            // controller: ,
                          ),
                        ],
                      ),
                      32.height,
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomIconButton(
                              label: "Cancel",
                              backgroundColor: AppColors.greyDark,
                              textColor: AppColors.white,
                              borderColor: AppColors.white,
                              onPressed: () {},
                            ),
                            3.width,
                            CustomIconButton(
                              label: "Save Changes",
                              backgroundColor: AppColors.white,
                              textColor: AppColors.black,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            90.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Report an incident',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                ),
                32.height,
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Selelct user",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          DropdownField<String>(
                            hint: "Select user from the dropdown",
                            value: selectedUser,
                            items: userList.map((user) {
                              return DropdownMenuItem(
                                value: user,
                                child: Text(user),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedUser = value;
                              });
                            },
                            fillColor: AppColors.greyDark,
                            textColor: AppColors.white,
                            borderColor: AppColors.inputBorderColor,
                          ),
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date of incident",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          8.height,
                          InputField(
                            hint: 'Choose date of incident',
                            radius: 10.0,
                            suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Details of incident",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          8.height,
                          InputField(
                            hint: 'Enter the details of the incident',
                            radius: 8.0,
                            lines: 6,
                            maxLines: 10,
                            // controller: ,
                          ),
                        ],
                      ),
                      32.height,
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomIconButton(
                              label: "Cancel",
                              backgroundColor: AppColors.greyDark,
                              textColor: AppColors.white,
                              borderColor: AppColors.white,
                              onPressed: () {},
                            ),
                            3.width,
                            CustomIconButton(
                              label: "Save Changes",
                              backgroundColor: AppColors.white,
                              textColor: AppColors.black,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            90.height,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Text(
                    'Support',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.greyWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                ),
                32.height,
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Phone",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                          ),
                          const SizedBox(height: 8),
                          InputField(
                            // controller: ,
                            enable: false,
                            hint: '+127464739478',
                            radius: 8.0,
                          ),
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Date of incident",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.greyWhite,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                          8.height,
                          InputField(
                            hint: 'support@mail.com',
                            radius: 10.0,
                            enable: false,
                            suffixIcon: const Icon(
                                Icons.calendar_month_outlined,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ticket",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          8.height,
                          InputField(
                            hint: 'Details of ticket',
                            radius: 8.0,
                            // controller: ,
                          ),
                        ],
                      ),
                      24.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Details of incident",
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.greyWhite,
                                      fontWeight: FontWeight.w500,
                                    ),
                          ),
                          8.height,
                          InputField(
                            hint: 'Enter the details of the incident',
                            radius: 8.0,
                            lines: 6,
                            maxLines: 10,
                            // controller: ,
                          ),
                        ],
                      ),
                      32.height,
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CustomIconButton(
                              label: "Cancel",
                              backgroundColor: AppColors.greyDark,
                              textColor: AppColors.white,
                              borderColor: AppColors.white,
                              onPressed: () {},
                            ),
                            3.width,
                            CustomIconButton(
                              label: "Save Changes",
                              backgroundColor: AppColors.white,
                              textColor: AppColors.black,
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
