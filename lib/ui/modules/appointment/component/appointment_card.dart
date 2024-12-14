import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/generated/assets.dart';
import 'package:reentry/ui/modules/citizens/component/icon_button.dart';
import 'package:reentry/ui/modules/citizens/component/profile_card.dart';

class AppointmentProfileSection extends StatelessWidget {
  final String name;
  final String email;
  final String imageUrl;
  final String? appointmentDate;
  final String? appointmentTime;
  final String? note;
  final String? userId;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onAccept;
  final bool createdByMe;

  const AppointmentProfileSection(
      {super.key,
      required this.name,
      required this.email,
      required this.imageUrl,
        this.createdByMe=false,
      this.appointmentDate,
      this.appointmentTime,
      this.note,
      this.onReschedule,
      this.onCancel,
      this.onAccept,
      this.userId});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 250),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 168,
            child: ProfileCard(
              name: name,
              email: email,
              imageUrl: Assets.imagesCitiImg,
              showActions: false,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                ProfileDetails(
                  appointmentDate: appointmentDate!,
                  appointmentTime: appointmentTime!,
                  note: note!,
                  onReschedule: onReschedule,
                  onCancel: onCancel,
                  onAccept: onAccept,
                ),
                const SizedBox(height: 15),
                const Divider(color: AppColors.gray2, thickness: 1),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final String? appointmentDate;
  final String? appointmentTime;
  final String? note;
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onAccept;

  const ProfileDetails({
    super.key,
    this.appointmentDate,
    this.appointmentTime,
    this.note,
    this.onReschedule,
    this.onCancel,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: ProfileInfoRow(
                  label: "Appointment date",
                  value: appointmentDate!,
                ),
              ),
              ActionButtons(
                onReschedule: onReschedule,
                onCancel: onCancel,
                onAccept: onAccept,
              ),
            ],
          ),
          const SizedBox(height: 15),
          ProfileInfoRow(
            label: "Time:",
            value: appointmentTime!,
          ),
          const SizedBox(height: 15),
          ProfileInfoRow(
            label: "Note",
            value: note!,
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

class ActionButtons extends StatelessWidget {
  final VoidCallback? onReschedule;
  final VoidCallback? onCancel;
  final VoidCallback? onAccept;
  final bool createdByMe;

  const ActionButtons({
    super.key,
    this.onReschedule,
    this.onCancel,
    this.createdByMe=false,
    this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (onReschedule != null)
          CustomIconButton(
            icon: Assets.webEditIc,
            label: "Reschedule",
            onPressed: onReschedule!,
            backgroundColor: AppColors.greyDark,
            textColor: AppColors.white,
          ),
        const SizedBox(width: 10),
        if (onCancel != null )
          CustomIconButton(
            icon: Assets.webDelete,
            label: "Cancel",
            backgroundColor: AppColors.greyDark,
            textColor: AppColors.white,
            borderColor: AppColors.white,
            onPressed: onCancel!,
          ),
        const SizedBox(width: 10),
        if (onAccept != null)
          CustomIconButton(
            icon: Assets.webTrend,
            label: "Accept",
            backgroundColor: AppColors.white,
            textColor: AppColors.black,
            onPressed: onAccept!,
          ),
      ],
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String? label;
  final String? value;

  const ProfileInfoRow({this.label, this.value, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label!,
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColors.greyWhite,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          value!,
          style: context.textTheme.bodyLarge?.copyWith(
            color: AppColors.greyWhite,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
