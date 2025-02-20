import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit.dart';
import 'package:reentry/ui/modules/organizations/cubit/organization_cubit_state.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';

import '../../../components/buttons/primary_button.dart';

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
      return Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(data.data.name),
            Text(data.data.email.toString()),
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
}
