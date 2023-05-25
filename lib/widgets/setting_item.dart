import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../consts/global_colors.dart';

class SettingItem extends StatelessWidget {
  final String? leadingIcon;
  final Color leadingIconColor;
  final Color bgIconColor;
  final String title;
  final GestureTapCallback? onTap;
  const SettingItem(
      {Key? key,
      required this.title,
      this.onTap,
      this.leadingIcon,
      this.leadingIconColor = Colors.white,
      this.bgIconColor = primary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: leadingIcon != null
              ? [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: bgIconColor, shape: BoxShape.circle),
                    child: SvgPicture.asset(
                      leadingIcon!,
                      // ignore: deprecated_member_use
                      color: leadingIconColor,
                      width: 22,
                      height: 22,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey,
                    size: 17,
                  )
                ]
              : [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: darker,
                    size: 17,
                  )
                ],
        ),
      ),
    );
  }
}
