import 'dart:convert';
import 'dart:io';


import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_pos/Network/remote/dio_helper.dart';
import 'package:task_pos/bloc/Notes/notes_states.dart';
import 'package:task_pos/models/interest_model.dart';
import 'package:task_pos/models/note_model.dart';
import 'package:task_pos/models/user_model.dart';

class NotesCubit extends Cubit<NotesStates> {
  NotesCubit() : super(NotesInitState());

  static NotesCubit get(context) => BlocProvider.of(context);

  var formKey = GlobalKey<FormState>();
  var formKey2 = GlobalKey<FormState>();

  /////Search
  TextEditingController searchController = TextEditingController();
  ////Add User
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  ////EditNote
  TextEditingController editNoteController = TextEditingController();

  /// Add Note
  TextEditingController noteTextController = TextEditingController();
  TextEditingController noteDateTimeController = TextEditingController();

  String base64Image='';

  ///
  //get image
  void getImage()async{
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);

    final bytes = File(pickedFile!.path).readAsBytesSync();
     base64Image = base64Encode(bytes);
  }

  static List<String> dropDownItem = ['Football', 'Tennis', 'Tv', 'Movies'];
  String? selectedInterest;

  void changeSelectedVal(value) {
    selectedInterest = value;
    emit(ChangeSelectedValue());
  }

  bool isSecure = true;
  void changevisibilty() {
    isSecure = !isSecure;
    emit(ChangeVisibilty());
  }

  bool isSearch = false;

  void changeSearch() {
    isSearch = true;
    emit(ChangeSearch());
  }

  void closeSearch() {
    isSearch = false;
    emit(ChangeSearch());
  }

  bool changedataSource = false;
  void changeDataSource(bool value) {
    changedataSource = value;
    emit(ChangeDataSource());
  }

/////// API Calling
  //AllNotes
  List<NoteModel>? notesList;
  Future getAllNotes() async {
    emit(GetAllNotesLoading());
    return await DioHelper.getData(path: 'notes/getall').then((value) {
      notesList =
          (value.data as List).map((i) => NoteModel.fromJson(i)).toList();
      emit(GetAllNotesSuccess());
    }).catchError((error) {
      emit(GetAllNotesError(error: error.toString()));
    });
  }

//AllUsers
  List<UserModel>? usersList;
  List<String>? usersName;
  Map<String, String> userIdname = {};
  Future getAllUsers() async {
    return await DioHelper.getData(path: 'users/getall').then((value) {
      usersList =
          (value.data as List).map((i) => UserModel.fromJson(i)).toList();
      usersName = usersList!.map((e) {
        return e.username;
      }).toList();
      usersList!.forEach((element) {
        userIdname.addEntries([MapEntry(element.id, element.username)]);
      });
      emit(GetAllUsersSuccess());
    }).catchError((error) {
      emit(GetAllUsersError(error: error.toString()));
    });
  }

  ///UPDATE NOTE
  String? responseText;
  String selectedUserID = '0';
  void updateNote({
    required String id,
    required String text,
    required String userId,
    String? date,
  }) {
    DioHelper.postData(
      path: 'notes/update',
      data: {
        'Id': id,
        'Text': text,
        'UserId': userId,
        'PlaceDateTime': DateFormat("yyy-MM-dd'T'hh:mm:ss")
            .format(DateTime.now())
            .toString(),
      },
    ).then((value) {
      responseText = value.data;
      emit(UpdateNotesSuccess(message: responseText!));
    }).catchError((error) {
      emit(UpdateNotesError(error: error.toString()));
    });
  }

  void changeAssignUser(value) {
    selectedUserID = value;
    emit(ChangeSelectedValue());
  }

  //Get All Interest

  List<InterestModel>? interestModel;
  void getAllInteres() {
    DioHelper.getData(path: 'intrests/getall').then((value) {
      interestModel =
          (value.data as List).map((i) => InterestModel.fromJson(i)).toList();
      emit(GetAllInterestsSuccess());
    }).catchError((error) {
      emit(GetAllInterestsError());
    });
  }

  //Add User
  void addUser({
    required String userName,
    required String password,
    required String email,
    required String intrestId,
  }) {
    emit(AddUserLoading());
    DioHelper.postData(path: 'users/insert', data: {
      'Username': userName,
      'Password': password,
      'Email': email,
      'ImageAsBase64': base64Image,
      'IntrestId': intrestId,
    }).then((value) {
      emit(AddUserSuccess(message: value.data));
    }).catchError((error) {
      emit(AddUserError(error: error.toString()));
    });
  }

  //SEARCH BY TEXT

  List<NoteModel>? searchednotes;
  void searchByText(String query) {
    final suggestiong = notesList!.where((note) {
      final noteTitle = note.text.toLowerCase();
      final input = query.toLowerCase();
      return noteTitle.contains(input);
    }).toList();
    searchednotes = suggestiong;
    emit(SearchBytText());
  }

  //SEARCH BY User ID

  List<NoteModel>? searchedbyUserIdnotes;
  void searchByUserID(String query) {
    final suggestiong = notesList!.where((note) {
      final noteUserId = note.userId;
      final input = query;
      return noteUserId.contains(input);
    }).toList();
    searchedbyUserIdnotes = suggestiong;
    emit(SearchBytText());
  }

  //Add Note
  Future addNote({
    required String text,
    required String userId,
  }) async {
    emit(AddNoteLoading());
    return await DioHelper.postData(path: 'notes/insert', data: {
      'Text': text,
      'UserId': userId,
      'PlaceDateTime':
          DateFormat("yyy-MM-dd'T'hh:mm:ss").format(DateTime.now()).toString(),
    }).then((value) {
      emit(AddNotesSuccess(message: value.data));
    }).catchError((error) {
      emit(AddNotesError());
    });
  }

  ////SQFLITE
  Database? database;
  void createDatabase() {
    openDatabase(
      'notes.db',
      version: 1,
      onCreate: (database, version) {
        // id integer
        // title String
        // date String
        // time String
        // status String

        database
            .execute('CREATE TABLE notes (note TEXT, date TEXT, userId TEXT)')
            .then((value) {})
            .catchError((error) {});
      },
      onOpen: (database) {},
    ).then((value) {
      database = value;
      emit(CreateSqfLiteSuccess());
    });
  }

  void insertToDatabase({
    required String title,
    required String date,
    required String userId,
  }) async {
    await database!.transaction((txn) {
      return txn
          .rawInsert(
        'INSERT INTO notes(note, date, userId) VALUES("$title", "$date", "$userId")',
      )
          .then((value) {
        emit(InsertToSqfLiteSuccess());
      }).catchError((error) {});
    });
  }
}
