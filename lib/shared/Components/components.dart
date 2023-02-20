import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task_pos/models/note_model.dart';
import 'package:task_pos/shared/Responsive/responsive.dart';
import 'package:task_pos/shared/Theme/Colors/colors.dart';
import 'package:task_pos/shared/Theme/TextStyles/textstyle.dart';

PreferredSizeWidget myAppBar(
  context, {
  required String title,
  List<Widget>? actions,
  bool isBack = false,
}) {
  return AppBar(
    title: Text(
      title,
      style: AppTextStyle.title,
    ),
    backgroundColor: AppColors.mainColor,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.deepPurple.shade900,
    ),
    actions: actions,
    leading: isBack
        ? IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ))
        : null,
  );
}

class NotesItem extends StatelessWidget {
  final NoteModel model;
  final VoidCallback onPressed;

  const NotesItem({Key? key, required this.model, required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: rwidth(context),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  model.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.noteTextStyle,
                ),
              ),
              SizedBox(
                width: rwidth(context) / 20,
              ),
              Padding(
                padding: EdgeInsets.only(right: rwidth(context) / 50),
                child: IconButton(
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.edit,
                      size: 28,
                    )),
              )
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: rwidth(context),
            height: 1,
            color: Colors.grey.shade400,
          )
        ],
      ),
    );
  }
}

class AddUserFormField extends StatelessWidget {
  final String text;
  final String errorText;
  final TextInputType keyboard;
  final bool? isPassword;
  final Widget? suffix;
  final TextEditingController controller;
  final VoidCallback? ontap;

  const AddUserFormField(
      {Key? key,
      required this.text,
      required this.errorText,
      required this.controller,
      this.suffix,
      this.ontap,
      required this.keyboard,
      this.isPassword})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      obscureText: isPassword ?? false,
      onTap: ontap,
      validator: (value) {
        if (value!.isEmpty) {
          return errorText;
        }
        {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: text,
        suffixIcon: suffix,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

Future<bool?> showToast({required String text, required Color color}) {
  return Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0);
}
