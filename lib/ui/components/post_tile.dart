import 'package:flutter/material.dart';
import 'package:zoftcares/main.dart';
import 'package:zoftcares/models/post_model.dart';
import 'package:zoftcares/ui/components/post_description.dart';
import 'package:zoftcares/ui/components/post_image.dart';

class PostTile extends StatelessWidget {
  final PostModel postModel;

  const PostTile({super.key, required this.postModel});

  @override
  Widget build(BuildContext context) {
    return  _postDetails();
  }

  Widget _postDetails() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PostImage(
            url: postModel.image,
            size: MediaQuery.of(navigatorKey.currentContext!).size.width - 16),
        SizedBox(height: 10),
        PostDescription(postModel: postModel,),
        SizedBox(height: 10),
        Divider(height: 1,color: Colors.grey,)
      ],
    );
  }
}
