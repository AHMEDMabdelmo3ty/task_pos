import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_pos/bloc/Notes/notes_cubit.dart';
import 'package:task_pos/bloc/Notes/notes_states.dart';
import 'package:task_pos/module/add_user_screen.dart';
import 'package:task_pos/module/edit_note_screen.dart';
import 'package:task_pos/module/options_screen.dart';
import 'package:task_pos/shared/Components/components.dart';
import 'package:task_pos/shared/Methods/shared_method.dart';
import 'package:task_pos/shared/Responsive/responsive.dart';
import 'package:task_pos/shared/Theme/Colors/colors.dart';

// ignore: must_be_immutable
class NoteListScreen extends StatelessWidget {
  bool? isBottomSheet;

  NoteListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotesCubit, NotesStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var scaffoldKey = GlobalKey<ScaffoldState>();
        NotesCubit cubit = NotesCubit.get(context);
        return Scaffold(
          resizeToAvoidBottomInset: false,
          key: scaffoldKey,
          appBar: myAppBar(context, title: 'Notes', actions: [
            IconButton(
                onPressed: () {
                  navigateTo(context, const AddUserScreen());
                },
                icon: const Icon(Icons.person_add)),
            IconButton(
                onPressed: () {
                  navigateTo(context, const OptionsScreen());
                },
                icon: const Icon(Icons.settings)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
          ]),
          floatingActionButton: FloatingActionButton(
            backgroundColor: AppColors.mainColor,
            onPressed: () {
              if (isBottomSheet ?? false) {
                if (cubit.formKey2.currentState!.validate()) {
                  cubit
                      .addNote(
                          text: cubit.noteTextController.text,
                          userId: cubit.selectedUserID)
                      .then((value) {
                    Navigator.pop(context);
                    isBottomSheet = false;
                  });
                }
              } else {
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(25))),
                    context: context,
                    builder: (context) {
                      return BlocConsumer<NotesCubit, NotesStates>(
                        listener: (context, states) {
                          if (states is InsertToSqfLiteSuccess) {
                            showToast(
                                text: 'Inserted To SQfLite Success',
                                color: Colors.green);
                            Navigator.pop(context);
                          }
                        },
                        builder: (context, states) {
                          NotesCubit cubit2 = NotesCubit.get(context);
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade300),
                              child: Form(
                                key: cubit.formKey2,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AddUserFormField(
                                        text: 'Note Text',
                                        errorText: 'Must not be empty',
                                        controller: cubit2.noteTextController,
                                        keyboard: TextInputType.name),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    DropdownButtonFormField<String>(
                                      value: '0',
                                      alignment: Alignment.centerLeft,
                                      decoration: InputDecoration(
                                          labelText: 'Assign To User',
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10))),
                                      items: cubit2.userIdname.entries.map((e) {
                                        return DropdownMenuItem<String>(
                                          value: e.key,
                                          child: Text(e.value),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        cubit2.changeAssignUser(val);
                                      },
                                      borderRadius: BorderRadius.circular(10),
                                      icon: const Icon(
                                        Icons.arrow_drop_down_outlined,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    SizedBox(
                                      width: rwidth(context) / 4,
                                      child: MaterialButton(
                                        height: rhight(context) / 20,
                                        onPressed: () {
                                          if (NotesCubit.get(context)
                                              .formKey2
                                              .currentState!
                                              .validate()) {
                                            cubit2.changedataSource
                                                ? cubit2.insertToDatabase(
                                                    title:
                                                        cubit2
                                                            .noteTextController
                                                            .text,
                                                    date: DateFormat(
                                                            "yyy-MM-dd'T'hh:mm:ss")
                                                        .format(DateTime.now())
                                                        .toString(),
                                                    userId: cubit2
                                                        .selectedUserID)
                                                : cubit2
                                                    .addNote(
                                                        text: cubit2
                                                            .noteTextController
                                                            .text,
                                                        userId: cubit2
                                                            .selectedUserID)
                                                    .then((value) {
                                                    cubit2
                                                        .getAllNotes()
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    });
                                                  });
                                          }
                                        },
                                        color: AppColors.mainColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: states is AddNoteLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                ),
                                              )
                                            : const Icon(
                                                Icons.add,
                                                color: Colors.white,
                                              ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    });
              }
            },
            child: state is AddNoteLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.add,
                    size: 28,
                    color: Colors.white,
                  ),
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: rwidth(context) / 30,
                vertical: rhight(context) / 50),
            child: Column(
              children: [
                Row(
                  children: [
                    PopupMenuButton(
                      icon: const Icon(Icons.sort),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      itemBuilder: (context) {
                        return cubit.userIdname.entries.map((e) {
                          return PopupMenuItem<String>(
                            value: e.key,
                            child: Text(e.value),
                          );
                        }).toList();
                      },
                      onSelected: (value) {
                        cubit.searchByUserID(value.toString());
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                        onPressed: () {
                          cubit.changeSearch();
                        },
                        icon: const Icon(
                          Icons.search,
                          size: 30,
                          color: Colors.black,
                        )),
                    const SizedBox(
                      width: 5,
                    ),
                    if (cubit.isSearch)
                      Expanded(
                        child: TextFormField(
                          autofocus: true,
                          controller: cubit.searchController,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              hintText: 'Search by Text',
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    cubit.closeSearch();
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    size: 20,
                                  ))),
                          onChanged: (value) {
                            cubit.searchByText(value);
                          },
                        ),
                      ),
                  ],
                ),
                SizedBox(
                  height: rhight(context) / 30,
                ),
                cubit.notesList != null &&
                        cubit.usersList != null &&
                        cubit.isSearch == false &&
                        cubit.searchedbyUserIdnotes == null
                    ? Expanded(
                        child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return NotesItem(
                                model: cubit.notesList![index],
                                onPressed: () {
                                  navigateTo(
                                      context,
                                      EditNoteScreen(
                                        noteModel: cubit.notesList![index],
                                      ));
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const SizedBox(
                                height: 10,
                              );
                            },
                            itemCount: cubit.notesList!.length),
                      )
                    : cubit.isSearch && cubit.searchednotes != null
                        ? Expanded(
                            child: ListView.separated(
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return NotesItem(
                                    model: cubit.searchednotes![index],
                                    onPressed: () {
                                      navigateTo(
                                          context,
                                          EditNoteScreen(
                                            noteModel:
                                                cubit.searchednotes![index],
                                          ));
                                    },
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(
                                    height: 10,
                                  );
                                },
                                itemCount: cubit.searchednotes!.length),
                          )
                        : cubit.searchedbyUserIdnotes != null
                            ? Expanded(
                                child: ListView.separated(
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return NotesItem(
                                        model:
                                            cubit.searchedbyUserIdnotes![index],
                                        onPressed: () {
                                          navigateTo(
                                              context,
                                              EditNoteScreen(
                                                noteModel: cubit
                                                        .searchedbyUserIdnotes![
                                                    index],
                                              ));
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 10,
                                      );
                                    },
                                    itemCount:
                                        cubit.searchedbyUserIdnotes!.length),
                              )
                            : Expanded(
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.mainColor,
                                  ),
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
