import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../utils/widgets/shimmer.dart';

class PostImage extends StatelessWidget {
  final double size;
  final String? url;
  final bool selectFiles;

  const PostImage({
    Key? key,
    this.size = 32,
    this.url,  this.selectFiles = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('url');
    print(url);
    return SizedBox(
      width: size,
      // height: size,
      child: url != null
          ? Container(
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.tileColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: CachedNetworkImage(
            fit: BoxFit.cover,
            // height: size,
            width: size,
            imageUrl: url!,
            placeholder: (context, url) => ShimmerSquare(size:  size),
            errorWidget: (context, ur, error) {
              debugPrint('error cached image $url $error ');
              return _postImageErrorWidget();
            }),
      )
          :_postImageErrorWidget(),
    );
  }
}

Widget _postImageErrorWidget() => Image.asset(
  "assets/logo.png",
  fit: BoxFit.cover,
);

