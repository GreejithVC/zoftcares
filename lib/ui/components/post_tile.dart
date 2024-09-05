import 'package:flutter/material.dart';
import 'package:zoftcares/main.dart';
import 'package:zoftcares/models/post_model.dart';
import 'package:zoftcares/ui/components/post_image.dart';

class PostTile extends StatelessWidget {
  final PostModel postModel;

  const PostTile({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return _postDetails();
  }

  Widget _postDetails() {
    return Card(
      color: Colors.white,
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostImage(url: "${postModel.image}.jpeg"),
            SizedBox(height: 10),
            Text(
              postModel.title ?? "",
              style:
                  Theme.of(navigatorKey.currentContext!).textTheme.labelMedium!,
              textAlign: TextAlign.justify,
            ),
            SizedBox(height: 10),
            Text(
              postModel.body ?? "",
              style:
                  Theme.of(navigatorKey.currentContext!).textTheme.bodyMedium!,
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
