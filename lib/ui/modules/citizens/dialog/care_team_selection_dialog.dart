import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/data/enum/account_type.dart';
import 'package:reentry/data/model/user_dto.dart';
import 'package:reentry/ui/modules/shared/cubit_state.dart';
import '../../../../core/const/app_constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../components/buttons/primary_button.dart';
import '../../../components/error_component.dart';
import '../../../components/input/input_field.dart';
import '../../../components/loading_component.dart';
import '../../../components/user_info_component.dart';
import '../../shared/cubit/admin_cubit.dart';
import '../bloc/citizen_profile_cubit.dart';
import '../bloc/citizen_profile_state.dart';

class CareTeamSelectionDialog extends HookWidget {
  final Function(List<String>) onResult;
  final List<UserDto> preselected;

  const CareTeamSelectionDialog({super.key, required this.onResult,this.preselected=const []});

  @override
  Widget build(BuildContext context) {
    final selectedUser = useState<List<UserDto>>(preselected);

    final searchController = useSearchController();
    final data = useState<List<UserDto>>([]);
    return BlocProvider(
      create: (context) => AdminUserCubitNew()..fetchNonCitizens(),
      child: BlocConsumer<AdminUserCubitNew, MentorDataState>(
          listener: (_, state) {
        if (state.state is CubitStateSuccess) {
          data.value = state.data;
        }
      }, builder: (ctx, state) {
        return HookBuilder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        context.popBack();
                      },
                      child: const Icon(
                        Icons.close,
                        color: AppColors.white,
                      ),
                    ),
                    10.width,
                    Text(
                      'Select care team',
                      style: context.textTheme.titleSmall
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
                20.height,
                if (state.state is CubitStateSuccess) ...[
                  InputField(
                    controller: searchController,
                    hint: 'Search by name, email, account type',
                    onChange: (value) {
                      data.value = state.data
                          .where((e) =>
                              e.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              e.accountType.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              (e.email
                                      ?.toLowerCase()
                                      .contains(value.toLowerCase()) ??
                                  false))
                          .toList();
                    },
                    radius: 10.0,
                    preffixIcon: const Icon(
                      CupertinoIcons.search,
                      color: AppColors.white,
                    ),
                  ),
                  10.height
                ],
                Expanded(child: Builder(builder: (context) {
                  if (state.state is CubitStateLoading) {
                    return const LoadingComponent();
                  }
                  if (state.state is CubitStateError) {
                    return ErrorComponent(
                      title: "Something went wrong!",
                      description: "There is no one here, try refreshing",
                      onActionButtonClick: () {
                        ctx.read<AdminUserCubitNew>().fetchNonCitizens();
                      },
                    );
                  }
                  if (state.state is CubitStateSuccess) {
                    if (data.value.isEmpty) {
                      return const ErrorComponent(
                        showButton: false,
                        title: "Ooops! Nothing is here",
                      );
                    }
                    return buildListView(data, selectedUser);
                  }
                  return const ErrorComponent(
                    showButton: false,
                  );
                })),
                50.height,
                if (state.state is CubitStateSuccess)
              BlocConsumer<CitizenProfileCubit, CitizenProfileCubitState>(builder: (context,state){
                return     PrimaryButton(
                  text: 'Match to citizen',
                  loading: state.state is RefreshCitizenProfile,
                  enable: selectedUser.value.isNotEmpty,
                  onPress: () {

                    final assignees = selectedUser.value.map((e)=>e.userId!).toList();
                   context.read<CitizenProfileCubit>().updateAndRefreshCareTeam(assignees);
                  },
                );
              }, listener: (_,state){
                if(state.state is CubitStateSuccess){
                  context.showSnackbarSuccess('Matching updated');
                  final assignees = selectedUser.value.map((e)=>e.userId!).toList();
                  onResult(assignees);
                  context.popBack();
                }
              }),
              ],
            ),
          );
        });
      }),
    );
  }

  ListView buildListView(ValueNotifier<List<UserDto>> data,
      ValueNotifier<List<UserDto>> selectedUser) {
    return ListView.builder(
      itemCount: data.value.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final item = data.value[index];
        return selectableUserContainer(
            name: item.name,
            accountType: item.accountType.name.capitalizeFirst(),
            url: item.avatar ?? AppConstants.avatar,
            selected:
                selectedUser.value.map((e) => e.userId).contains(item.userId),
            onTap: (selected) {
              if (selected) {
                selectedUser.value = selectedUser.value
                    .where((e) => e.userId != item.userId)
                    .toList();
                return;
              }
              if (item.accountType == AccountType.mentor) {
                final mentorCount = selectedUser.value
                    .where((e) => e.accountType == AccountType.mentor);
                if (mentorCount.isNotEmpty) {
                  //tell them to deselect current mentor and reselect
                  return;
                }
              }

              if (item.accountType == AccountType.officer) {
                final officerCount = selectedUser.value
                    .where((e) => e.accountType == AccountType.officer);
                if (officerCount.isNotEmpty) {
                  //tell them to deselect current mentor and reselect
                  return;
                }
              }
              selectedUser.value = [...selectedUser.value, item];
            });
      },
    );
  }

  Widget selectableUserContainer(
      {required String name,
      String? url,
      String? accountType,
      bool selected = false,
      required Function(bool) onTap}) {
    return InkWell(
      radius: 50,
      borderRadius: BorderRadius.circular(50),
      onTap: () {
        onTap(selected);
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
                side: BorderSide(
                    color: selected ? AppColors.white : Colors.transparent))),
        child: UserInfoComponent(
          name: name.capitalizeFirst().replaceAll('_', ' '),
          url: url,
          description: accountType,
          size: 40,
        ),
      ),
    );
  }
}
