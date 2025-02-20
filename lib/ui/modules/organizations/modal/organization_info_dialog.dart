import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/const/app_constants.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit_state.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../../core/theme/colors.dart';
import '../../../components/buttons/primary_button.dart';
import '../../citizens/component/profile_card.dart';

class OrganizationInfoDialog extends StatelessWidget {
  const OrganizationInfoDialog(
      {super.key,
      required this.data,
      this.joined = true,
      required this.callback});

  final FoundOrganization data;
  final void Function() callback;
  final bool joined;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OrganizationCubit, OrganizationCubitState>(
        builder: (context, state) {
      final client = data.data;
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  20.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              client.avatar ?? AppConstants.avatar),
                        ),
                      ),
                      10.width,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            client.organization ?? "",
                            style: const TextStyle(fontSize: 18),
                          ),
                          10.height,
                          Text(
                            "Active since ${client.createdAt?.beautify(wrap: false) ?? ''}",
                            style: context.textTheme.bodySmall?.copyWith(
                              color: AppColors.green,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  15.height,
                  Align(
                    alignment: Alignment.center,
                    child: Wrap(
                      children: [
                        Text(
                          "Total users: ${data.careTeam + data.citizens}",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.greyWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.width,
                        Text(
                          "Care team: ${data.careTeam}",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.greyWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        10.width,
                        Text(
                          "Citizens: ${data.citizens}",
                          style: context.textTheme.bodySmall?.copyWith(
                            color: AppColors.greyWhite,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  2.height,
                  Divider(
                    thickness: .75,
                  ),
                  20.height,
                  const Text(
                    'Organization details',
                    style: TextStyle(fontSize: 20, color: AppColors.white),
                  ),
                  20.height,
                  organizationDetails(
                      title: 'Team lead:', value: client.supervisorsName ?? ''),
                  10.height,
                  organizationDetails(
                      title: 'Email:', value: client.email ?? ''),
                  10.height,
                  organizationDetails(
                      title: 'Phone:', value: client.phoneNumber ?? ''),
                  20.height,
                ],
              ),
            )),
            20.height,
            PrimaryButton(
              loading: state.state is CubitStateLoading,
              text: 'Join Organization',
              onPress: () {
                context
                    .read<OrganizationCubit>()
                    .joinOrganization(data.data.userId ?? '');
              },
            )
          ],
        ),
      );
    }, listener: (_, state) {
      if (state.state is CubitStateSuccess) {
        context.showSnackbarSuccess("Joined organization");
        context.popRoute();
      }
      final cubitState = state.state;
      if (cubitState is CubitStateError) {
        context.showSnackbarError(cubitState.message);
      }
    });
  }

  Widget organizationDetails({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, color: AppColors.greyWhite),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: AppColors.white),
        )
      ],
    );
  }
}
