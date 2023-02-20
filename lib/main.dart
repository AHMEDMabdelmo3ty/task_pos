import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_pos/Network/remote/dio_helper.dart';
import 'package:task_pos/bloc/Notes/notes_cubit.dart';
import 'package:task_pos/bloc/Notes/notes_states.dart';
import 'package:task_pos/module/note_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotesCubit()
        ..getAllNotes()
        ..getAllUsers()
        ..getAllInteres()
        ..createDatabase(),
      child: BlocConsumer<NotesCubit, NotesStates>(
        listener: (context, state) {},
        builder: (context, states) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
            home: NoteListScreen(),
          );
        },
      ),
    );
  }
}
