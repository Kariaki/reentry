import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/ui/components/buttons/primary_button.dart';
import 'package:reentry/ui/components/user_info_component.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_bloc.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_event.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';

class MentorRequestModal extends StatelessWidget {
  final ClientDto client;

  const MentorRequestModal({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<ClientBloc>().state;
    final account = context.read<AccountCubit>().state;
    final textTheme = context.textTheme;
    return BlocListener<ClientBloc, ClientState>(
      listener: (_, state) {
        if (state is ClientError) {
          context.showSnackbarError(state.error);
          context.read<RecommendedClientCubit>().fetchRecommendedClients();
        }
        if (state is ClientSuccess) {
          context.read<RecommendedClientCubit>().fetchRecommendedClients();
          context.popRoute();
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClientComponent(size: 40, name: client.name),
            Text(
              'Reason',
              style: textTheme.bodyMedium
                  ?.copyWith(color: AppColors.white.withOpacity(.75)),
            ),
            5.height,
            Text(
              client.reasonForRequest ?? client.whatYouNeedInAMentor ?? '',
              style: textTheme.bodyMedium,
            ),
            20.height,
            PrimaryButton(
              text: 'Accept',
              loading: state is ClientLoading,
              onPress: () {
                context.read<ClientBloc>().add(ClientActionEvent(client
                        .copyWith(status: ClientStatus.active, assignees: [
                      ...client.assignees,
                      account?.userId ?? ''
                    ])));
              },
            ),
            10.height,
            PrimaryButton.dark(
                text: 'Back',
                onPress: state is ClientLoading
                    ? null
                    : () {
                        context.popRoute();
                      }),
            10.height,
          ],
        ),
      ),
    );
  }
}
