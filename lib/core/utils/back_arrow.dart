import 'package:flutter/material.dart';

class BackArrow extends StatelessWidget {
  const BackArrow({Key? key, this.onPressed , this.color}) : super(key: key);

  final void Function()? onPressed;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ??
          () {
            Navigator.pop(context);
          },
      icon: Icon(
        Icons.arrow_back_ios_new_outlined,
        color:color?? Theme.of(context).iconTheme.color,
      ),
    );
  }
}
