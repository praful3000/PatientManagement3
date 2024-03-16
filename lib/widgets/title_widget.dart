import 'package:patient_management/utils/colors.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  const TitleWidget(
      {super.key, required this.title, this.trailing, this.onTap});

  final String title;
  final String? trailing;
  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailing != null)
          InkWell(
            onTap: () {
              onTap!();
            },
            child: Text(
              trailing!,
              style: const TextStyle(
                color: AppColors.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.underline,
                decorationColor: AppColors.primaryColor,
                height: 0,
              ),
            ),
          )
      ],
    );
  }
}
