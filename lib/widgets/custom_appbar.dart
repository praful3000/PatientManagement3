import 'package:flutter/material.dart';

customAppbar(String title, {String? subTitle = '', List<Widget>? actions}) {
  return AppBar(
    centerTitle: false,
    backgroundColor: Colors.white,
    elevation: 0,
    surfaceTintColor: Colors.white,
    title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title),
      if (subTitle != '')
        Text(
          subTitle!,
          style: const TextStyle(
              color: Colors.grey, fontSize: 12, fontWeight: FontWeight.normal),
        ),
    ]),
    actions: actions,
  );
}
