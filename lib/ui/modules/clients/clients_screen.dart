import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/ui/components/app_bar.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/modules/clients/client_profile.dart';
import '../../../data/model/client_dto.dart';
import '../../components/error_component.dart';
import '../../components/loading_component.dart';
import '../../components/user_info_component.dart';
import 'bloc/client_cubit.dart';
import 'bloc/client_state.dart';

class ClientsScreen extends HookWidget {
  final bool startConversation;

  const ClientsScreen({super.key, this.startConversation = false});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      context.read<ClientCubit>().fetchClients();
    }, []);
    return BaseScaffold(
        appBar: const CustomAppbar(
          title: "Sainte",
          showBack: true,
        ),
        child: BlocBuilder<ClientCubit, ClientState>(builder: (context, state) {
          if (state is ClientLoading) {
            return const LoadingComponent();
          }
          if (state is ClientDataSuccess) {
            final items = state.data;
            if (items.isEmpty) {
              return ErrorComponent(
                title: 'No Clients Found!',
                description: "You currently do not have any clients.",
                onActionButtonClick: () {
                  context.read<ClientCubit>().fetchClients();
                },
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.height,
                Text('Your clients', style: context.textTheme.titleSmall),
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
              context.read<ClientCubit>().fetchClients();
            },
          );
        }));
  }

  Widget clientRequestComponent(ClientDto client) {
    return Builder(builder: (context) {
      return ClientComponent(
        size: 40,
        name: client.name,
        url: client.avatar,
        onTap: () {
          if (startConversation) {
            return;
          }
          context.pushRoute(ClientProfileScree(client: client));
        },
      );
    });
  }
}
