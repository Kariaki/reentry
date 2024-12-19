import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/style/app_styles.dart';
import 'package:reentry/ui/components/user_avatart.dart';

class UserInfoComponent extends StatelessWidget {
  final String? url;
  final double size;
  final String name;
  final String? description;

  const UserInfoComponent(
      {super.key, this.url, required this.name,this.description, this.size = 30});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        UserAvatar(
          url: url ?? 'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png?20150327203541',
          size: size,
        ),
        10.width,
       Column(
         mainAxisAlignment: MainAxisAlignment.center,
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(
             name,
             style: Theme.of(context).textTheme.bodyLarge,
           ),
           if(description!=null)
             ...[
               5.height,
               Text(description!,style: Theme.of(context).textTheme.bodyMedium,)
             ]
         ],
       )
      ],
    );
  }
}

class ClientComponent extends StatelessWidget {
  const ClientComponent(
      {super.key,
      this.url,
      required this.size,
      required this.name,
      this.onTap});

  final String? url;
  final double size;

  final String name;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.textTheme;
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        height: 40,
        width: 40,
        child: CircleAvatar(
          backgroundImage: NetworkImage(url ?? ''),
        ),
      ),
      contentPadding: const EdgeInsets.all(0),
      title: Text(
        name,
        style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        'Peer ',
        style: theme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      ),
    );
  }
}
