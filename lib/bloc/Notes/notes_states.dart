abstract class NotesStates {}

class NotesInitState extends NotesStates {}

class ChangeSearch extends NotesStates {}

class ChangeDataSource extends NotesStates {}

class ChangeSelectedValue extends NotesStates {}

class ChangeVisibilty extends NotesStates {}

//// GET ALL NOTES
class GetAllNotesLoading extends NotesStates {}

class GetAllNotesSuccess extends NotesStates {}

class GetAllNotesError extends NotesStates {
  final String error;
  GetAllNotesError({required this.error});
}

//Get ALL USERS
class GetAllUsersSuccess extends NotesStates {}

class GetAllUsersError extends NotesStates {
  final String error;
  GetAllUsersError({required this.error});
}

//UPDATE NOTE
class UpdateNotesSuccess extends NotesStates {
  final String message;
  UpdateNotesSuccess({required this.message});
}

class UpdateNotesError extends NotesStates {
  final String error;
  UpdateNotesError({required this.error});
}

//Get All Interests
class GetAllInterestsSuccess extends NotesStates {}

class GetAllInterestsError extends NotesStates {}

//Add User
class AddUserLoading extends NotesStates {}

class AddUserSuccess extends NotesStates {
  final String message;
  AddUserSuccess({required this.message});
}

class AddUserError extends NotesStates {
  final String error;
  AddUserError({required this.error});
}

//SEARCH BY TEXT

class SearchBytText extends NotesStates {}

// ADD NOTES
class AddNoteLoading extends NotesStates {}

class AddNotesSuccess extends NotesStates {
  final String message;
  AddNotesSuccess({required this.message});
}

class AddNotesError extends NotesStates {}

/// SQFLITE
class CreateSqfLiteSuccess extends NotesStates {}

class CreateSqfLiteError extends NotesStates {}

class InsertToSqfLiteSuccess extends NotesStates {}
