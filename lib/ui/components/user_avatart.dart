import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final double size;
  final String url;
  const UserAvatar({super.key,required this.url,this.size = 30});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircleAvatar(backgroundImage: NetworkImage(url),),
    );
  }
}
