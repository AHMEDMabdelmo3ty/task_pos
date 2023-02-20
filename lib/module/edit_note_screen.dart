import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_pos/bloc/Notes/notes_cubit.dart';
import 'package:task_pos/bloc/Notes/notes_states.dart';
import 'package:task_pos/models/note_model.dart';
import 'package:task_pos/module/note_list_screen.dart';
import 'package:task_pos/shared/Components/components.dart';
import 'package:task_pos/shared/Responsive/responsive.dart';

class EditNoteScreen extends StatelessWidget {
  final NoteModel noteModel;
  const EditNoteScreen({Key? key, required this.noteModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotesCubit.get(context).editNoteController.text = noteModel.text;
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {
        if (state is UpdateNotesSuccess) {
          showToast(
              text: 'Note has been Edited successfully', color: Colors.grey);
          NotesCubit.get(context).getAllNotes().then((value) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return NoteListScreen();
            }));
          });
        }
      },
      builder: (context, state) {
        NotesCubit cubit = NotesCubit.get(context);
        return Scaffold(
          appBar: myAppBar(context, title: 'Edit Note', isBack: true, actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                  onPressed: () {
                    cubit.updateNote(
                      id: noteModel.id,
                      text: cubit.editNoteController.text,
                      userId: cubit.selectedUserID,
                    );
                  },
                  icon: const Icon(
                    Icons.save_as_outlined,
                    size: 28,
                  )),
            )
          ]),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: rwidth(context) / 30,
                vertical: rhight(context) / 30),
            child: Column(
              children: [
                TextFormField(
                  minLines: 1,
                  maxLines: 8,
                  controller: cubit.editNoteController,
                  decoration: InputDecoration(
                      labelText: 'Note',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      )),
                ),
                SizedBox(
                  height: rhight(context) / 40,
                ),
                DropdownButtonFormField<String>(
                  value: '0',
                  alignment: Alignment.centerLeft,
                  decoration: InputDecoration(
                      labelText: 'Assign To User',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10))),
                  items: cubit.userIdname.entries.map((e) {
                    return DropdownMenuItem<String>(
                      value: e.key,
                      child: Text(e.value),
                    );
                  }).toList(),
                  onChanged: (val) {
                    cubit.changeAssignUser(val);
                  },
                  borderRadius: BorderRadius.circular(10),
                  icon: const Icon(
                    Icons.arrow_drop_down_outlined,
                    size: 30,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
