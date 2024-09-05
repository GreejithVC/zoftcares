import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

class ShimmerTile extends StatelessWidget {
  const ShimmerTile({super.key});

  @override
  Widget build(final BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _itemView(height: 200),
        SizedBox(height: 10),
        _itemView(),
        SizedBox(height: 5),
        _itemView(),
        SizedBox(height: 10),
        _itemView(),
        SizedBox(height: 5),
        _itemView(),
        SizedBox(height: 10),
      ],
    );
  }

  Widget _itemView({double? height}) {
    return ColoredBox(
      color: AppColors.greyColor,
      child: SizedBox(height: height ?? 6, width: double.infinity),
    );
  }
}
