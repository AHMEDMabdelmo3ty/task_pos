import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_pos/bloc/Notes/notes_cubit.dart';
import 'package:task_pos/bloc/Notes/notes_states.dart';
import 'package:task_pos/shared/Components/components.dart';
import 'package:task_pos/shared/Responsive/responsive.dart';
import 'package:task_pos/shared/Theme/TextStyles/textstyle.dart';

class OptionsScreen extends StatelessWidget {
  const OptionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, states) {},
      builder: (context, states) {
        NotesCubit cubit = NotesCubit.get(context);
        return Scaffold(
          appBar: myAppBar(context, title: 'Options', isBack: true),
          body: Padding(
            padding: EdgeInsets.symmetric(
                vertical: rhight(context) / 50,
                horizontal: rwidth(context) / 50),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: rwidth(context) / 40),
                      child: SizedBox(
                        width: rwidth(context) / 1.3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Use Local DataBase',
                              style: AppTextStyle.title
                                  .copyWith(color: Colors.black),
                            ),
                            Text(
                              'Instead of using HTTP call to work with the app data, please use SQLite for this.',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyle.noteTextStyle
                                  .copyWith(color: Colors.grey, fontSize: 16),
                            )
                          ],
                        ),
                      ),
                    ),
                    Switch(
                        value: cubit.changedataSource,
                        onChanged: (value) {
                          cubit.changeDataSource(value);
                        })
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
