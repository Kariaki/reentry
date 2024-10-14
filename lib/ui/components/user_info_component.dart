import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/style/app_styles.dart';
import 'package:reentry/ui/components/user_avatart.dart';

class UserInfoComponent extends StatelessWidget {
  final String? url;
  final double size;
  final String name;

  const UserInfoComponent({super.key, this.url, required this.name,this.size=30});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UserAvatar(url: url ?? '',size: size,),
        10.width,
        Text(
          name,
          style: Theme.of(context).textTheme.bodyLarge,
        )
      ],
    );
  }
}
