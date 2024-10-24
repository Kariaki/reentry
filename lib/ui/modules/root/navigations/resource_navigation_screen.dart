import 'package:flutter/material.dart';
import 'package:reentry/core/extensions.dart';
import 'package:reentry/core/theme/colors.dart';
import 'package:reentry/ui/modules/messaging/components/chat_list_component.dart';

import '../../../components/scaffold/base_scaffold.dart';

class ResourcesNavigationScreen extends StatelessWidget {
  const ResourcesNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.height,
        Text('Resources', style: context.textTheme.titleSmall),
        20.height,
        ListView.builder(
            itemCount: 5,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return _resourceComponent();
            })
      ],
    ));
  }

  /*
  ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: ,
              title: ,
              subtitle: ,
            )
   */
  Widget _resourceComponent() {
    return Builder(
        builder: (context) => Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 64,
                width: 64,
                child: Image.network('https://cdn.prod.website-files.com/620ec747459e13c7cf12a39e/625b10a58137b364b18df2ea_iStock-94179607.jpg',fit: BoxFit.cover,),
              ),
              15.width,
              Expanded(child:   Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'California Ends Strict Virus Restriction as New cases fall',
                    style: context.textTheme.bodyMedium,
                  ),
                  10.height,
                  Text('2h ago by Isabella Kwa',style: context.textTheme.bodyMedium?.copyWith(color: AppColors.gray2),)
                ],
              ))
            ],
          ),
        ));
  }
}
