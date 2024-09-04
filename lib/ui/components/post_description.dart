import 'package:flutter/material.dart';
import 'package:zoftcares/models/post_model.dart';

import '../../main.dart';

class PostDescription extends StatelessWidget {
  final PostModel postModel;
  const PostDescription({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(postModel.title ?? "",style: Theme.of(navigatorKey.currentContext!)
            .textTheme
            .labelMedium!,),
        SizedBox(height: 10,),
        Text(postModel.body ?? "",style: Theme.of(navigatorKey.currentContext!)
            .textTheme
            .bodyMedium!,),
      ],
    );
  }
}
