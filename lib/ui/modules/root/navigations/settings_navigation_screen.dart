import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/core/util/settings_const.dart';
import 'package:reentry/ui/components/scaffold/base_scaffold.dart';
import 'package:reentry/ui/dialog/alert_dialog.dart';
import 'package:reentry/ui/modules/authentication/bloc/account_cubit.dart';
import 'package:reentry/ui/modules/authentication/bloc/auth_events.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_bloc.dart';
import 'package:reentry/ui/modules/authentication/bloc/authentication_state.dart';
import 'package:reentry/ui/modules/authentication/signin_options.dart';

class SettingsItemEntity {
  final String title;
  final IconData icon;
  final String route;

  const SettingsItemEntity({
    required this.title,
    required this.icon,
    required this.route,
  });
}

class SettingsNavigationScreen extends StatelessWidget {
  const SettingsNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(builder: (context, state) {
      return BaseScaffold(
          isLoading: state is AuthLoading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.height,
              Text('Account', style: context.textTheme.titleSmall),
              20.height,
              ...List.generate(SettingsConstants.settingsItem1.length, (index) {
                final item = SettingsConstants.settingsItem1[index];
                return _settingsItem(
                    title: item.title,
                    icon: item.icon,
                    onTap: () {
                      final page = SettingsConstants.settingsRoutes[item.route];
                      if (page == null) {
                        return;
                      }
                      context.pushRoute(page);
                    });
              }),
              20.height,
              Text(
                'More',
                style: context.textTheme.titleSmall,
              ),
              ...List.generate(SettingsConstants.settingsItem2.length, (index) {
                final item = SettingsConstants.settingsItem2[index];
                return _settingsItem(
                    title: item.title,
                    icon: item.icon,
                    onTap: () {
                      print(item.route);
                      final page = SettingsConstants.settingsRoutes[item.route];
                      if (page == null) {
                        return;
                      }
                      context.pushRoute(page);
                    });
              }),
              20.height,
              Align(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    closeApp(context, () {
                      context.read<AuthBloc>().add(LogoutEvent());
                    });
                  },
                  child: Text(
                    'Logout',
                    style: context.textTheme.titleSmall
                        ?.copyWith(color: Colors.red),
                  ),
                ),
              )
            ],
          ));
    }, listener: (_, state) {
      if (state is LogoutSuccess) {
        context.read<AccountCubit>().logout();
        context.pushRemoveUntil(const SignInOptionsScreen());
      }
      if (state is AuthError) {
        context.showSnackbarError(state.message);
        print(state.message);
      }
    });
  }

  void closeApp(BuildContext context, void Function() callback) {
    AppAlertDialog.show(context,
        description: "Are you sure you want to logout?",
        title: "Logout?",
        action: "Logout", onClickAction: () {
      //
      callback();
    });
  }

  Widget _settingsItem(
          {required String title,
          required IconData icon,
          required Function() onTap}) =>
      Builder(
          builder: (context) => ListTile(
                contentPadding: EdgeInsets.all(0),
                leading: Icon(
                  icon,
                  color: AppColors.white,
                ),
                onTap: onTap,
                title: Text(
                  title,
                  style: context.textTheme.bodySmall,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.white,
                ),
              ));
}
