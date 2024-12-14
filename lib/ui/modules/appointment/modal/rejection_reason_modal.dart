import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/input/input_field.dart';
import '../../../../core/theme/colors.dart';
import '../../../components/buttons/primary_button.dart';

class RejectionReasonModal extends HookWidget {

  const RejectionReasonModal({super.key});

  @override
  Widget build(BuildContext context) {
    final rejectionController = useTextEditingController();
    final textTheme = context.textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.height,
          Text(
            'Reason for rejection',
            style: textTheme.bodyMedium
                ?.copyWith(color: AppColors.white.withOpacity(.75)),
          ),
          15.height,
          InputField(
            hint: 'Enter a reason for your rejection',
            radius: 5,
            controller: rejectionController,
            lines: 3,
            label: 'Reason',
          ),
          20.height,
          PrimaryButton(
            text: 'Done',
            onPress: () {
              context.popRoute(result: rejectionController.text);
            },
          ),
          20.height,
        ],
      ),
    );
  }
}