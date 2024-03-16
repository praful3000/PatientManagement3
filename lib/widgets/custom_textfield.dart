import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {Key? key,
      this.controller,
      required this.hint,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.maxLines = 1,
      this.icon,
      this.onIconPress,
      this.leadIcon,
      this.enabled = true,
      this.onChange})
      : super(key: key);

  final String hint;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final bool obscureText;
  final int maxLines;
  final IconData? icon;
  final Function? onIconPress;
  final Function(String val)? onChange;
  final IconData? leadIcon;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        color: const Color(0xffffffff),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        onChanged: onChange,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          hintStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 17,
            color: Color(0xffb0b0b0),
          ),
          icon: leadIcon != null
              ? Icon(
                  leadIcon,
                  color: Colors.grey,
                  size: 25.0,
                )
              : null,
          suffixIcon: icon != null
              ? InkWell(
                  onTap: () => onIconPress,
                  child: Icon(
                    icon,
                    color: Colors.grey,
                    size: 20.0,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
