import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sportsnews/consts/global_colors.dart';
import 'package:sportsnews/models/main_categories.dart';
import 'package:sportsnews/services/utils.dart';

class CategoryBox extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  CategoryBox(
      {Key? key,
      required this.data,
      this.isSelected = false,
      this.onTap,
      this.selectedColor = actionColor})
      : super(key: key);
  final MainCategories data;
  final Color selectedColor;
  final bool isSelected;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Color color = Utils(context).getColor;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastOutSlowIn,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: isSelected ? red : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: const Offset(1, 1), // changes position of shadow
                    ),
                  ],
                  shape: BoxShape.circle),
              child: SvgPicture.asset(
                data.svg,
                // ignore: deprecated_member_use
                color: isSelected ? selectedColor : textColor,
                width: 30,
                height: 30,
              )),
          const SizedBox(
            height: 10,
          ),
          Text(
            data.name,
            maxLines: 1,
            overflow: TextOverflow.fade,
            style: TextStyle(color: color, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
