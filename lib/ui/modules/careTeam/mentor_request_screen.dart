import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/model/client_dto.dart';
import 'package:reentry/ui/components/error_component.dart';
import 'package:reentry/ui/components/loading_component.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/components/user_info_component.dart';
import 'package:reentry/ui/modules/clients/bloc/client_cubit.dart';
import 'package:reentry/ui/modules/clients/bloc/client_state.dart';
import 'package:reentry/ui/modules/careTeam/modal/mentor_request_modal.dart';

class MentorRequestScreen extends HookWidget {
  const MentorRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<RecommendedClientCubit>().fetchRecommendedClients();
    }, []);
    return BaseScaffold(child: BlocBuilder<RecommendedClientCubit, ClientState>(
        builder: (context, state) {
      if (state is ClientLoading) {
        return const LoadingComponent();
      }
      if (state is ClientDataSuccess) {
        final items = state.data;
        if (items.isEmpty) {
          return ErrorComponent(
            title: 'No result found!',
            description: "No request right now, try again.",
            onActionButtonClick: () {
              context.read<RecommendedClientCubit>().fetchRecommendedClients();
            },
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.height,
            Text('Recommended Clients', style: context.textTheme.titleSmall),
            20.height,
            ListView.builder(
                itemCount: items.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return clientRequestComponent(items[index]);
                })
          ],
        );
      }
      return ErrorComponent(
        title: "Something went wrong!",
        description: "Unable to fetch requests, please try again",
        onActionButtonClick: () {
          context.read<RecommendedClientCubit>().fetchRecommendedClients();
        },
      );
    }));
  }

  Widget clientRequestComponent(ClientDto client) {
    return Builder(builder: (context) {
      return ClientComponent(
        size: 40,
        name: client.name,
        onTap: () {
          context.showModal(MentorRequestModal(client: client));
        },
      );
    });
  }
}
