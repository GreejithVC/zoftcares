import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../utils/widgets/shimmer.dart';

class PostImage extends StatelessWidget {
  final String? url;

  const PostImage({super.key, this.url});

  static const double imageHeight = 200;

  @override
  Widget build(BuildContext context) {
    print('url');
    print(url);
    return url != null
        ? CachedNetworkImage(
            fit: BoxFit.fill,
            height: imageHeight,
            width: double.infinity,
            // imageUrl: url!,
            imageUrl:
                'https://images.pexels.com/photos/307008/pexels-photo-307008.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
            placeholder: (context, url) => ShimmerSquare(height: imageHeight),
            errorWidget: (context, ur, error) {
              debugPrint('error cached image $url $error ');
              return _postImageErrorWidget();
            })
        : _postImageErrorWidget();
  }

  Widget _postImageErrorWidget() => Image.asset(
        "assets/logo.png",
        fit: BoxFit.fitHeight,
        height: imageHeight,
        width: double.infinity,
      );
}
